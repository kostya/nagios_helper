require 'active_support'
require 'active_support/inflector'
#require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/indifferent_access'
require 'logger'
require 'timeout'

module Nagios
  OK = 0
  WARN = 1
  CRIT = 2
  OTHER = 3
  
  CONCURRENCY_LEVEL = 100 # for server
  
  STATUS_NAMES = {
    OK => 'ok',
    WARN => 'warn',
    CRIT => 'crit',
    OTHER => 'other'
  }
  
  class << self
    def logger
      @logger ||= Logger.new(File.join(rails_root, "/log/nagios.log")).tap do |logger|
        logger.formatter = lambda { |s, d, p, m| "#{d.strftime("%d.%m.%Y %H:%M:%S")} #{m}\n" }
      end
    end
    
    def concurrency_level
      @concurrency_level
    end
    
    def concurrency_level=(cl)
      @concurrency_level = cl
      EM.threadpool_size = cl
    end
    
    def status_name(status)
      ':' + STATUS_NAMES[status] || 'unknown' 
    end
    
    def rails_root
      defined?(RAILS_ROOT) ? RAILS_ROOT : (defined?(Rails) ? Rails.root : nil)
    end
  end
  
  autoload :Check,        'nagios_check/check'
  autoload :CheckEM,      'nagios_check/check_em'
  autoload :Runner,       'nagios_check/runner'
  autoload :RunnerAsync,  'nagios_check/runner_async'
end