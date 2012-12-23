require 'rubygems'
require "bundler"
Bundler.setup
ENV['RAILS_ENV'] ||= 'test'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'nagios_helper'

require 'nagios_support'

def Nagios.rails_root
  File.join(File.dirname(__FILE__), %w{ .. })
end