# encoding: UTF-8
require 'spec_helper'

describe ActiveData::Config do
  subject { ActiveData::Config.send :new }

  describe '#include_root_in_json' do
    its(:include_root_in_json) { should be_false }
    specify { expect { subject.include_root_in_json = true }
      .to change { subject.include_root_in_json }.from(false).to(true) }
  end

  describe '#i18n_scope' do
    its(:i18n_scope) { should == :active_data }
    specify { expect { subject.i18n_scope = :data_model }
      .to change { subject.i18n_scope }.from(:active_data).to(:data_model) }
  end

  describe '#normalizer' do
    its(:_normalizers) { should == {} }
    specify { expect { subject.normalizer(:name) { } }
      .to change { subject.normalizer(:name) rescue nil }.from(nil).to(an_instance_of(Proc)) }
    specify { expect { subject.normalizer(:wrong) }.to raise_error ActiveData::NormalizerMissing }
  end
end
