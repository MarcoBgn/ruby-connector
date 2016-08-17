require 'spec_helper'

describe Entities::Company do

describe 'class methods' do
  subject { Entities::Company }

  it { expect(subject.connec_entity_name).to eql('Company') }
  it { expect(subject.external_entity_name).to eql('Account') }
  it { expect(subject.object_name_from_connec_entity_hash({'name' => 'A'})).to eql('A') }
  it { expect(subject.object_name_from_external_entity_hash({'name' => 'A'})).to eql('A') }
end

describe 'instance methods' do

  let(:organization) { create(:organization) }
  let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
  let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
  let(:opts) { {} }
  subject { Entities::Company.new(organization, connec_client, external_client, opts) }

  describe 'external to connec!' do
    let(:external_hash) {
      {
        "id"=> 1,
        "name"=> "Sales Co",
        "currency"=> "GBP",
        "time_format"=> "12H",
        "timezone"=> "UTC-05:00",
        "phone"=> "202-555-0141",
        "created_at"=> "2014-09-28T16:32:56Z",
        "updated_at"=> "2014-09-28T16:32:56Z"
       }
      }

    let (:mapped_external_hash) {
      {
        "id" => [{'id' => 1, 'provider' => organization.oauth_provider, 'realm' => organization.oauth_uid}],
        "name" => "Sales Co",
        "currency"=> "GBP",
        "timezone"=> "-05:00",
        "phone" => {
          "landline" => "202-555-0141",
        }
      }.with_indifferent_access
    }

    it { expect(subject.map_to_connec(external_hash)).to eql(mapped_external_hash) }
  end

  describe 'connec to external' do
    let(:connec_hash) {
        {
          "id"=> "646fea51-3168-0134-575e-0f43369e2e5e",
          "name"=> "Test Company",
          "timezone"=> "-05:00",
          "currency"=> "GBP",
          "email"=> {},
          "address"=> {
            "billing"=> {},
            "billing2"=> {},
            "shipping"=> {},
            "shipping2"=> {}
          },
          "website"=> {},
          "phone"=> {
            "landline" => "0208-203-203"
          },
          "logo"=> {},
          "created_at"=> "2016-07-21T11:58:42Z",
          "updated_at"=> "2016-07-21T11:58:42Z",
          "group_id"=> "cld-9asu",
          "channel_id"=> "org-f6zi",
          "resource_type"=> "company"
      }
    }

    let(:mapped_connec_hash) {
      {
        "name"=> "Test Company",
        "timezone"=> "UTC-05:00",
        "currency"=> "GBP",
        "phone"=> "0208-203-203"
      }.with_indifferent_access
    }

    it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }
  end
 end
end
