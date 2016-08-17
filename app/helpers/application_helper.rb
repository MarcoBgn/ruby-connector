module ApplicationHelper
  include Maestrano::Connector::Rails::SessionHelper

  def beautify_complex_entities(entity_name)
    entity_name.split.map {|i| i != "and" ? i.pluralize.capitalize : i}.join(" ")
  end
end
