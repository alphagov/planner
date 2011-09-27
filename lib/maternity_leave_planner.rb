class MaternityLeavePlanner
  attr_reader :due_date, :start
  
  def initialize(options = {})
    raise ArgumentError, 'due_date required' unless options.has_key?(:due_date)
    @due_date = dateify(options[:due_date])
    @start = validate_start_date(options[:start] || default_start)
  end
  
  def expected_week_of_childbirth
    sunday = @due_date - @due_date.wday
    sunday..(sunday + 6)
  end
  
  def qualifying_week
    weeks_later(expected_week_of_childbirth, -15)
  end
  
  def earliest_start
    expected_week_of_childbirth.first - 11 * 7
  end

  def validate_start_date(date)
    proposed_start = dateify(date)
    if proposed_start < earliest_start
      raise "Earliest start of maternity leave is #{earliest_start}"
    elsif proposed_start >= @due_date
      raise "Maternity leave must start before due date"
    end
    proposed_start
  end
  
  def period_of_ordinary_leave
    @start .. @start + 26 * 7 - 1
  end

  def period_of_additional_leave
    weeks_later(period_of_ordinary_leave, 26)
  end
  
  def key_dates
    [
      ["Date by which you must have notified your employer", qualifying_week.last],
      ["Earliest you may start maternity leave", earliest_start],
      ["Period of Ordinary Maternity Leave", period_of_ordinary_leave],
      ["Period of Additional Maternity Leave", period_of_additional_leave],
      ["Expected week of childbirth", expected_week_of_childbirth],
      ["Baby's due date", @due_date]
    ]
  end
  
  private
    def weeks_later(range, weeks)
      (range.first + weeks * 7) .. (range.last + weeks * 7)
    end
    
    def dateify(dateish)
      dateish.is_a?(Date) ? dateish : Date.parse(dateish.to_s)
    end

    def default_start
      expected_week_of_childbirth.first - 2 * 7
    end

end
