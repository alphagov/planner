class AdoptionLeavePlanner < BirthPlanner

  validate :valid_dates?, :start_date_in_range?, :arrival_after_match_date?

  def initialize(options = {})
    @arrival_date = options[:arrival_date]
    @match_date = options[:match_date]
    @start = options[:start] || {'days_before_arrival' => 14}
  end

  def recognized_params
    {arrival_date: @arrival_date, match_date: @match_date, start: @start}
  end

  def self.slug; "adoption"; end
  def self.title; "Planning your Adoption Leave"; end
  def self.need_id; 1948; end

  def start
    if @start['days_before_arrival'] && arrival_date
      arrival_date - @start['days_before_arrival'].to_i
    else
      dateify(@start)
    end
  rescue ArgumentError
    nil
  end

  def earliest_start
    arrival_date - 14
  end

  def arrival_date
    dateify(@arrival_date)
  rescue ArgumentError
    nil
  end

  def match_date
    dateify(@match_date)
  rescue ArgumentError
    nil
  end

  def valid_dates?
    validate_date_attribute(:arrival_date, @arrival_date)
    validate_date_attribute(:match_date, @match_date)

    if ! (@start.is_a?(Hash) && @start['days_before_arrival'])
      validate_date_attribute(:start, @start)
    end
  end

  def start_date_in_range?
    return unless arrival_date && match_date
    if start < earliest_start
      errors.add(:start, "You must pick date on or after #{localize(earliest_start, format: :long)}")
    elsif start > arrival_date
      errors.add(:start, "You must pick date on or before the arrival date")
    end
  end

  def arrival_after_match_date?
    return unless arrival_date && match_date
    if match_date >= arrival_date
      errors.add(:arrival_date, "Arrival date must be after match date")
    end
  end

  def period_of_ordinary_leave
    if ! start.nil?
      start .. start + 26 * 7
    end
  end

  def expected_week_of_arrival
    if !arrival_date.nil?
      sunday = arrival_date - arrival_date.wday
      saturday = sunday + 6
      sunday..saturday
    end
  end

  def expected_week_of_match
    if !match_date.nil?
      sunday = match_date - match_date.wday
      saturday = sunday + 6
      sunday..saturday
    end
  end

  def qualifying_week
    expected_week_of_match && weeks_later(expected_week_of_match, -1)
  end

  def period_of_additional_leave
    period_of_ordinary_leave && weeks_later(period_of_ordinary_leave, 26)
  end

  def key_dates
    arrival_date && match_date &&
      [
        ["You must tell your employer by:", qualifying_week.last],
        ["Earliest date you can start your Adoption Leave:", earliest_start],
        ["Ordinary Adoption Leave:", period_of_ordinary_leave],
        ["Additional Adoption Leave:", period_of_additional_leave],
      ]
  end

end
