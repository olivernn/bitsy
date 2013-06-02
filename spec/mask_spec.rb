require 'spec_helper'

describe Bitsy::Mask do

  describe ".with_index" do
    subject { Bitsy::Mask.with_index(:foo, 4) }

    its(:value) { should == 16 }
    its(:flag) { should == :foo }
    its(:to_i) { should == 16 }
  end

end
