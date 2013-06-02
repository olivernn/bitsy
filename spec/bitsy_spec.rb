require 'spec_helper'

class Prefs < Bitsy
  flags :create, :update, :blocked, :donedone, :complete, :destroy
end

describe Bitsy do

  describe "#initialize" do
    context "no value" do
      subject { Prefs.new }
      its(:to_i) { should == 0 }
      its(:to_a) { should be_empty }
    end

    context "integer value" do
      subject { Prefs.new(2) }
      its(:to_i) { should == 2 }
      its(:to_a) { should == [:update] }
    end

    context "array value" do
      context "empty array" do
        subject { Prefs.new([]) }
        its(:to_i) { should == 0 }
        its(:to_a) { should be_empty }
      end

      context "non empty array" do
        context "valid flags" do
          let(:flags) { [:create, :update] }
          subject { Prefs.new(flags) }
          its(:to_i) { should == 3 }
          its(:to_a) { should == flags }
        end

        context "invalid flags" do
          let(:flags) { [:invalid] }

          it "should raise a InvalidFlagError" do
            expect {
              Prefs.new(flags)
            }.to raise_error(Bitsy::InvalidFlagError)
          end
        end
      end
    end
  end

  describe ".masks" do
    subject { Prefs.masks }
    its(:size) { should == 6 }
    its(:first) { should be_a Bitsy::Mask }
  end

  describe "#has_*" do
    subject { Prefs.new([:create, :update]) }

    context "single flag" do
      its(:has_create) { should be_true }
      its(:has_donedone) { should be_false }
    end

    context "multiple and flag" do
      its(:has_create_and_donedone) { should be_false }
      its(:has_create_and_update) { should be_true }
    end

    context "multiple or flag" do
      its(:has_create_or_donedone) { should be_true }
      its(:has_create_or_update) { should be_true }
      its(:has_blocked_or_donedone) { should be_false }
    end
  end

end
