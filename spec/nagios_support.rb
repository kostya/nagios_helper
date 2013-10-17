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


# block parameter
class Nagios::BlockObj < Nagios::Check
  params :s

  def execute
    crit("2") { s == '2' }
    ok "1"
  end
end

class Nagios::Prefix < Nagios::Check
  params :s

  def message_prefix
    'some '
  end

  def execute
    s == '1' ? crit('1') : ok('2')
  end
end

class Nagios::Tresh < Nagios::Check
  params :s, :c

  def some_m
    s && s.to_i
  end

  def criti
    c && c.to_i
  end

  def execute
    tresholds(:some_m, 5, criti) { |x| "msg #{x}" }
  end
end
