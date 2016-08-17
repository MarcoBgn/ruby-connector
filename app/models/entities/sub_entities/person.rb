class Entities::SubEntities::Person < Maestrano::Connector::Rails::SubEntityBase
  def self.external?
    false
  end

  def self.entity_name
    'Person'
  end

  def self.mapper_classes
    {
      'Contact' => Entities::SubEntities::PersonMapper,
      'Lead' => Entities::SubEntities::PersonMapper
    }
  end

  def self.references
    {
      'Contact' => %w(organization_id assignee_id),
      'Lead' => %w(assignee_id)
    }
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end
end
