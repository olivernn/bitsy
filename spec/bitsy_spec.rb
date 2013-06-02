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

  describe "#set" do
    context "flag is unset" do
      subject { Prefs.new }
      before { subject.set(:create) }
      its(:has_create) { should be_true }
    end

    context "flag is set" do
      subject { Prefs.new([:create]) }
      before { subject.set(:create) }
      its(:has_create) { should be_true }
    end

    context "unrecognised flag" do
      let(:prefs) { Prefs.new }

      it "should raise InvalidFlagError" do
        expect {
          prefs.set(:invalid)
        }.to raise_error(Bitsy::InvalidFlagError)
      end
    end
  end

  describe "#unset" do
    context "flag is unset" do
      subject { Prefs.new }
      before { subject.unset(:create) }
      its(:has_create) { should_not be_true }
    end

    context "flag is set" do
      subject { Prefs.new([:create]) }
      before { subject.unset(:create) }
      its(:has_create) { should_not be_true }
    end

    context "unrecognised flag" do
      let(:prefs) { Prefs.new }

      it "should raise InvalidFlagError" do
        expect {
          prefs.unset(:invalid)
        }.to raise_error(Bitsy::InvalidFlagError)
      end
    end
  end

  describe "#toggle" do
    context "flag is unset" do
      subject { Prefs.new }
      before { subject.toggle(:create) }
      its(:has_create) { should be_true }
    end

    context "flag is set" do
      subject { Prefs.new([:create]) }
      before { subject.toggle(:create) }
      its(:has_create) { should_not be_true }
    end

    context "unrecognised flag" do
      let(:prefs) { Prefs.new }

      it "should raise InvalidFlagError" do
        expect {
          prefs.toggle(:invalid)
        }.to raise_error(Bitsy::InvalidFlagError)
      end
    end
  end

  describe "#&" do
    let(:prefs) { Prefs.new(1) }

    context "with an integer" do
      subject { prefs & 1 }
      its(:to_i) { should == 1 }
      it { should be_kind_of Prefs }
    end

    context "with a mask" do
      let(:mask) { Bitsy::Mask.new(:flag, 1) }
      subject { prefs & mask }
      its(:to_i) { should == 1 }
      it { should be_kind_of Prefs }
    end
  end

  describe "#|" do
    let(:prefs) { Prefs.new(1) }

    context "with an integer" do
      subject { prefs | 2 }
      its(:to_i) { should == 3 }
      it { should be_kind_of Prefs }
    end

    context "with a mask" do
      let(:mask) { Bitsy::Mask.new(:flag, 2) }
      subject { prefs | mask }
      its(:to_i) { should == 3 }
      it { should be_kind_of Prefs }
    end
  end

  describe "#^" do
    let(:prefs) { Prefs.new(2) }

    context "with an integer" do
      subject { prefs ^ 2 }
      its(:to_i) { should == 0 }
      it { should be_kind_of Prefs }
    end

    context "with a mask" do
      let(:mask) { Bitsy::Mask.new(:flag, 2) }
      subject { prefs ^ mask }
      its(:to_i) { should == 0 }
      it { should be_kind_of Prefs }
    end
  end
end
