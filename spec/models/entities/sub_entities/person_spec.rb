require 'spec_helper'

describe Entities::SubEntities::Person do

    subject { Entities::SubEntities::Person }

    it { expect(subject.entity_name).to eql('Person') }
    it { expect(subject.external?).to eql(false) }
    it { expect(subject.mapper_classes).to eql({"Contact" => Entities::SubEntities::PersonMapper}) }
    it { expect(subject.object_name_from_connec_entity_hash({'first_name' => 'A', 'last_name' => 'contact'})).to eql('A contact') }

end
