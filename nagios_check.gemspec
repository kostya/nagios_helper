# -*- encoding: utf-8 -*-
#require File.dirname(__FILE__) + "/lib/bin_script/version"

Gem::Specification.new do |s|
  s.name = %q{nagios_check}
  s.version = "0.1"

  s.authors = ["Makarchev Konstantin"]
  
  s.description = %q{Rails gem for easy writing, testing, executing nagios checks inside Rails application.}
  s.summary = %q{Rails gem for easy writing, testing, executing nagios checks inside Rails application.}

  s.email = %q{kostya27@gmail.com}
  s.homepage = %q{http://github.com/kostya/nagios_check}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport'
  s.add_dependency 'eventmachine'
  
  s.add_dependency 'async_sinatra'
  
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
   
end