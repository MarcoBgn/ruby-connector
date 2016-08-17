require 'spec_helper'

describe Entities::Opportunity do

describe 'class methods' do
  subject { Entities::Opportunity }

  it { expect(subject.connec_entity_name).to eql('Opportunity') }
  it { expect(subject.external_entity_name).to eql('Deal') }
  it { expect(subject.object_name_from_connec_entity_hash({'name' => 'A'})).to eql('A') }
  it { expect(subject.object_name_from_external_entity_hash({'name' => 'A'})).to eql('A') }
end

describe 'instance methods' do

  let(:organization) { create(:organization) }
  let(:connec_client) { Maestrano::Connector::Rails::ConnecHelper.get_client(organization) }
  let(:external_client) { Maestrano::Connector::Rails::External.get_client(organization) }
  let(:opts) { {} }
  subject { Entities::Opportunity.new(organization, connec_client, external_client, opts) }

    before do
      stages = [{
                   "id"=> 5550555,
                   "name"=> "Incoming",
                   "category"=> "incoming",
                   "position"=> 1,
                   "likelihood"=> 0,
                   "active"=> true,
                   "pipeline_id"=> 634362,
                   "created_at"=> "2016-07-19T10:19:37Z",
                   "updated_at"=> "2016-07-19T10:19:41Z"
                 },
                 {
                    "id"=> 6660666,
                    "name"=> "Incoming",
                    "category"=> "incoming",
                    "position"=> 1,
                    "likelihood"=> 50,
                    "active"=> true,
                    "pipeline_id"=> 634362,
                    "created_at"=> "2016-07-19T10:19:37Z",
                    "updated_at"=> "2016-07-19T10:19:41Z"
                  },
                  {
                     "id"=> 7770777,
                     "name"=> "Incoming",
                     "category"=> "incoming",
                     "position"=> 1,
                     "likelihood"=> 30,
                     "active"=> true,
                     "pipeline_id"=> 634362,
                     "created_at"=> "2016-07-19T10:19:37Z",
                     "updated_at"=> "2016-07-19T10:19:41Z"
                   }]
      allow(external_client).to receive(:get_entities) { stages }
      subject.before_sync
    end

  describe 'external to connec!' do

    let(:external_hash) {
      {
        "dropbox_email"=> "dropbox@72ca79e5.deals.futuresimple.com",
        "value"=> 500,
        "contact_id"=> 135906741,
        "stage_id"=> 5550555,
        "loss_reason_id"=> nil,
        "currency"=> "GBP",
        "estimated_close_date"=> nil,
        "updated_at"=> "2016-07-27T08=>48=>07Z",
        "tags"=> [],
        "owner_id"=> 960788,
        "creator_id"=> 960788,
        "last_stage_change_by_id"=> 960788,
        "custom_fields"=> {},
        "organization_id"=> 135906739,
        "source_id"=> nil,
        "name"=> "Hot Deal",
        "id"=> 2,
        "last_activity_at"=> "2016-07-27T08:48:07Z",
        "last_stage_change_at"=> "2016-07-27T08:48:07Z",
        "hot"=> false,
        "created_at"=> "2016-07-19T10:20:07Z"
      }
    }

    let (:mapped_external_hash) {
      {
        "id" => [{'id' => 2, 'provider' => organization.oauth_provider, 'realm' => organization.oauth_uid}],
        "name" => "Hot Deal",
        "amount" => {
          "total_amount" => 500.0
        },
        "sales_stage" => "Incoming",
        "lead_id" => [{"id"=>135906741, "provider"=>"this_app", "realm"=>"sfuiy765"}],
        "probability" => 0,
        "sales_stage_changes" => [
          {
            "created_at" => "2016-07-27T08:48:07Z"
          }
        ],
      }.with_indifferent_access
    }

    it { expect(subject.map_to_connec(external_hash)).to eql(mapped_external_hash) }
  end

  describe 'connec to external' do
    let(:connec_hash) {
      {
      "id" => "f4e131e0-cd6a-0133-b422-027f396e04cb",
      "code" => "POT1",
      "name" => "Hot Deal",
      "description" => "A very good opportunity",
      "sales_stage" => "Open",
      "type" => "New Business",
      "expected_close_date" => "2016-03-28T07:12:51Z",
      "amount" => {
        "total_amount" => 99.99
      },
      "probability" => 40,
      "next_step" => "Qualification",
      "sales_stage_changes" => [
        {
          "status" => "Open",
          "created_at" => "2016-03-16T06:05:07Z"
        }
      ],
      "created_at" => "2016-03-16T06:05:07Z",
      "updated_at" => "2016-03-16T07:12:52Z",
      "channel_id" => "org-fbba",
      "lead_id" => "8be5a2b1-49fd-4844-b740-87965bbbd0bc",
      "assignee_id" => "b5dbd78a-26da-4e55-ad84-625b25d67622",
      "assignee_type" => "AppUser",
      "resource_type" => "opportunities"
    }
   }

    let(:mapped_connec_hash) {
      {
        "name" => "Hot Deal",
        "value" => "99.99",
        "contact_id" => "8be5a2b1-49fd-4844-b740-87965bbbd0bc",
        "stage_id" => 6660666,
        "estimated_close_date"=> "2016-03-28T07:12:51Z",
        "last_stage_change_at" => "2016-03-16T06:05:07Z"
      }.with_indifferent_access
    }

    it { expect(subject.map_to_external(connec_hash)).to eql(mapped_connec_hash) }
  end
 end
end
