require 'eventmachine'

class Nagios::RunnerAsync < Nagios::Runner

  # synchrony check, for manual call
  # do not run in EM
  def self.check(params = {})
    raise "cant check sync in running EM" if EM.reactor_running?
  
    result = nil 
    EM.run do
      self.new(params) do |res|
        begin
          result = res
        ensure
          EM.stop
        end        
      end
    end
    
    result
  end

protected  

  def run
    if @ancestor == Nagios::Check
      # to thread pool
      EM.defer do
        script = @klass.new(@params, &@callback)
        script.run
      end
      
    elsif @ancestor == Nagios::CheckEM
      script = @klass.new(@params, &@callback)
      script.run
      
    else      
      raise "unknown klass #{klass.inspect}"
    end
  end
  
end