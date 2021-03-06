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

  describe "Nagios::BlockObj" do
    it "should be crit" do
      st, mes = Nagios::BlockObj.new(:s => '1').check
      st.should == Nagios::OK
      mes.should == '1'
    end

    it "should be crit" do
      st, mes = Nagios::BlockObj.new(:s => '2').check
      st.should == Nagios::CRIT
      mes.should == '2'
    end
  end

  it "message_prefix" do
    st, mes = Nagios::Prefix.new(:s => '1').check
    st.should == Nagios::CRIT
    mes.should == 'some 1'
  end

  it "message_prefix" do
    st, mes = Nagios::Prefix.new(:s => '2').check
    st.should == Nagios::OK
    mes.should == 'some 2'
  end

  describe "tresholds" do
    it "ok" do
      st, mes = Nagios::Tresh.new(:s => '2', 'c' => '10').check
      st.should == Nagios::OK
      mes.should == 'msg 2'
    end

    it "warn" do
      st, mes = Nagios::Tresh.new(:s => '7', 'c' => '10').check
      st.should == Nagios::WARN
      mes.should == 'msg 7'
    end

    it "crit" do
      st, mes = Nagios::Tresh.new(:s => '15', 'c' => '10').check
      st.should == Nagios::CRIT
      mes.should == 'msg 15'
    end

    it "crit undefined should be warn" do
      st, mes = Nagios::Tresh.new(:s => '15').check
      st.should == Nagios::WARN
      mes.should == 'msg 15'
    end
  end

  it "check_name" do
    c = Nagios::Tresh.new
    c.check_name.should == 'tresh'
    Nagios::Tresh.check_name.should == 'tresh'
  end
end
