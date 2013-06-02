require 'spec_helper'

describe Bitsy::Mask do

  describe ".with_index" do
    subject { Bitsy::Mask.with_index(:foo, 4) }

    its(:value) { should == 16 }
    its(:flag) { should == :foo }
    its(:to_i) { should == 16 }
  end

  describe "#&" do
    let(:mask) { Bitsy::Mask.new(:foo, 1) }

    context "with an integer" do
      subject { mask & 1 }
      its(:to_i) { should == 1 }
      its(:flag) { should == :foo_AND_1 }
      it { should be_kind_of Bitsy::Mask }
    end

    context "with a mask" do
      let(:other_mask) { Bitsy::Mask.new(:flag, 1) }
      subject { mask & other_mask }
      its(:to_i) { should == 1 }
      its(:flag) { should == :foo_AND_flag }
      it { should be_kind_of Bitsy::Mask }
    end
  end

  describe "#|" do
    let(:mask) { Bitsy::Mask.new(:foo, 1) }

    context "with an integer" do
      subject { mask | 2 }
      its(:to_i) { should == 3 }
      its(:flag) { should == :foo_OR_2 }
      it { should be_kind_of Bitsy::Mask }
    end

    context "with a mask" do
      let(:other_mask) { Bitsy::Mask.new(:flag, 2) }
      subject { mask | other_mask }
      its(:to_i) { should == 3 }
      its(:flag) { should == :foo_OR_flag }
      it { should be_kind_of Bitsy::Mask }
    end
  end

  describe "#^" do
    let(:mask) { Bitsy::Mask.new(:foo, 2) }

    context "with an integer" do
      subject { mask ^ 2 }
      its(:to_i) { should == 0 }
      its(:flag) { should == :foo_XOR_2 }
      it { should be_kind_of Bitsy::Mask }
    end

    context "with a mask" do
      let(:other_mask) { Bitsy::Mask.new(:flag, 2) }
      subject { mask ^ other_mask }
      its(:to_i) { should == 0 }
      its(:flag) { should == :foo_XOR_flag }
      it { should be_kind_of Bitsy::Mask }
    end
  end

  describe "#~" do
    let(:mask) { Bitsy::Mask.new(:foo, 1) }
    subject { ~mask }
    its(:to_i) { should == -2 }
    its(:flag) { should == :NOT_foo }
  end
end
