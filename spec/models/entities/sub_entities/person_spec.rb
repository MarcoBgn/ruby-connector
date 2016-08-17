require 'spec_helper'

describe Entities::SubEntities::Person do

  context "Class Methods" do
    subject { Entities::SubEntities::Person }

    it { expect(subject.entity_name).to eql('Person') }
    it { expect(subject.external?).to eql(false) }
    it { expect(subject.mapper_classes).to eql({"Contact" => Entities::SubEntities::PersonMapper ,"Lead" => Entities::SubEntities::PersonMapper}) }
    it { expect(subject.object_name_from_connec_entity_hash({'first_name' => 'A', 'last_name' => 'contact'})).to eql('A contact') }
  end

  context "Instance Methods" do

    let(:organization) { create(:organization)}
    subject { Entities::SubEntities::Person.new(organization, nil, nil)}

    describe '#map_to external Contact' do
      let(:connec_hash) {
        {
          "first_name" => "John",
          "job_title" => "CTO",
          "contact_channel" => {
            "skype" => "johnsmith"
          },
          "phone_work" => {
            "landline" => "0208111111",
            "mobile" => "0777111222",
            "fax" => "0208000000"
          },
          "address_work" => {
            "billing" => {
              "line1" => '31 test',
              "city" => 'London',
              "postal_code" => "W6 7TN",
              "country" => "United Kingdom"
            }
          }
        }
      }

      let(:mapped_connec_hash) {
        { :title => 'CTO',
          :first_name => 'John',
          :last_name => 'Not Available',
          :skype => 'johnsmith',
          :phone => '0208111111',
          :mobile => '0777111222',
          :fax => '0208000000',
          :address => {
            :line1 => '31 test',
            :city => 'London',
            :postal_code => 'W6 7TN',
            :country => 'United Kingdom'
          }
        }.with_indifferent_access
      }

      it { expect(subject.map_to('Contact', connec_hash)).to eql(mapped_connec_hash) }

      describe '#map_to external Lead' do
        let(:connec_hash) {
          {
            "id"=> "1f34e8d1-36f6-0134-56fb-277debe03f59",
            "code"=> "LEA1",
            "status"=> "ACTIVE",
            "description"=> "Test Lead",
            "title"=> "Ms.",
            "first_name"=> "Serena",
            "last_name"=> "Smith",
            "is_customer"=> false,
            "is_supplier"=> false,
            "is_lead"=> true,
            "contact_channel"=> {},
            "address_work"=> {
              "billing"=> {},
              "billing2"=> {},
              "shipping"=> {
                "line1"=> "21 Lead street",
                "line2"=> "",
                "city"=> "London",
                "region"=> "",
                "postal_code"=> "W2 L34",
                "country"=> "United Kingdom"
              },
              "shipping2"=> {}
            },
            "address_home"=> {
              "billing"=> {},
              "billing2"=> {},
              "shipping"=> {},
              "shipping2"=> {}
            },
            "email"=> {
              "address"=> "ss@test.com",
              "address2"=> ""
            },
            "website"=> {},
            "phone_work"=> {
              "landline"=> "0208666555",
              "mobile"=> "0777333222",
              "fax"=> "0208111000"
            },
            "phone_home"=> {},
            "lead_status"=> "Contact in Future",
            "lead_source"=> "",
            "lead_status_changes"=> [
              {
                "status"=> "Contact in Future",
                "created_at"=> "2016-07-28T13:35:50Z"
              }
            ],
            "referred_leads"=> [],
            "opportunities"=> [],
            "notes"=> [],
            "tasks"=> [],
            "created_at"=> "2016-07-28T13:35:50Z",
            "updated_at"=> "2016-07-28T13:35:50Z",
            "group_id"=> "cld-9asu",
            "channel_id"=> "org-f6zi",
            "resource_type"=> "people"
          }.with_indifferent_access
        }

        let(:mapped_connec_hash) {
          {
            :"email" => "ss@test.com",
            :fax => "0208111000",
            :first_name => "Serena",
            :last_name => "Smith",
            :mobile => "0777333222",
            :phone => "0208666555"
            #At the moment addresses coming from the shipping field
            #will not be mapped.
          }.with_indifferent_access
        }

        it { expect(subject.map_to('Lead', connec_hash)).to eql(mapped_connec_hash) }
      end
    end
  end
end
