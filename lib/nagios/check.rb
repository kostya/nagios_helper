class Nagios::Check

  TYPES = %w{ok crit other warn} unless defined?(TYPES)

  attr_reader :check_name

  def initialize(params = {}, &callback)
    @params = params.with_indifferent_access
    @callback = callback
    @started_at = Time.now
    @tag = "#{self.class.name}/#{params.inspect}"
    @check_name = self.class.name.underscore.split("/").last

    logger.info "=> #{@tag}"

    @ok = []
    @crit = []
    @warn = []
    @other = []
  end

  def result
    prefix = self.respond_to?(:message_prefix) ? message_prefix : ''
    errors = prefix + [@crit, @warn, @other].flatten * '; '

    if @crit.present?
      [Nagios::CRIT, errors]
    elsif @warn.present?
      [Nagios::WARN, errors]
    elsif @other.present?
      [Nagios::OTHER, errors]
    else
      @ok = ['OK'] if prefix.empty? && @ok.empty?
      [Nagios::OK, prefix + @ok * '; ']
    end
  end

  def run(additional_params = nil)
    if additional_params && additional_params.is_a?(Hash)
      @params.merge!(additional_params.with_indifferent_access)
    end

    safe do
      execute
      send_result
    end
  end

  alias check run

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
    define_method(m) do |mes, &block|
      if block
        if block.call
          instance_variable_get("@#{m}") << mes
        end
      else
        instance_variable_get("@#{m}") << mes
      end
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
    syms.each { |s| define_method(s) { (r = @params[s]) && r.to_s } }
  end

  def safe
    yield
  rescue Exception, NameError, Timeout::Error => ex
    logger.info "X= #{@tag} #{ex.message} (#{ex.backtrace.inspect})"

    other "Exception: " + ex.message
    send_result
  end

  def tresholds(method, w, e, &block)
    res = send(method)
    msg = block[res]
    if e && res >= e
      crit msg
    elsif w && res >= w
      warn msg
    else
      ok msg
    end
  end

  class << self
    def check_name
      @check_name ||= self.name.underscore.split("/").last
    end
  end
end
