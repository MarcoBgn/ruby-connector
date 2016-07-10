require 'restclient'

class BaseAPIManager

  def initialize(organization = "default")
    @organization = organization
  end

  #Fetches all the resources for the specific entity
  def get_entities(entity_name = "")
    headers = {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }
  response = RestClient::Request.execute method: :get, url: "https://api.getbase.com/v2/#{entity_name.downcase.pluralize}", headers: headers
  JSON.parse(response)['items']
  end

  #creates an entity with the parameters passed
  def create_entities(mapped_connec_entity, external_entity_name)
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }

    body = mapped_connec_entity

    response = RestClient::Request.execute method: :post, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}",
                                                   payload: body, headers: headers
    Rails.logger.debug {"Creating entity #{external_entity_name}, Response: #{response}"}
    response
  end

  #updates an existing entity with the parameters provided
  def update_entities(mapped_connec_entity, external_id, external_entity_name)
    headers = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{organization.oauth_token}"
    }

    body = mapped_connec_entity

    response = RestClient::Request.execute method: :put, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}/#{external_id}",
                                                   payload: body, headers: headers
    Rails.logger.debug {"Creating entity #{external_entity_name}, Response: #{response}"}
    response
  end

  private
  attr_reader :organization
end
