require 'spec_helper'

describe Entities::PersonAndOrganization do
  describe 'class methods' do
    subject { Entities::PersonAndOrganization }

    it { expect(subject.connec_entities_names).to eql(%w(Person Organization)) }
    it { expect(subject.external_entities_names).to eql(%w(Contact Lead)) }
  end
  describe 'instance methods' do
    subject { Entities::PersonAndOrganization.new(nil, nil, nil, {}) }


    describe 'connec_model_to_external_model' do
      let(:person) { {'first_name' => 'Arold', 'is_lead' => false} }
      let(:organization) { {'name' => 'TestOptima', 'is_lead' => false} }
      let(:lead_person) { {'first_name' => 'John', 'is_lead' => true} }
      let(:lead_organization) { {'name' => 'TestLeadOrg', 'is_lead' => true} }

      let(:connec_hash) {
        {
          'Person' => [person, lead_person],
          'Organization' => [organization, lead_organization]
        }
      }

      let(:output_hash) {
        {
          "Person" => { "Contact" => [person],
                        "Lead" => [lead_person]
                       },
          "Organization" => { "Contact" => [organization],
                              "Lead" => [lead_organization]
                            }
        }
      }

      it {
        expect(subject.connec_model_to_external_model(connec_hash)).to eql(output_hash)
      }

    end

    describe 'external_model_to_connec_model' do
      let(:contact1) { {'first_name' => 'Gary', 'is_organization' => false} }
      let(:contact2) { {'name' => 'TestOptima', 'is_organization' => true} }
      let(:lead1) { {'first_name' => 'John', 'last_name' => "Smith"} }
      let(:lead2) { {'organization_name' => 'TestOptima', 'is_organization' => true} }

      let(:external_hash) {
        {
          'Contact' => [contact1, contact2],
          'Lead' => [lead1, lead2]
        }
      }
      let(:output_hash) {
        { "Contact" =>
          {
            'Person' => [contact1],
            'Organization' => [contact2]
          },
          "Lead" =>
          {
            'Person' => [lead1],
            'Organization' => [lead2]
          }
        }
      }

      it {
        expect(subject.external_model_to_connec_model(external_hash)).to eql(output_hash)
      }
    end
  end
end
