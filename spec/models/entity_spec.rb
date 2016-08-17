require 'spec_helper'

describe Maestrano::Connector::Rails::Entity do

  describe 'class methods' do
    subject { Maestrano::Connector::Rails::Entity }

    describe 'id_from_external_entity_hash' do
      it { expect(subject.id_from_external_entity_hash({'id' => '1234'})).to eql('1234') }
    end

    describe 'last_update_date_from_external_entity_hash' do
      it {
        Timecop.freeze(Date.today) do
          expect(subject.last_update_date_from_external_entity_hash({'updated_at' => 1.hour.ago.to_s})).to eql(1.hour.ago.to_s)
        end
      }
    end

    describe 'creation_date_from_external_entity_hash' do
      Timecop.freeze(Date.today) do
        it { expect(subject.creation_date_from_external_entity_hash({'created_at' => 3.hour.ago.to_s})).to eql(3.hour.ago.to_s) }
      end
    end

    describe 'inactive_from_external_entity_hash?' do
      #at the moment there is no way to track deleted contacts from Base
      it { expect(subject.inactive_from_external_entity_hash?({'customer_status' => 'past'})).to eql(false) }
    end
  end

  describe 'instance methods' do

    let(:organization) { create(:organization) }
    let(:client) { BaseAPIManager.new(organization) }
    let(:external_name) { 'external_name' }
    subject { Maestrano::Connector::Rails::Entity.new(organization, nil, client) }

    before {
      allow(subject.class).to receive(:external_entity_name).and_return(external_name)
      allow(RestClient).to receive(:get) { ActionDispatch::Response.new 200, {}, [{"items" => [{"data" => {"id" => 123456}}, {"data" => {"id" => 7891011}}]}]}
      allow(RestClient::Request).to receive(:execute) { {"items" => [{"data" => {"id" => 123456}}, {"data" => {"id" => 7891011}}]}}
      allow(JSON).to receive(:parse) { {"meta" => {"links" => "https://test.com"}}}
      allow(DataParser).to receive(:from_base_collection) { [{"id" => 123456} ,{"id" => 7891011}]}
    }

    describe 'get_external_entities' do

      it 'uses RestCient::Request to query the external API' do
        expect(RestClient).to receive(:get)
        subject.get_external_entities('', nil)
      end

      it 'returns the entities' do
        expect(subject.get_external_entities('', nil)).to eq [{"id"=>123456}, {"id"=>7891011}]
      end
    end

    #Considering that DataParser is tested in its own spec file, the next two specs
    #are testing that the return is the ID of the external entity and the response from RestClient::Request#execute
    describe 'create_external_entity' do
      it 'Posts using BaseAPIManager and returns the external entity' do
        allow_any_instance_of(BaseAPIManager).to receive(:create_entities) { {'id' => 123456, "name" => "test entity"} }
        expect(subject.create_external_entity({}, external_name)).to eql({'id' => 123456, "name" => "test entity"})
      end
    end

    describe 'update_external_entity' do
      it 'PUTs using BaseAPIManager and returns the entity' do
        allow_any_instance_of(BaseAPIManager).to receive(:update_entities) { {'id' => 123456, "name" => "test entity"}}
        expect(subject.update_external_entity({}, '3456', external_name)).to eq({'id' => 123456, "name" => "test entity"})
      end
    end
  end
end
