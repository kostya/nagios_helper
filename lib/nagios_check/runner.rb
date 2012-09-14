class Nagios::Runner

  def initialize(params, &callback)
    @params = params.with_indifferent_access
    @callback = callback
    @method = @params.delete(:method).to_s
    @method = @method.gsub(/[^_\.\-a-z0-9]/i, '')
    
    raise "method should be" if @method.blank?

    Nagios.mutex.synchronize{ load_initializers }
    Nagios.mutex.synchronize{ load_class }
    
    run
  end

  # synchrony check, for manual call
  def self.check(params = {})
    result = nil
    
    self.new(params) do |res|
      result = res
    end
    
    result
  end

protected  

  def constantize
    "Nagios::#{@method.camelize}".constantize
  rescue LoadError, NameError
    nil               
  end
  
  def load_initializers
    unless Nagios.project_initializer_loaded
      Dir[Nagios.rails_root + "/app/nagios/initializers/*.rb"].each do |file|
        require File.expand_path(file)
      end                          
            
      Nagios.project_initializer_loaded = true
    end
  end

  def load_class
    klass = constantize
    
    unless klass 
      Dir[Nagios.rails_root + "/app/nagios/**/#{@method}.rb"].each do |file|
        require File.expand_path(file)
      end
      
      klass = constantize
    end
    
    raise "unknown klass #{@klass.inspect}" unless klass
    
    @klass = klass
    @ancestor = klass.ancestors.detect{|an| an == Nagios::Check || an == Nagios::CheckEM }
  end

  def run
    if @ancestor == Nagios::Check
      script = @klass.new(@params, &@callback)
      script.run
    elsif @ancestor == Nagios::CheckEM
      raise "cant run EM check in Sync Runner"
    else      
      raise "unknown klass #{@klass.inspect}"
    end
  end
  
end