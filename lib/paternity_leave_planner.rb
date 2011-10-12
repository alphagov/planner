class PaternityLeavePlanner < BirthPlanner

  def initialize(options = {})
    @due_date = options[:due_date]
    @start = options[:start] || {'days_after_due' => 1}
    run_validations! if options[:due_date]
  end
  
  def start
    if @start['days_after_due'] && due_date
      due_date + @start['days_after_due'].to_i
    else
      dateify(@start)
    end
  rescue ArgumentError
    nil
  end
  
  def earliest_start
    due_date
  end
  
  def latest_start
    due_date + 8 * 7 - 1
  end

  def valid_dates?
    validate_date_attribute(:due_date, @due_date)
    if ! (@start.is_a?(Hash) && @start['days_after_due'])
      validate_date_attribute(:start, @start)
    end
  end
  
  def start_date_in_range?
    return unless due_date
    if start >= latest_start
      errors.add(:start, "You must pick date on or before #{localize(latest_start, format: :long)}")
    elsif start < due_date
      errors.add(:start, "You must pick date on or after your due date")
    end
  end
  
  def ordinary_leave_ends
    anticipated_end = start + 2 * 7 -1
    if anticipated_end > latest_start
      latest_start
    else
      anticipated_end
    end
  end
  
  def period_of_potential_ordinary_leave
    due_date .. latest_start
  end
  
  def period_of_ordinary_leave
    if ! start.nil?
      start .. ordinary_leave_ends
    end
  end

  def period_of_additional_leave
    additional_leave_start = due_date + 19 * 7
    additional_leave_end = additional_leave_start + 26 * 7 -1
    additional_leave_start .. additional_leave_end
  end
  
  def key_dates
    due_date && 
      [
        ["Date by which you must have notified your employer", qualifying_week.last],
        ["Period of chosen Ordinary Paternity Leave", period_of_ordinary_leave],
        ["Period when you could take Ordinary Paternity Leave", period_of_potential_ordinary_leave],
        ["Period of Additional Paternity Leave", period_of_additional_leave],
        ["Expected week of childbirth", expected_week_of_childbirth],
        ["Baby's due date", due_date]
      ]
  end

end
