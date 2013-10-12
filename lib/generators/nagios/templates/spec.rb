require File.dirname(__FILE__) + '/../spec_helper'
require 'nagios/spec_helper'

describe Nagios::<%= class_name %> do
  before :each do
    @check = Nagios::<%= class_name %>.new({:x => 'some'})
  end

  it 'should be ok' do
    status, message = @check.check({:x => 'some'})
    status.should == Nagios::OK
    message.should == 'good'
  end
end
