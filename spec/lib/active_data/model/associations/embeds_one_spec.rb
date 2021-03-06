# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Associations::Reflections::EmbedsOne do

  class OneAssoc
    include ActiveData::Model

    attribute :name
  end

  let(:klass) do
    Class.new do
      include ActiveData::Model

      attribute :name
      embeds_one :one_assoc
    end
  end

  subject { klass.new(name: 'world') }

  its(:one_assoc) { should be_nil }
  specify { klass.new(name: 'world', one_assoc: OneAssoc.new(name: 'foo')).to_json(include: :one_assoc).should == {name: 'world', one_assoc: {name: 'foo'}}.to_json }

  context 'accessor with objects' do
    before { subject.one_assoc = OneAssoc.new(name: 'foo') }
    specify { subject.one_assoc.should be_instance_of OneAssoc }
    specify { subject.one_assoc.name.should == 'foo' }
  end

  context 'accessor with nothing' do
    before { subject.one_assoc = nil }
    specify { subject.one_assoc.should be_nil }
  end

  describe '#==' do
    let(:instance) { klass.new(name: 'world') }
    before { subject.one_assoc = OneAssoc.new(name: 'foo') }
    specify { subject.should_not == instance }

    context do
      before { instance.one_assoc = OneAssoc.new(name: 'foo1') }
      specify { subject.should_not == instance }
    end

    context do
      before { instance.one_assoc = OneAssoc.new(name: 'foo') }
      specify { subject.should == instance }
    end
  end
end
