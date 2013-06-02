require 'spec_helper'

describe Bitsy::Mask do
  subject { Bitsy::Mask.new(:foo, 4) }

  its(:value) { should == 16 }
  its(:flag) { should == :foo }
end
