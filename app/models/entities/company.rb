class Entities::Company < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Company'
  end

  def self.external_entity_name
    'Account'
  end

  def self.mapper_class
    CompanyMapper
  end

  def self.singleton?
    true
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end
end

class CompanyMapper
  extend HashMapper

  #map from Connec! to Base
  map from('name'), to('name')
  map from('currency'), to('currency')
  map from('timezone') {|value| value.scan(/[^UTC]/).join }, to('timezone') { |value| "UTC#{value}"}

  map from('phone/landline'), to('phone')
end
