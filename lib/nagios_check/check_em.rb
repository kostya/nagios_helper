class Nagios::CheckEM < Nagios::Check
  
  def execute
    send_result
  end

  def safe(&block)
    runner.safe(&block)
  end

  def safe_defer(&block)
    runner.safe_defer(&block)
  end

end