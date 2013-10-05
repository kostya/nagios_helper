if defined?(RAILS_ENV) && RAILS_ENV['test']

  module EM
    def self.defer
      yield
    end
  end

end