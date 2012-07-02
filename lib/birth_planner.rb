class BirthPlanner
  include ActiveModel::Validations
  include ActionView::Helpers::TranslationHelper

  validate :valid_dates?, :start_date_in_range?

  def self.description
    # This is a filthy hack, and should die when we next refactor this app
    I18n.translate("plans.show_#{self.slug}_blank.heading").strip
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
