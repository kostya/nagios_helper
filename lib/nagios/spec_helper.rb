if defined?(RAILS_ENV) && RAILS_ENV['test']

  Nagios.load_initializers

  module EM
    def self.defer
      yield
    end
  end

end