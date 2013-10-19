NagiosHelper
============

Gem for writing, testing, executing Nagios checks inside Rails application.
Checks running throught http or script.

```
gem 'nagios_helper', :require => 'nagios'
```

    $ rails generate nagios:check some

Check example:
--------------

app/nagios/some.rb

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

Run:

    $ RAILS_ENV=production bundle exec nagios_check some x 1

### Nagios Check Initilizers:
All files in app/nagios/initializers will auto loads.

Server:
-------

### Inside rails server

Create controller: app/controllers/nagios_controller.rb

```ruby
class NagiosController < ApplicationController
  http_basic_authenticate_with :name => "nagios", :password => "password"

  def check
    status, message = Nagios::Runner.check(params)
    render :text => "#{status}|#{message}", :layout => false
  end

end
```

    $ curl http://nagios:password@localhost:3000/nagios/check?method=some&x=1
    