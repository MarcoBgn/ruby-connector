require 'bigdecimal'

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
    "#{entity['name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    "#{entity['data']['name']}"
  end
end

class ItemMapper
  extend HashMapper

  map from('name'), to('data/name')
  map from('reference'), to('data/sku')
  map from('description'), to('data/description')

  map from('status') {|value| value == true ? "ACTIVE" : "INACTIVE"}, to('data/active') {|value| "ACTIVE" ? true : false}

  map from('sale_price/total_amount') {|value| BigDecimal.new(value).to_f}, to("data/prices[0]/amount", &:to_s), default: 0
  map from('sale_price/currency'), to("data/prices[0]/currency")

  map from('purchase_price/total_amount') {|value| BigDecimal.new(value).to_f}, to('data/cost', &:to_s)
  map from('purchase_price/currency'), to('data/cost_currency')

  map from('created_at'), to('data/created_at')
  map from('updated_at'), to('data/updated_at')
end
