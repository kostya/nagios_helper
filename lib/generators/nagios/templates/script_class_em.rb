class Nagios::<%= class_name %> < Nagios::CheckEM
  # You can define script parameters this way:
  params :x # and can use further just x

  def execute
    EM.next_tick do
      safe do
        warn "hmmm" if x == 'w'
        crit "ouch" if x == 'c'
        ok "good"

        send_result # should be!, for sending results
      end
    end
  end

end