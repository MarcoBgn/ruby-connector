require 'spec_helper'

describe Entities::Item do

  describe 'class methods' do
    subject { Entities::Item }

    it { expect(subject.connec_entity_name).to eql('Item') }
    it { expect(subject.external_entity_name).to eql('Product') }
    it { expect(subject.object_name_from_connec_entity_hash({'name' => 'A'})).to eql('A') }
    it { expect(subject.object_name_from_external_entity_hash({'name' => 'A'})).to eql('A') }
  end

  describe 'instance methods' do

    let(:organization) { create(:organization) }
    let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
    let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
    let(:opts) { {} }
    subject { Entities::Item.new(organization, connec_client, external_client, opts) }

    describe 'external to connec!' do
      let(:external_hash) {
        {
          "id"=> 483570,
          "updated_at"=> "2016-08-01T13:00:51Z",
          "created_at"=> "2016-07-31T20:06:42Z",
          "active"=> true,
          "description"=> "Testing UPDATE message",
          "name"=> "BASE YYY Product",
          "sku"=> "IT14",
          "prices"=> [
            {
              "currency"=> "GBP",
              "amount"=> "79.00"
            }
          ],
          "max_discount"=> nil,
          "max_markup"=> nil,
          "cost"=> "10.00",
          "cost_currency"=> "GBP"
        }
      }

      let (:mapped_external_hash) {
        {
          :id => [{'id' => 483570, 'provider' => organization.oauth_provider, 'realm' => organization.oauth_uid}],
          :name => "BASE YYY Product",
          :reference => "IT14",
          :description => "Testing UPDATE message",
          :sale_price => {
            :total_amount => 79.0,
            :currency => "GBP"
          },
          :purchase_price => {
            :total_amount => 10.0,
            :currency => "GBP"
          }
        }.with_indifferent_access
      }

      it { expect(subject.map_to_connec(external_hash)).to eql(mapped_external_hash) }
    end

    describe 'connec to external' do
      let(:connec_hash) {
        {
          "id"=> "b081c691-3986-0134-12bc-0fd32de3632a",
          "code"=> "IT6",
          "reference"=> "IT6",
          "name"=> "BaseCRM Product",
          "description"=> connec_description,
          "status"=> "ACTIVE",
          "is_inventoried"=> false,
          "sale_price"=> {
            "total_amount"=> 20,
            "net_amount"=> 20,
            "tax_amount"=> 0,
            "tax_rate"=> 0,
            "currency"=> "GBP"
          },
          "purchase_price"=> {
            "total_amount"=> 10,
            "net_amount"=> 0,
            "tax_amount"=> 0,
            "tax_rate"=> 0,
            "currency"=> "GBP"
          },
          "sale_tax_code_id"=> "a3daf1f1-3986-0134-10ad-0fd32de3632a",
          "purchase_tax_code_id"=> "a3daf1f1-3986-0134-10ad-0fd32de3632a",
          "sale_account_id"=> "a598f5a1-3986-0134-10f0-0fd32de3632a",
          "purchase_account_id"=> "a5f127c0-3986-0134-110d-0fd32de3632a",
          "created_at"=> "2016-07-31T19:55:43Z",
          "updated_at"=> "2016-08-01T13:09:27Z",
          "group_id"=> "cld-9a5p",
          "channel_id"=> "org-f6is",
          "resource_type"=> "items"
        }
      }

      let(:mapped_connec_hash) {
        {
          :name => "BaseCRM Product",
          :sku => "IT6",
          :description => base_description,
          :prices => [
            {
              :amount => "20",
              :currency => "GBP"
            }
          ],
          :cost => "10",
          :cost_currency => "GBP"
        }.with_indifferent_access
      }

      let(:connec_description) { 'Test item' }
      let(:base_description) { connec_description }

      it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }

      context "Description field is an empty string in connec!" do
        let(:connec_description) { '' }
        let(:base_description) { 'This item has no description' }

        it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }
      end
    end
  end
end
