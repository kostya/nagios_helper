require 'active_support'
require 'active_support/inflector'
begin
  require 'active_support/core_ext/object/blank'
rescue LoadError
end
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
    OK => 'OK',
    WARN => 'WARN',
    CRIT => 'CRIT',
    OTHER => 'OTHER'
  }

  class << self
    def logger
      @logger ||= Logger.new(File.join(rails_root, "/log/nagios.log")).tap do |logger|
        logger.formatter = lambda { |s, d, p, m| "#{d.strftime("%d.%m.%Y %H:%M:%S")} #{m}\n" }
      end
    end

    attr_accessor :project_initializer_loaded

    def concurrency_level
      @concurrency_level
    end

    def mutex
      @mutex ||= Mutex.new
    end

    def concurrency_level=(cl)
      @concurrency_level = cl
      EM.threadpool_size = cl
    end

    def status_name(status)
      ":#{ STATUS_NAMES[status] || 'unknown' }"
    end

    def rails_root
      @rails_root ||= defined?(RAILS_ROOT) ? RAILS_ROOT : (defined?(Rails) ? Rails.root : nil)
    end

    def rails_root=(rails_root)
      @rails_root = rails_root
    end

    def root
      @root ||= File.join(rails_root, %w{ app nagios })
    end

    def root=(root)
      @root = root
    end

    def load_initializers
      mutex.lock

      unless project_initializer_loaded
        Dir[root + "/initializers/*.rb"].each do |file|
          require File.expand_path(file)
        end

        project_initializer_loaded = true
      end

    ensure
      mutex.unlock
    end
  end

  autoload :Check,        'nagios/check'
  autoload :CheckEM,      'nagios/check_em'
  autoload :Runner,       'nagios/runner'
  autoload :RunnerAsync,  'nagios/runner_async'
end
