require 'spec_helper'

describe Maestrano::Connector::Rails::External do

  let(:organization) { create(:organization) }

  describe 'class methods' do

    subject { Maestrano::Connector::Rails::External }

    describe 'self.entities_list' do
      it { expect(subject.entities_list).to be_a(Array) }
    end

    describe 'creates a BaseCRM client' do
      it { expect(subject.external_name).to eql('BaseCRM') }
    end

    describe 'self.fetch_company' do
      before do
        #This is used to stub a Service used by BaseCRM::Client to query their API
        allow_any_instance_of(BaseAPIManager).to receive(:get_account) { "account information from API"}
      end

      it "Retrieves the information about the current organization" do
        expect(subject.fetch_company(organization)).to eq "account information from API"
      end
    end

    describe 'self.get_client' do
      it 'creates a restforce client' do
        expect(BaseAPIManager).to receive(:new)
        subject.get_client(organization)
      end
    end
  end
end
