require "spec_helper"

describe AuthClient do

  it "Stores the URI for the callback" do
    expect(AuthClient::RED_URI).to match /^http.+\/auth\/baseCRM\/callback/
  end

  it "Has a method #authorize that instantiates a OAuth2 object" do
    auth_params = { state: 'uid-123'}
    expect(AuthClient.authorize(auth_params)).to be_a OAuth2::Client
  end

  it "Can be used to request a OAuth authorization code" do
    auth_params = { state: 'uid-123'}
    expect(AuthClient.authorize(auth_params).auth_code.authorize_url).to match /^https:\/\/api.getbase.com\/oauth2\/authorize\?client_id.+response_type=code.+/
  end

  it "Can be used to obtain an OAuth token" do
    expect(AuthClient.obtain_token.token_url).to eq "https://api.getbase.com/oauth2/token"
  end
end
