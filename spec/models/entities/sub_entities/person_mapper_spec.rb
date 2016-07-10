require "spec_helper"

describe Entities::SubEntities::PersonMapper do

  subject{ Entities::SubEntities::PersonMapper}

  describe 'normalize' do
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

    it { expect(subject.normalize(connec_hash)).to eql(mapped_connec_hash) }
  end

  describe 'denormalize' do

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

    it { expect(subject.denormalize(external_hash)).to eql(mapped_external_hash) }
  end
end
