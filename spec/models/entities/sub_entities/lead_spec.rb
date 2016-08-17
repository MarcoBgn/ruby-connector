require "spec_helper"

describe Entities::SubEntities::Lead do

  let(:entity_organization)  { { 'id' => 123456, 'organization_name' => 'test_org'}}
  let(:entity_person)  { { 'id' => 123456, 'first_name' => 'John', "last_name" => "Smith"}}

  context "Class Methods" do

    subject { Entities::SubEntities::Lead}

    it { expect(subject.id_from_external_entity_hash(entity_person)).to eq 123456 }
    it { expect(subject.object_name_from_external_entity_hash(entity_person)).to eq "John Smith"}
    it { expect(subject.object_name_from_external_entity_hash(entity_organization)).to eq "test_org"}
  end

  context "Instance Methods" do

    subject { Entities::SubEntities::Lead.new(organization, nil, nil)}
    let!(:organization) { create(:organization)}

    describe '#map_to connec! Person' do

      let(:external_hash) {
          {
            "id"=> 1903091207,
            "owner_id"=> 960788,
            "first_name"=> "John",
            "last_name"=> "Lead",
            "source_id"=> 342382,
            "created_at"=> "2016-07-28T13:28:43Z",
            "updated_at"=> "2016-07-28T13:28:43Z",
            "twitter"=> nil,
            "phone" => "0208111222",
            "mobile" => "077745456",
            "facebook"=> nil,
            "email"=> "j@email.com",
            "title"=> "CTO",
            "skype"=> "johnlead",
            "linkedin"=> nil,
            "description"=> nil,
            "industry"=> nil,
            "fax" => "0208111333",
            "website"=> nil,
            "address"=> {
              "line1"=> "21 Lead street",
              "city"=> "London",
              "postal_code"=> "W3 L45",
              "state"=> nil,
              "country"=> "United Kingdom"
            },
            "status"=> "New",
            "creator_id"=> 960788,
            "organization_name"=> "Test Company",
            "tags"=> [
              "test"
            ],
            "custom_fields"=> {}
        }
      }

      let(:mapped_external_hash) {
        {
          :id => [{"id"=>1903091207, "provider"=>"this_app", "realm"=>"sfuiy765"}],
          :assignee_id => [{"id"=>960788, "provider"=>"this_app", "realm"=>"sfuiy765"}],
          :first_name => "John",
          :last_name => "Lead",
          :job_title => "CTO",
          :email => {
            :address => "j@email.com"
          },
          :contact_channel => {
            :skype => "johnlead"
          },
          :phone_work => {
            :landline => "0208111222",
            :mobile => "077745456",
            :fax => "0208111333"
          },
          :address_work => {
            :billing => {
              :line1 => "21 Lead street",
              :city => 'London',
              :postal_code => "W3 L45",
              :country => "United Kingdom"
            }
          },
          :is_lead => true,
          :is_customer => false,
          :assignee_type => "AppUser"
        }.with_indifferent_access
      }

      it { expect(subject.map_to('Person', external_hash)).to eql(mapped_external_hash) }
    end

    describe '#map_to connec! Organization' do

      let(:external_hash) {
        {
          "id"=> 1903091859,
          "owner_id"=> 960788,
          "first_name"=> nil,
          "last_name"=> nil,
          "source_id"=> nil,
          "created_at"=> "2016-07-28T13:44:19Z",
          "updated_at"=> "2016-07-28T13:44:19Z",
          "twitter"=> nil,
          "phone"=> "0208111222",
          "mobile"=> "0745111222",
          "facebook"=> nil,
          "email"=> "complead@test.com",
          "title"=> nil,
          "skype"=> "itccompany",
          "linkedin"=> nil,
          "description"=> nil,
          "industry"=> "ITC",
          "fax"=> "0208111333",
          "website"=> "http://test.com",
          "address"=> {
            "line1"=> "99 Lead Company",
            "city"=> "Edinburgh",
            "postal_code"=> "W4 7HE",
            "state"=> nil,
            "country"=> "United Kingdom"
          },
          "status"=> "New",
          "creator_id"=> 960788,
          "organization_name"=> "Company Lead",
          "tags"=> [
            "test"
          ],
          "custom_fields"=> {}
        }
      }

      let(:mapped_external_hash) {
        {
          :id => [{"id"=>1903091859, "provider"=>"this_app", "realm"=>"sfuiy765"}],
          :assignee_id => [{"id"=>960788, "provider"=>"this_app", "realm"=>"sfuiy765"}],
          :name => "Company Lead",
          :industry => "ITC",
          :email => {
            :address => "complead@test.com"
          },
          :website => {
            :url => "http://test.com"
          },
          :contact_channel => {
            :skype => "itccompany"
          },
          :phone_work => {
            :landline => "0208111222",
            :mobile => "0745111222",
            :fax => "0208111333"
          },
          :address_work => {
            :billing => {
              :line1 => "99 Lead Company",
              :city => "Edinburgh",
              :postal_code => "W4 7HE",
              :country => "United Kingdom"
            }
          },
          :is_lead => true,
          :is_customer => false
        }.with_indifferent_access
      }

      it { expect(subject.map_to('Organization', external_hash)).to eql(mapped_external_hash) }
    end
  end
end
