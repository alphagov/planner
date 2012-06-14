class MaternityLeavePlanner < BirthPlanner

  def initialize(options = {})
    @due_date = options[:due_date]
    @start = options[:start] || {'days_before_due' => 14}
    run_validations! if options[:due_date]
  end

  def recognized_params
    {due_date: @due_date, start: @start}
  end

  def self.slug; "maternity"; end
  def self.title; "Planning your Maternity Leave"; end
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
        ["You must tell your employer by:", qualifying_week.last],
        ["The earliest you can start your Maternity Leave is:", earliest_start],
        ["Ordinary Maternity Leave (first 26 weeks):", period_of_ordinary_leave],
        ["Additional Maternity Leave (up to 26 weeks more):", period_of_additional_leave],
        ["Your baby is due on:", due_date]
      ]
  end

end
