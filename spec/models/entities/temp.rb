

describe 'instance methods' do
  before do
    allow(BaseCRM::Client).to receive(:new) { "test client"}
  end
  let(:organization) { create(:organization) }
  let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
  let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
  let(:opts) { {} }
  subject { Entities::Person.new(organization, connec_client, external_client, opts) }

  describe 'external to connec!' do
    let(:external_hash) {
      {
      "data"=> {
        "id"=> 134706023,
        "contact_id"=> nil,
        "first_name"=> "John",
        "last_name"=> "Smith",
        "title"=> "Mr",
        "email"=> 'test@email.com',
        "address" => {
            "city" => "London"
        }
      }
    }
  }

    let (:mapped_external_hash) {
      {
        "id" => [{'id' => 134706023, 'provider' => organization.oauth_provider, 'realm' => organization.oauth_uid}],
        "first_name" => "John",
        "last_name" => "Smith",
        "title" => "Mr",
        "email" => "test@email.com",
        "address_work" => {
          "billing" => {
            "city" => 'London'
          }
        }
      }.with_indifferent_access
    }

    it { expect(subject.map_to_connec(external_hash)).to eql(mapped_external_hash) }
  end

  describe 'connec to external' do
    let(:connec_hash) {
      {
        "first_name" => "John",
        "title" => "Mr",
        "address_work" => {
          "billing" => {
            "city" => 'London'
          }
        }
      }
    }

    let(:mapped_connec_hash) {
      { "data" => {
        "title" => 'Mr',
        "first_name" => 'John',
        "address" => {
          "city" => 'London'
          }
        }
      }.with_indifferent_access
    }

    it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }
  end
end
