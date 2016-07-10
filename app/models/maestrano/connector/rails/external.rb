class Maestrano::Connector::Rails::External
  include Maestrano::Connector::Rails::Concerns::External

  def self.external_name
    "BaseCRM"
  end

  def self.get_client(organization)
    BaseCRM::Client.new access_token: organization.oauth_token
  end

  def self.entities_list
    %w(person_and_organization item)
  end

  def self.fetch_company(organization)
    client = BaseCRM::Client.new access_token: organization.oauth_token
    response = client.accounts.self
  end
end
