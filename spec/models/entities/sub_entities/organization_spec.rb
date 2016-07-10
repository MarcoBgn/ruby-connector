require 'spec_helper'

describe Entities::SubEntities::Organization do

    subject { Entities::SubEntities::Organization }

    it { expect(subject.entity_name).to eql('Organization') }
    it { expect(subject.external?).to eql(false) }
    it { expect(subject.mapper_classes).to eql({"Contact" => Entities::SubEntities::OrganizationMapper}) }
    it { expect(subject.object_name_from_connec_entity_hash({'name' => 'A Company', 'industry' => 'ITC'})).to eql('A Company') }

end
