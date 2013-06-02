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
end
