require 'restclient'

class BaseAPIManager

  def initialize(organization)
    @organization = organization
  end

  #Fetches all the resources for the specific entity
  def get_entities(entity_name, opts = {}, last_synchronization_date = nil)
    with_token_refresh do
      batched_call = opts[:__skip] && opts[:__limit]
      query_params = build_query_params(batched_call, last_synchronization_date, opts)

      response = RestClient.get "https://api.getbase.com/v2/#{entity_name.downcase.pluralize}?#{query_params.to_query}", headers_get
      #the meta field is retrieved indipendently to avoid conflicting with DataParser
      meta = JSON.parse(response)['meta']

      #DataParser strips the response from 'items' and 'data' fields
      entities = DataParser.from_base_collection(response.body)
      #if both batched_call and last_synchronization_date are true the array is sliced
      #before the first entry that is older than last_synchronization_date.
      entities = only_updated_entities(entities, last_synchronization_date) if batched_call && last_synchronization_date

      unless batched_call
        while meta['links']['next_page']
          response = RestClient.get "#{meta['links']['next_page']}", headers_get
          entities.concat DataParser.from_base_collection(response.body)
          raise 'No response received while fetching subsequent page' unless response && !response.body.blank?
          break if last_synchronization_date && entities.last['updated_at'] < last_synchronization_date
          meta = JSON.parse(response)['meta']
        end
      end
      entities
    end
  rescue => e
    Rails.logger.warn "Error while fetching #{entity_name.pluralize}. Error: #{e}"
    raise "Error while fetching #{entity_name}. Error: #{e}"
  end

  #creates an entity with the parameters passed
  def create_entities(mapped_connec_entity, external_entity_name)
    #DataParser adds the 'data' field before pushing to BaseCRM
    body = DataParser.to_base(mapped_connec_entity)
    payload = JSON.generate(body)
    with_token_refresh do
      response = RestClient::Request.execute method: :post, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}",
                                             payload: payload, headers: headers_post_put
      DataParser.from_base_single(response.body)
    end
  rescue => e
    standard_rescue(e, external_entity_name)
  end

  #updates an existing entity with the parameters provided
  def update_entities(mapped_connec_entity, external_id, external_entity_name)
    body = DataParser.to_base(mapped_connec_entity)
    payload = JSON.generate(body)
    with_token_refresh do
      response = RestClient::Request.execute method: :put, url: "https://api.getbase.com/v2/#{external_entity_name.downcase.pluralize}/#{external_id}",
                                             payload: payload, headers: headers_post_put
      DataParser.from_base_single(response.body)
    end
  rescue => e
      if e.class == RestClient::ResourceNotFound
        raise Exceptions::RecordNotFound.new("The record has been deleted in BaseCRM")
      else
        standard_rescue(e, external_entity_name)
      end
  end

  def get_account
    response = RestClient.get "https://api.getbase.com/v2/accounts/self", headers_get
    DataParser.from_base_single(response.body)
  rescue => e
    standard_rescue(e, external_entity_name)
  end

  private

    attr_reader :organization

    def refresh_token(organization)
      AuthClient.refresh_token(organization)
    end

    def with_token_refresh
      yield
    rescue
      refresh_token(organization)
      yield
    end

    def headers_get
      {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{organization.oauth_token}"
      }
    end

    def headers_post_put
      headers_get.merge!("Content-Type" => "application/json")
    end

    def standard_rescue(e, external_entity_name)
      err = e.respond_to?(:response) ? e.response : e
      Rails.logger.warn "Error while posting to #{external_entity_name}: #{err}"
      raise "Error while sending data: #{err}"
    end

    def only_updated_entities(entities, last_synchronization_date)
      first_older_index = entities.index { |entity| entity['updated_at'] < last_synchronization_date}
      first_older_index ||= entities.length
      entities = entities.slice(0, first_older_index)
    end

    def build_query_params(batched_call, last_synchronization_date, opts)
      query_params = batched_call ? QueryParamsManager.batched_call(opts) : {}
      query_params.merge!(QueryParamsManager.by_updated_at) if last_synchronization_date
      query_params
    end
end
