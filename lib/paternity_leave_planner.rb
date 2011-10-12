class PaternityLeavePlanner < BirthPlanner
  include ActiveModel::Validations
  include ActionView::Helpers::TranslationHelper
  
  validate :valid_dates?, :start_date_in_range?
  
  def initialize(options = {})
    @due_date = options[:due_date]
    @start = options[:start] || {'days_after_due' => 1}
    run_validations! if options[:due_date]
  end
  
  # Range of dates which should be used to display all of the information in this planner
  def range
    from = first_of_month(qualifying_week.last)
    to = (from >> 16) - 1
    from..to
  end
  
  def due_date
    dateify(@due_date)
  rescue ArgumentError
    nil
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
  
  def expected_week_of_childbirth
    if !due_date.nil?
      sunday = due_date - due_date.wday
      saturday = sunday + 6
      sunday..saturday
    end
  end
  
  def qualifying_week
    expected_week_of_childbirth && weeks_later(expected_week_of_childbirth, -15)
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
  
  private
    def weeks_later(range, weeks)
      (range.first + weeks * 7) .. (range.last + weeks * 7)
    end
    
    def validate_date_attribute(attribute_name, dateish)
      dateify(dateish)
    rescue ArgumentError
      errors.add(attribute_name, "Sorry, that's not a proper date.")
    end
    
    def dateify(dateish)
      case dateish
      when Date then dateish
      when Hash then
        Date.parse("#{dateish['year']}-#{dateish['month']}-#{dateish['day']}")
      else
        Date.parse(dateish.to_s)
      end
    end
    
    def first_of_month(date)
      Date.new(date.year, date.month, 1)
    end
end
