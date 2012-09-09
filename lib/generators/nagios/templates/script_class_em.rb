class Nagios::<%= class_name %> < Nagios::CheckEM
  # You can define script parameters this way:
  params :x # and can use further just x

  def execute
    EM.next_tick do
      safe do
        warn "hmmm" if x == 'w'
        crit "ouch" if x == 'c'
        ok "good"
    
        send_result # for sending results, should be!
      end
    end
  end
  
end