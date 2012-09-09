class Nagios::Runner

  attr_accessor :started_at, :tag

  def initialize(params, &callback)
    @params = params.with_indifferent_access
    @callback = callback

    safe do
      prepare
      run
    end
  end

  def safe
    yield
  rescue Exception, NameError, Timeout::Error => ex 
    Nagios.logger.info "X= #{@tag} #{ex.message} (#{ex.backtrace.inspect})"
    @callback.call [Nagios::OTHER, "Exception: " + ex.message]
  end

  def safe_defer
    EM.defer do
      safe do
        yield
      end
    end
  end

  # synchrony check, for manual call
  def self.check(params, &callback)
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

private  

  def prepare
    @method = @params.delete(:method).to_s
    @method = @method.gsub(/[^_\.\-a-z0-9]/i, '')
    
    @started_at = Time.now
    @tag = "[#{@method}/#{@params.inspect}]"
    
    Nagios.logger.info "=> #{@tag}"
  end

  def run
    klass = "Nagios::#{@method.camelize}".constantize
    raise "unknown klass for method #{@method}" unless klass
    
    ancestor = klass.ancestors.detect{|an| an == Nagios::Check || an == Nagios::CheckEM }

    if ancestor == Nagios::Check
      # to thread pool
      safe_defer do
        script = klass.new(self, @params, &@callback)
        script.execute_and_result
      end
    elsif ancestor == Nagios::CheckEM
      script = klass.new(self, @params, &@callback)
      script.execute
      
    else      
      raise "unknown klass #{klass.inspect}"
    end
  end
  
end