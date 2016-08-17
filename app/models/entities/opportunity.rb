class Entities::Opportunity < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Opportunity'
  end

  def self.external_entity_name
    'Deal'
  end

  def self.mapper_class
    OpportunityMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end

  def self.references
    %w(assignee_id lead_id)
  end

  def before_sync(last_synchronization_date = nil)
     @stages = @external_client.get_entities('stages')
     @stages ||= []
  end

  def map_to_connec(entity)
    mapped_entity = super
    #Stages in Base are retrieved through a specific endpoint in the API.
    stage = @stages.find { |stage| stage['id'] == entity['stage_id'] }
    map_sales_stage(mapped_entity, stage) if stage
    mapped_entity
  end

  def map_to_external(entity)
    mapped_entity = super
    #The sales_stages in Base are associated with a unique id. The first step in order
    #to map it to Connec! is to try matching the sales_stage directly.
    stage = @stages.find do |stage|
      if stage['name'] && stage['sales_stage']
        stage['name'].downcase == entity['sales_stage'].downcase
      end
    end
    #If no stage is found with the same name, the one with the closest match
    #between 'likelyhood' (Base) and 'probability' (Connec!) will be selected.
    stage ||= @stages.min_by { |stage| (stage['likelihood'].to_i - entity['probability'].to_i).abs }
    mapped_entity[:stage_id] = stage ? stage['id'] : @stages.first['id']
    mapped_entity
  end

  private

    def map_sales_stage(mapped_entity, stage)
      mapped_entity[:sales_stage] = stage['name']
      mapped_entity[:probability] = stage['likelihood']
      mapped_entity
    end
end

class OpportunityMapper
  extend HashMapper

  after_denormalize do |input, output|
    output[:assignee_type] = "AppUser"
    output
  end

  #map from Connec! to Base
  map from('name'), to('name')
  map from('amount/total_amount', &:to_f), to('value') { |value| value.is_a?(Integer) ? value : value.to_s }

  map from('sales_stage'), to('stage_id')
  map from('expected_close_date'), to('estimated_close_date')
  map from('sales_stage_changes[0]/created_at'), to('last_stage_change_at')

  map from('lead_id'), to('contact_id') { |value| value[0]['id'].to_i}
  map from('assignee_id'), to('owner_id')
end
