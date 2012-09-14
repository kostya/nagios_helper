NagiosCheck
===========

Rails gem for writing, testing, executing Nagios checks inside Rails application.
Checks running throught http or binary(nrpe).

    gem 'nagios_check'
    
    rails generate nagios:check some
    
Check example: app/nagios/some.rb
```ruby
class Nagios::Some < Nagios::Check
  params :x

  def execute
    count = User.count + x.to_i
  
    warn "hmmm" if count < 10
    crit "ouch" if count < 5
    
    ok "good #{count}"
  end

end
```

Run simple check: 

    $ RAILS_ENV=production bundle exec nagios_check some x 1
    

Run server:
###########
