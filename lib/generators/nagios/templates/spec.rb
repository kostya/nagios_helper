require File.dirname(__FILE__) + '/../spec_helper'
require 'nagios_check/spec_helper'

describe Nagios::<%= class_name %> do
  it 'should be ok' do
    status, message = Nagios::<%= class_name %>.check({:x => 'some'})
    status.should == Nagios::OK
    message.should include('good')
  end
end
