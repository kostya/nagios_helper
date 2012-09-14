require 'spec_helper'

describe "Nagios::Runner" do
  it "run ok" do
    @status, @message = Nagios::Runner.check({'method' => "bla"})
    @status.should == Nagios::OK
    @message.should include('a5')
  end
  
  it "run ok method with indefferent access" do
    @status, @message = Nagios::Runner.check({:method => "bla"})
    @status.should == Nagios::OK
    @message.should include('a5')
  end                  
  
  it "undefined klass" do
    @status, @message = Nagios::Runner.check({'method' => "blah"})
    @status.should == Nagios::OTHER
    @message.should include('Nagios::Blah')
  end
  
  it "empty class" do
    @status, @message = Nagios::Runner.check({})
    @status.should == Nagios::OTHER
    @message.should include('method should')
  end
  
  describe "check" do
    it "crit" do
      @status, @message = Nagios::Runner.check({'method' => "bla", 's' => 'crit'})
      @status.should == Nagios::CRIT
      @message.should include('a1')
    end
    
    it "warn" do
      @status, @message = Nagios::Runner.check({'method' => "bla", 's' => 'warn'})
      @status.should == Nagios::WARN
      @message.should include('a2')
    end
    
    it "raise" do
      @status, @message = Nagios::Runner.check({'method' => "bla", 's' => 'raise'})
      @status.should == Nagios::OTHER
      @message.should include('a3')
    end                            
    
    it "other" do
      @status, @message = Nagios::Runner.check({'method' => "bla", 's' => 'other'})
      @status.should == Nagios::OTHER
      @message.should include('a4')
    end
    
    it "ok" do
      @status, @message = Nagios::Runner.check({'method' => "bla", 's' => 'ok'})
      @status.should == Nagios::OK
      @message.should include('a5')
    end
    
    it "crit_warn" do
      @status, @message = Nagios::Runner.check({'method' => "bla", 's' => 'crit_warn'})
      @status.should == Nagios::CRIT
      @message.should include('a1')
      @message.should include('a2')
    end                              
  end

  describe "check_em" do
    it "crit" do
      @status, @message = Nagios::RunnerAsync.check({'method' => "bla_em", 's' => 'crit'})
      @status.should == Nagios::CRIT
      @message.should include('b1')
    end
    
    it "warn" do
      @status, @message = Nagios::RunnerAsync.check({'method' => "bla_em", 's' => 'warn'})
      @status.should == Nagios::WARN
      @message.should include('b2')
    end
    
    it "raise" do
      @status, @message = Nagios::RunnerAsync.check({'method' => "bla_em", 's' => 'raise'})
      @status.should == Nagios::OTHER
      @message.should include('b3')
    end                            
    
    it "other" do
      @status, @message = Nagios::RunnerAsync.check({'method' => "bla_em", 's' => 'other'})
      @status.should == Nagios::OTHER
      @message.should include('b4')
    end
    
    it "ok" do
      @status, @message = Nagios::RunnerAsync.check({'method' => "bla_em", 's' => 'ok'})
      @status.should == Nagios::OK
      @message.should include('b5')
    end
    
    it "crit_warn" do
      @status, @message = Nagios::RunnerAsync.check({'method' => "bla_em", 's' => 'crit_warn'})
      @status.should == Nagios::CRIT
      @message.should include('b1')
      @message.should include('b2')
    end                              
  end

end