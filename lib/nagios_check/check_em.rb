class Nagios::CheckEM < Nagios::Check

  def run
    safe do
      execute
    end
  end
  
  def execute
    send_result
  end
  
  def safe_defer
    EM.defer do
      safe do
        yield
      end
    end
  end
  
  # synchrony check, for manually calls
  # do not call in thin!!!
  def self.check(params = {})
    result = nil
    
    EM.run do
      inst = self.new(params) do |res|
        begin
          result = res
        ensure
          EM.stop 
        end
      end

      inst.run
    end
    
    result
  end  

end