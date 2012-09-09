if defined?(RAILS_ENV) && RAILS_ENV['test']

  require 'nagios_check'
  
  module EM
    def self.defer
      yield
    end
  end
  
end