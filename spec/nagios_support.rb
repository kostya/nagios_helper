require 'spec_helper'

class Nagios::Bla < Nagios::Check
  params :s
  
  def execute
    crit 'a1' if s == 'crit' || s == 'crit_warn'
    warn 'a2' if s == 'warn' || s == 'crit_warn'
    raise 'a3' if s == 'raise'
    other 'a4' if s == 'other'
    ok 'a5'
  end
  
end

class Nagios::BlaEm < Nagios::CheckEM

  params :s

  def execute
    crit 'b1' if s == 'crit' || s == 'crit_warn'
    warn 'b2' if s == 'warn' || s == 'crit_warn'
    raise 'b3' if s == 'raise'
    other 'b4' if s == 'other'
    ok 'b5'

    send_result
  end

end