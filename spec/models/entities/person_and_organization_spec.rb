require 'spec_helper'

describe Entities::PersonAndOrganization do
  describe 'class methods' do
    subject { Entities::PersonAndOrganization }

    it { expect(subject.connec_entities_names).to eql(%w(Person Organization)) }
    it { expect(subject.external_entities_names).to eql(%w(Contact)) }
  end
  describe 'instance methods' do
    subject { Entities::PersonAndOrganization.new(nil, nil, nil, {}) }


    describe 'connec_model_to_external_model' do
      let(:person) { {'first_name' => 'Arold'} }
      let(:organization) { {'name' => 'TestOptima'} }

      let(:connec_hash) {
        {
          'Person' => [person],
          'Organization' => [organization]
        }
      }

      let(:output_hash) {
        {
          "Person" => { "Contact" => [person]},
          "Organization" => { "Contact" => [organization]} 
        }
      }

      it {
        expect(subject.connec_model_to_external_model(connec_hash)).to eql(output_hash)
      }

    end

    describe 'external_model_to_connec_model' do
      let(:contact1) { { "data" => {'first_name' => 'Gary', 'is_organization' => false}} }
      let(:contact2) { {"data" => {'name' => 'TestOptima', 'is_organization' => true}} }

      let(:external_hash) {
        {
          'Contact' => [contact1, contact2]
        }
      }
      let(:output_hash) {
        { "Contact" =>
          {
            'Person' => [contact1],
            'Organization' => [contact2]
          }
        }
      }

      it {
        expect(subject.external_model_to_connec_model(external_hash)).to eql(output_hash)
      }
    end
  end
end
