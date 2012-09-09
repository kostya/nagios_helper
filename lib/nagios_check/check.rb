class Nagios::Check

  TYPES = %w{ok crit other warn} unless defined?(TYPES)

  attr_accessor :runner

  def initialize(runner, params, &callback)
    @runner = runner
    @params = params
    @callback = callback
    @started_at = Time.now
    
    @ok = []
    @crit = []
    @warn = []
    @other = []
  end
  
  def result
    errors = [@crit, @warn, @other].flatten * '; '
            
    if @crit.present?
      [Nagios::CRIT, "CRIT: " + errors]
    elsif @warn.present?
      [Nagios::WARN, "WARN: " + errors]
    elsif @other.present?
      [Nagios::OTHER, errors]
    else
      [Nagios::OK, "OK: " + @ok * '; ']
    end
  end

  def execute_and_result
    execute
    send_result
  end
  
  # synchrony check, for manually calls
  def self.check(params = {})
    name = self.name.underscore.split("/").last
    Nagios::Runner.check({:method => name}.merge(params))
  end
  
private 

  def send_result
    st, mes = res = self.result
    
    logger.info "<= #{runner.tag} = [#{Nagios.status_name(st)}, #{mes}], wait: (#{@started_at - runner.started_at}), time: (#{Time.now - @started_at})"
    @callback[ res ]
    
    res
  end

  def execute
    raise "realize me"
  end
  
  TYPES.each do |m|
    define_method(m) do |mes|
      instance_variable_get("@#{m}") << mes
    end
  end
  alias :critical :crit
  alias :error :crit
  alias :warning :warn
  
  def self.logger
    Nagios.logger
  end
  
  def logger
    Nagios.logger
  end
  
  def self.params(*syms)
    syms.each { |s| define_method(s) { @params[s] } }
  end
  
end