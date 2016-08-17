class Maestrano::Connector::Rails::Entity < Maestrano::Connector::Rails::EntityBase
  include Maestrano::Connector::Rails::Concerns::Entity

  # Return an array of entities from the external app
  def get_external_entities(external_entity_name, last_synchronization_date=nil)
    # This method should return only entities that have been updated since the last_synchronization_date
    # It should also implements an option to do a full synchronization when @opts[:full_sync] == true or when there is no last_synchronization_date
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Fetching #{Maestrano::Connector::Rails::External.external_name} #{external_entity_name.pluralize}")
    if @opts[:full_sync] || !last_synchronization_date
      entities = @external_client.get_entities(external_entity_name, @opts)
    else
      #Setting the last argument to true creates a query string that fetches entities sorted_by updated_at
      #stopping requests when the last element of the page is older than last_synchronization_date
      entities = @external_client.get_entities(external_entity_name, @opts, last_synchronization_date)
    end
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Received data: Source=#{Maestrano::Connector::Rails::External.external_name}, Entity=#{external_entity_name}, Response=#{entities}")
    entities
  end

  def create_external_entity(mapped_connec_entity, external_entity_name)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Sending create #{external_entity_name}: #{mapped_connec_entity} to #{Maestrano::Connector::Rails::External.external_name}")
    @external_client.create_entities(mapped_connec_entity, external_entity_name)
  end

  def update_external_entity(mapped_connec_entity, external_id, external_entity_name)
    Maestrano::Connector::Rails::ConnectorLogger.log('info', @organization, "Sending update #{external_entity_name} (id=#{external_id}): #{mapped_connec_entity} to #{Maestrano::Connector::Rails::External.external_name}")
    begin
      @external_client.update_entities(mapped_connec_entity, external_id, external_entity_name)
    rescue Exceptions::RecordNotFound => e
      idmap = Maestrano::Connector::Rails::IdMap.find_by(organization_id: @organization.id, external_id: external_id)
      idmap.update!(message: "The #{external_entity_name} record has been deleted in Base. Last attempt to sync on #{Time.now}", external_inactive: true)
      Rails.logger.warn "#{e}. It is now set to inactive."
    end
  end

  def self.id_from_external_entity_hash(entity)
    # This method return the id from an external_entity_hash
    entity['id']
  end

  def self.last_update_date_from_external_entity_hash(entity)
    # This method return the last update date from an external_entity_hash
    entity['updated_at']
  end

  def self.creation_date_from_external_entity_hash(entity)
    # This method return the creation date from an external_entity_hash
    entity['created_at']
  end

  def self.inactive_from_external_entity_hash?(entity)
    # This method return true if entity is inactive in the external application
    false
  end
end
