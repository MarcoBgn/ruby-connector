class Entities::Item < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Item'
  end

  def self.external_entity_name
    'Product'
  end

  def self.mapper_class
    ItemMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end

  def self.inactive_from_external_entity_hash?(entity)
    # This method return true if entity is inactive in the external application
    entity['active'] == false
  end
end

class ItemMapper
  extend HashMapper

  after_normalize do |input, output|
    output[:description] = 'This item has no description' if output[:description].empty?
    output[:sku] ||= input['code']
    output[:cost] ||= '0.0'
    output
  end

  #map from Connec! to Base
  map from('name'), to('name')
  map from('reference'), to('sku')
  map from('description'), to('description'), default: 'This item has no description'

  map from('sale_price/total_amount', &:to_f), to('prices[0]/amount', &:to_s), default: 0
  map from('sale_price/currency'), to('prices[0]/currency')

  map from('purchase_price/total_amount', &:to_f), to('cost', &:to_s)
  map from('purchase_price/currency'), to('cost_currency')
end
