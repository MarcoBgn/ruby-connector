require 'spec_helper'

describe BaseAPIManager do

  let(:organization)          { build(:organization, uid: nil, oauth_token: nil, refresh_token: nil, oauth_provider: nil) }
  let(:opts)                  { {:__skip => 0, :__limit => 2} }
  let(:headers_get)           { {"Accept" =>"application/json", "Authorization" =>"Bearer "} }
  let(:response_collection)   { ActionDispatch::Response.new 200, {}, [[{"items" => [{"data" => {"name" => "ITEM 1", "updated_at" => "2016-07-22T08:36:25Z"}}, {"data"=> {"name" => "ITEM 2", "updated_at" => "2016-07-22T08:34:25Z"}}]}]]}
  let(:response_entity)       { ActionDispatch::Response.new 200, {}, [{"data"=> {"name" => "ITEM 2", "updated_at" => "2016-07-22T08:34:25Z"}}]}

  context "Uses RestClient to query the BaseCRM API:" do

    before do
      allow(DataParser).to receive(:from_base_collection) { [{"name" => "ITEM 1", "updated_at" => "2016-07-22T08:36:25Z"}, {"name" => "ITEM 2", "updated_at" => "2016-07-22T08:34:25Z"}]}
      allow(DataParser).to receive(:from_base_single) { response_entity.body}
      allow(DataParser).to receive(:to_base) { response_entity.body}
    end

    context "#get_entities" do
      #The API manager gets rid of the 'data' field before returning the array of entities
      it "Returns a response from the API (last_synchronization_date is present)" do
        allow(JSON).to receive(:parse) { {"meta" => {"links" => {"self" => "https://test.com"}}}}
        allow(RestClient).to receive(:get) { response_collection}
        expect(BaseAPIManager.new(organization).get_entities("contact", {}, Time.parse("2016-07-22T08:35:25Z"))).to eq [{"name" => "ITEM 1", "updated_at" => "2016-07-22T08:36:25Z"}, {"name" => "ITEM 2", "updated_at" => "2016-07-22T08:34:25Z"}]
      end

      it "Makes a custom call using query params (batched_call is true)" do
        allow(JSON).to receive(:parse) { {"meta" => {"links" => {"self" => "https://test.com"}}}}
        expect(RestClient).to receive(:get).with("https://api.getbase.com/v2/contacts?page=1&per_page=2", headers_get) { response_collection}
        BaseAPIManager.new(organization).get_entities("contact", opts)
      end

      it "Stops making requests if the last item's updated_at field of the page fetched is greater than last_synchronization_date" do
        allow(JSON).to receive(:parse) { {"meta" => {"links" => {"next_page" => "https://test.com"}}}}
        expect(RestClient).to receive(:get).with("https://api.getbase.com/v2/contacts?sort_by=updated_at", headers_get) { response_collection}
        expect(RestClient).to receive(:get).with("https://test.com", headers_get) { response_collection}
        #last_synchronization_date is a Time object, passed as a third parameter in #get_entities
        BaseAPIManager.new(organization).get_entities("contact", {}, Time.parse("2016-07-22T08:35:25Z"))
      end

      it "Slices the entities array when both batched_call and last_synchronization_date are present" do
        allow(JSON).to receive(:parse) { {"meta" => {"links" => {"self" => "https://test.com"}}}}
        expect(RestClient).to receive(:get).with("https://api.getbase.com/v2/contacts?page=1&per_page=2&sort_by=updated_at", headers_get) { response_collection}
        expect(BaseAPIManager.new(organization).get_entities("contact", opts, Time.parse("2016-07-22T08:35:25Z"))).to eq [{"name" => "ITEM 1", "updated_at" => "2016-07-22T08:36:25Z"}]
      end
    end

    context "#create entities" do

      it "creates entities" do
        allow(JSON).to receive(:generate) { "Generated JSON"}
        allow(RestClient::Request).to receive(:execute).with(rest_client_arguments_post) { response_entity}
        expect(BaseAPIManager.new(organization).create_entities({"payload" => "test"}, "contact")).
          to eq response_entity.body
      end
    end

    context "#update_entities" do

      it "updates entities" do
        allow(JSON).to receive(:generate) { "Generated JSON"}
        allow(RestClient::Request).to receive(:execute).with(rest_client_arguments_put) { response_entity}
        expect(BaseAPIManager.new(organization).update_entities({"payload" => "test"}, "1", "contact")).
          to eq response_entity.body
      end

      it "raises a custom exception when an entity is not found" do
        allow(RestClient::Request).to receive(:execute).with(rest_client_arguments_put) { raise RestClient::ResourceNotFound.new}
        expect{ BaseAPIManager.new(organization).update_entities({"payload" => "test"}, "1", "contact")}.
          to raise_error { Exceptions::RecordNotFound.new}
      end
    end
  end
end
