require "spec_helper"

describe Entities::SubEntities::OrganizationMapper do

  subject{ Entities::SubEntities::OrganizationMapper}

  let(:organization) { create(:organization)}

  describe 'normalize' do
    let(:connec_hash) {
      {
        "name" => "Test Company",
        "industry" => "ITC",
        "email" => {
          "address" => "test@test.com"
        },
        "website" => {
          "url" => "http://test.com"
        },
        "address_work" => {
          "billing" => {
            "city" => 'London',
            "line1" => '37 Kinderton Gardens',
            "country" => "United Kingdom"
          }
        }
      }
    }

    let(:mapped_connec_hash) {
      { :data => {
        :name => 'Test Company',
        :industry => 'ITC',
        :email => "test@test.com",
        :website => "http://test.com",
        :address => {
          :city => 'London',
          :line1 => '37 Kinderton Gardens',
          :country => 'United Kingdom'
          }
        }
      }
    }

    it { expect(subject.normalize(connec_hash)).to eql(mapped_connec_hash) }
  end

  describe 'denormalize' do

    let(:external_hash) {
      {
      "data"=> {
        "id"=> 134706023,
        "contact_id"=> nil,
        "name"=> "A Company",
        "industry"=> "ITC",
        "email"=> "test@test.com",
        "website"=> "http://test.com",
        "address" => {
            "city" => "London",
            "postal_code" => "W6 7TN",
            "country" => "United Kingdom"
        }
      }
    }
  }

    let (:mapped_external_hash) {
      {
        :name => "A Company",
        :industry => "ITC",
        :email => {
          :address => "test@test.com"
          },
        :website => {
          :url => "http://test.com"
        },
        :address_work => {
          :billing => {
            :city => 'London',
            :postal_code => 'W6 7TN',
            :country => 'United Kingdom'
          }
        }
      }
    }

    it { expect(subject.denormalize(external_hash)).to eql(mapped_external_hash) }
  end
end
