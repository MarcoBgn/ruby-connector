require "spec_helper"

describe Organization do

    let(:organization) { create(:organization) }
    let(:token) { OpenStruct.new(token: "1111111111222222222233333333336be64736cd44d439b726bf725e665f2737", refresh_token: "test456")}

  describe "#revoke_omniauth" do
    it "sets all the relevant fields to nil" do
      organization.revoke_omniauth
      expect(organization.oauth_token).to be nil
    end
  end

  describe "#update_omniauth" do
    before do
      allow(Maestrano::Connector::Rails::External).to receive (:fetch_company) { OpenStruct.new id: "test-uid"}
    end
    it "fetches and updates the fields with datat from the API" do
      organization.update_omniauth(token)
      expect(organization.oauth_uid).to eq "test-uid"
    end
  end

  describe "#from_omniauth" do
    it "updates the fields with the data received from the API" do
      organization.from_omniauth(token)
      expect(organization.oauth_token).to eq "1111111111222222222233333333336be64736cd44d439b726bf725e665f2737"
    end
  end
end
