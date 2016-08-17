require "singleton"

class AuthClient
  include Singleton

  RED_URI = "#{Settings.app_host}/auth/baseCRM/callback"

  #Requests oauth2 code
  def self.authorize(auth_params)
    OAuth2::Client.new(
      ENV['base_client_id'],
      ENV['base_client_secret'],
      site: "https://api.getbase.com",
      authorize_url: "/oauth2/authorize?#{auth_params}"
    )
  end

  #Obtains oauth2 token
  def self.obtain_token
    OAuth2::Client.new(
      ENV['base_client_id'],
      ENV['base_client_secret'],
      site: "https://api.getbase.com",
      token_url: "/oauth2/token"
    )
  end

  def self.refresh_token(organization)
    body = {
      "grant_type" => "refresh_token",
      "refresh_token" => "#{organization.refresh_token}"
    }
    headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Basic #{ENV['base_client_id']}:#{ENV['base_client_secret']}}"
    }
    response = RestClient::Request.execute method: :post, url: "https://api.getbase.com/oauth2/token",
                                           payload: body.to_json, headers: headers
    parsed_response = JSON.parse(response)
    organization.update(
      oauth_token: parsed_response['access_token'],
      refresh_token: parsed_response['refresh_token']
    )
  end
end
