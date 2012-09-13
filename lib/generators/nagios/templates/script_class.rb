class Nagios::<%= class_name %> < Nagios::Check
  # You can define script parameters this way:
  params :x

  def execute
    warn "hmmm" if x == 'w'
    crit "ouch" if x == 'c'
    ok "good"
  end

end