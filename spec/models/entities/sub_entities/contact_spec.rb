require "spec_helper"

describe Entities::SubEntities::Contact do

  let(:entity_organization)  { { 'id' => 123456, 'name' => 'test_org', "is_organization" => true}}
  let(:entity_person)  { { 'id' => 123456, 'first_name' => 'John', "last_name" => "Smith"}}

  context "Class Methods" do

    subject { Entities::SubEntities::Contact}

    it { expect(subject.id_from_external_entity_hash(entity_person)).to eq 123456 }
    it { expect(subject.object_name_from_external_entity_hash(entity_person)).to eq "John Smith"}
    it { expect(subject.object_name_from_external_entity_hash(entity_organization)).to eq "test_org"}
  end

  context "Instance Methods" do

    subject { Entities::SubEntities::Contact.new(organization, nil, nil)}
    let!(:organization) { create(:organization)}

    describe '#map_to connec! Person' do

      let(:external_hash) {
        {
          "id"=> 134706023,
          "contact_id"=> nil,
          "first_name"=> "John",
          "last_name"=> "Smith",
          "title"=> "CTO",
          "is_organization"=> false,
          "email"=> 'test@email.com',
          "skype"=> "johnsmith",
          "phone"=> "0208111",
          "mobile"=> "0777111",
          "fax"=> "0208000",
          "address" => {
            "city" => "London",
            "postal_code" => "W6 7TN",
            "country" => "United Kingdom"
          }
        }
      }

      let (:mapped_external_hash) {
        {
          :id => [{"id"=>134706023, "provider"=>"this_app", "realm"=>"sfuiy765"}],
          :first_name => "John",
          :last_name => "Smith",
          :job_title => "CTO",
          :email => {
            :address => "test@email.com"
          },
          :contact_channel => {
            :skype => "johnsmith"
          },
          :phone_work => {
            :landline => "0208111",
            :mobile => "0777111",
            :fax => "0208000"
          },
          :address_work => {
            :billing => {
              :city => 'London',
              :postal_code => 'W6 7TN',
              :country => 'United Kingdom'
            }
          },
          :assignee_type => "AppUser"
        }.with_indifferent_access
      }

      it { expect(subject.map_to('Person', external_hash)).to eql(mapped_external_hash) }
    end

    describe '#map_to connec! Organization' do

      let(:external_hash) {
        {
          "id"=> 134706023,
          "contact_id"=> nil,
          "name"=> "A Company",
          "industry"=> "ITC",
          "email"=> "test@test.com",
          "website"=> "http://test.com",
          "skype"=> "itccompany",
          "is_organization"=> true,
          "phone"=> "0208111",
          "fax"=> "0208000",
          "address" => {
            "city" => "London",
            "postal_code" => "W6 7TN",
            "country" => "United Kingdom"
          }
        }
      }

      let (:mapped_external_hash) {
        {
          :id => [{"id"=>134706023, "provider"=>"this_app", "realm"=>"sfuiy765"}],
          :name => "A Company",
          :industry => "ITC",
          :email => {
            :address => "test@test.com"
          },
          :website => {
            :url => "http://test.com"
          },
          :contact_channel => {
            :skype => "itccompany"
          },
          :phone_work => {
            :landline => "0208111",
            :fax => "0208000"
          },
          :address_work => {
            :billing => {
              :city => 'London',
              :postal_code => 'W6 7TN',
              :country => 'United Kingdom'
            }
          }
        }.with_indifferent_access
      }

      it { expect(subject.map_to('Organization', external_hash)).to eql(mapped_external_hash) }
    end
  end
end
