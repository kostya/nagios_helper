if defined?(RAILS_ENV) && RAILS_ENV['test']

  Nagios.load_initializers

  Dir[Nagios.root + "/**/*.rb"].each do |file|
    require file
  end

  module EM
    def self.defer
      yield
    end
  end

end