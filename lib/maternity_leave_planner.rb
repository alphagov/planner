class MaternityLeavePlanner < BirthPlanner
  
  def initialize(options = {})
    @due_date = options[:due_date]
    @start = options[:start] || {'days_before_due' => 14}
    run_validations! if options[:due_date]
  end

  def self.slug; "maternity"; end
  def self.title; "Planning your maternity leave"; end
  def self.need_id; 855; end  

  def start
    if @start['days_before_due'] && due_date
      due_date - @start['days_before_due'].to_i
    else
      dateify(@start)
    end
  rescue ArgumentError
    nil
  end
  
  def earliest_start
    expected_week_of_childbirth && expected_week_of_childbirth.first - 11 * 7
  end

  def valid_dates?
    validate_date_attribute(:due_date, @due_date)
    if ! (@start.is_a?(Hash) && @start['days_before_due'])
      validate_date_attribute(:start, @start)
    end
  end
  
  def start_date_in_range?
    return unless due_date
    if start < earliest_start
      errors.add(:start, "You must pick date on or after #{localize(earliest_start, format: :long)}")
    elsif start >= due_date
      errors.add(:start, "You must pick date on or before your due date")
    end
  end
  
  def period_of_ordinary_leave
    if ! start.nil?
      start .. start + 26 * 7 - 1
    end
  end

  def period_of_additional_leave
    period_of_ordinary_leave && weeks_later(period_of_ordinary_leave, 26)
  end
  
  def key_dates
    due_date && 
      [
        ["Date by which you must have notified your employer", qualifying_week.last],
        ["Earliest you may start maternity leave", earliest_start],
        ["Period of Ordinary Maternity Leave", period_of_ordinary_leave],
        ["Period of Additional Maternity Leave", period_of_additional_leave],
        ["Baby's due date", due_date]
      ]
  end

end
