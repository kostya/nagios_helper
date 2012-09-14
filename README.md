NagiosHelper
============

Gem for writing, testing, executing Nagios checks inside Rails application.
Checks running throught http or binary(nrpe).

```
gem 'nagios_helper'
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

  def check
    status, message = Nagios::Runner.check(params)

    respond_to do |f|
      f.html{ status + "," + message }
    end
  end

end
```

    $ curl localhost:3000/nagios/check?method=some&x=1

### Outside rails server

With using nonblocking EM-server [nagios_rails_server](http://github.com/kostya/nagios_rails_server)

AR connections should be configured with pool: 100.

    $ RAILS_ENV=production bundle exec nagios_server
    $ curl localhost:9292/check/some?x=1

