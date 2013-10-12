class Nagios::Check

  TYPES = %w{ok crit other warn} unless defined?(TYPES)

  def initialize(params = {}, &callback)
    @params = params.with_indifferent_access
    @callback = callback
    @started_at = Time.now
    @tag = "#{self.class.name}/#{params.inspect}"

    logger.info "=> #{@tag}"

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

  def run
    safe do
      execute
      send_result
    end
  end

  alias check run
  alias do! run

  # synchrony check, for manually calls
  def self.check(params = {})
    result = nil

    inst = self.new(params) do |res|
      result = res
    end

    inst.run
  end

  def self.default_error(mes)
    [Nagios::OTHER, mes]
  end

protected

  def send_result
    st, mes = res = self.result

    logger.info "<= #{@tag} = [#{Nagios.status_name(st)}, #{mes}], time: (#{Time.now - @started_at})"
    @callback[ res ] if @callback

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
    syms.each { |s| define_method(s) { @params[s].to_s } }
  end

  def safe
    yield
  rescue Exception, NameError, Timeout::Error => ex
    logger.info "X= #{@tag} #{ex.message} (#{ex.backtrace.inspect})"

    other "Exception: " + ex.message
    send_result
  end

end