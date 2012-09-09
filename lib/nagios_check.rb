require File.join(File.dirname(__FILE__), %w{ nagios_check boot })

require 'eventmachine'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'logger'

CONCURRENCY_LEVEL = 100 unless defined?(CONCURRENCY_LEVEL)
EM.threadpool_size = CONCURRENCY_LEVEL

module Nagios
  OK = 0
  WARN = 1
  CRIT = 2
  OTHER = 3
  
  STATUS_NAMES = {
    OK => 'ok',
    WARN => 'warn',
    CRIT => 'crit',
    OTHER => 'other'
  }
  
  class << self
    def logger
      @logger ||= Logger.new(File.join(RAILS_ROOT, "/log/nagios.log")).tap do |logger|
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
  end
end

require File.join(File.dirname(__FILE__), %w{ nagios_check check })
require File.join(File.dirname(__FILE__), %w{ nagios_check helper })
require File.join(File.dirname(__FILE__), %w{ nagios_check check_em })
require File.join(File.dirname(__FILE__), %w{ nagios_check runner })

helper = File.join(RAILS_ROOT, %w{lib nagios nagios_helper})
require(helper) if File.exists?(helper)

Dir[File.join(RAILS_ROOT, %w{ app nagios ** *.rb})].each do |file|
  require file
end
