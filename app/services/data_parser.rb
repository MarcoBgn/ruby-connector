require 'singleton'

class DataParser
  include Singleton

  def self.from_base_collection(entities)
    JSON.parse(entities)['items'].map { |entity| entity['data'] }
  end

  def self.from_base_single(entity)
    output = JSON.parse(entity)
    output['data']
  end

  def self.to_base(entity)
    { "data" => entity}
  end
end
