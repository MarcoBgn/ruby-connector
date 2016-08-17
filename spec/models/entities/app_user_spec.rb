require 'spec_helper'

describe Entities::AppUser do

describe 'class methods' do
  subject { Entities::AppUser }

  it { expect(subject.connec_entity_name).to eql('App user') }
  it { expect(subject.external_entity_name).to eql('User') }
  it { expect(subject.object_name_from_connec_entity_hash({'first_name' => 'A', 'last_name' => 'B'})).to eql('A B') }
  it { expect(subject.object_name_from_external_entity_hash({'name' => 'A'})).to eql('A') }
end

describe 'instance methods' do

  let(:organization) { create(:organization) }
  let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
  let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
  let(:opts) { {} }
  subject { Entities::AppUser.new(organization, connec_client, external_client, opts) }

  describe 'external to connec!' do
    let(:external_hash) {
        {
          "id"=> 123456,
          "name"=> "John Doe",
          "email"=> "johndoe@test.com",
          "created_at"=> "2016-07-19T10:19:36Z",
          "updated_at"=> "2016-07-27T08:51:20Z",
          "deleted_at"=> nil,
          "confirmed"=> true,
          "role"=> "admin",
          "status"=> "active"
        }
      }

    let (:mapped_external_hash) {
      {
        "id" => [{"id"=>123456, "provider"=>"this_app", "realm"=>"sfuiy765"}],
        "first_name" => "John",
        "last_name" => "Doe",
        "is_admin" => true,
        "email" => {
          "address" => "johndoe@test.com"
        }
      }.with_indifferent_access
    }

    it { expect(subject.map_to_connec(external_hash)).to eql(mapped_external_hash) }
  end

  describe 'connec to external' do
    let(:connec_hash) {
      {
      "id"=> "76991ec1-ff01-0133-bfdc-5fbf8265841f",
      "mno_user_id"=> "beadae47-0af6-4a3f-b7c8-b54401c717ba",
      "first_name"=> "User",
      "last_name"=> "Test",
      "role"=> "CEO",
      "is_admin"=> true,
      "email"=> {
        "address"=> "john17@maestrano.com",
        "address2"=> "jack17@example.com"
      },
      "address_work"=> {
        "billing"=> {
          "line1"=> "86 Elizabeth Street",
          "line2"=> "",
          "city"=> "Sydney",
          "region"=> "NSW",
          "postal_code"=> "2086",
          "country"=> "Australia"
        },
        "billing2"=> {
          "line1"=> "87 Elizabeth Street",
          "line2"=> "",
          "city"=> "Sydney",
          "region"=> "NSW",
          "postal_code"=> "2087",
          "country"=> "Australia"
        },
        "shipping"=> {
          "line1"=> "88 Elizabeth Street",
          "line2"=> "",
          "city"=> "Sydney",
          "region"=> "NSW",
          "postal_code"=> "2088",
          "country"=> "Australia"
        },
        "shipping2"=> {
          "line1"=> "89 Elizabeth Street",
          "line2"=> "",
          "city"=> "Sydney",
          "region"=> "NSW",
          "postal_code"=> "2089",
          "country"=> "Australia"
        }
      },
      "address_home"=> {
        "billing"=> {
          "line1"=> "90 Elizabeth Street",
          "line2"=> "",
          "city"=> "Sydney",
          "region"=> "NSW",
          "postal_code"=> "2090",
          "country"=> "Australia"
        },
        "billing2"=> {
          "line1"=> "91 Elizabeth Street",
          "line2"=> "",
          "city"=> "Sydney",
          "region"=> "NSW",
          "postal_code"=> "2091",
          "country"=> "Australia"
        },
        "shipping"=> {
          "line1"=> "92 Elizabeth Street",
          "line2"=> "",
          "city"=> "Sydney",
          "region"=> "NSW",
          "postal_code"=> "2092",
          "country"=> "Australia"
        },
        "shipping2"=> {
          "line1"=> "93 Elizabeth Street",
          "line2"=> "",
          "city"=> "Sydney",
          "region"=> "NSW",
          "postal_code"=> "2093",
          "country"=> "Australia"
        }
      },
      "phone_work"=> {
        "landline"=> "+61 2 8574 1222",
        "landline2"=> "+1 2 8574 1222",
        "mobile"=> "+61 449 785 122",
        "mobile2"=> "+1 449 785 122",
        "fax"=> "+61 2 9974 1222",
        "fax2"=> "+1 2 9974 1222",
        "pager"=> "+61 440 785 122",
        "pager2"=> "+1 440 785 122"
      },
      "phone_home"=> {
        "landline"=> "+61 2 8574 1223",
        "landline2"=> "+1 2 8574 1223",
        "mobile"=> "+61 449 785 123",
        "mobile2"=> "+1 449 785 123",
        "fax"=> "+61 2 9974 1223",
        "fax2"=> "+1 2 9974 1223",
        "pager"=> "+61 440 785 123",
        "pager2"=> "+1 440 785 123"
      },
      "teams"=> [
        {
          "id"=> "f811a2ca-ec61-4d2a-a987-9128a990f59b",
          "code"=> "TEA-1"
        }
      ]
    }
  }

    let(:mapped_connec_hash) {
      {
        "name" => "User Test",
        "email" => "john17@maestrano.com",
        "role" => "admin",
      }.with_indifferent_access
    }

    it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }
  end
 end
end
