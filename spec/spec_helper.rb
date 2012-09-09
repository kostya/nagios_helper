require 'rubygems'
require "bundler"
Bundler.setup
ENV['RAILS_ENV'] ||= 'test'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'nagios_check'

require 'nagios_support'
