class MaternityLeavePlanner
  include ActiveModel::Validations
  include ActionView::Helpers::TranslationHelper
  
  validate :valid_dates?, :start_date_in_range?
  
  def initialize(options = {})
    @due_date = options[:due_date]
    @start = options[:start] || default_start
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
    dateify(@start)
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
    expected_week_of_childbirth && expected_week_of_childbirth.first - 11 * 7
  end

  def valid_dates?
    validate_date_attribute(:due_date, @due_date)
    validate_date_attribute(:start, @start)
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

    def default_start
      expected_week_of_childbirth && expected_week_of_childbirth.first - 2 * 7
    end
    
    def first_of_month(date)
      Date.new(date.year, date.month, 1)
    end
end
