class Entities::AppUser < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'App user'
  end

  def self.external_entity_name
    'User'
  end

  def self.mapper_class
    AppUserMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end

  def self.inactive_from_external_entity_hash?(entity)
    # This method return true if entity is inactive in the external application
    entity['status'] == 'inactive'
  end

  def self.can_write_external?
    false
  end

  def self.references
    %w(assignee_id)
  end
end

class AppUserMapper
  extend HashMapper

  # Mapping to BaseCRM
  after_normalize do |input, output|
    output[:name] = [input["first_name"], input["last_name"]].join(' ')
    output
  end

  # Mapping to Connec!
  after_denormalize do |input, output|
    output[:first_name] = input['name'].split(' ').first
    output[:last_name] = input['name'].split(' ', 2).last
    output
end

  #map from Connec! to Base
  map from('email/address'), to('email')
  map from('is_admin') {|value| value.to_sym == :admin ? true : false}, to('role') { |value| value == true ? "admin" : "user"}
end
