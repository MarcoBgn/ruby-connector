class Entities::SubEntities::Organization < Maestrano::Connector::Rails::SubEntityBase
  def self.external?
    false
  end

  def self.entity_name
    'Organization'
  end

  def self.mapper_classes
    {
      'Contact' => Entities::SubEntities::OrganizationMapper,
      'Lead' => Entities::SubEntities::OrganizationMapper
    }
  end

  def self.references
    {
      'Lead' => %w(assignee_id)
    }
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end
end
