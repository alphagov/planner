class CalendarRenderer
  include ActionView::Helpers::TranslationHelper
  
  def initialize(range, options = {})
    @range = range
    @options = options
    @numcols = @options[:numcols] || 7
    @locale = options[:locale] || :en
    @decorations = normalize_decorations(@options[:decorations] || [])
  end
  
  def render
    html = ''
    start = @range.first
    month = Date.new(start.year, start.month, 1)
    while month < @range.last
      html << render_month(month)
      month = month.next_month
    end
    html.html_safe
  end
  
  def render_month(month)
    html = "<table>"
    html << "<tr><th colspan='#{@numcols}'>#{localize(month, format: '%B %Y')}</th></tr>"
    html << "<tr>"
    html << %w{S M T W T F S}.map {|day| "<th>#{day}</th>"}.join
    html << "</tr>"
    start_of_month = Date.new(month.year, month.month, 1)
    date_range = (start_of_month .. start_of_month.next_month - 1)
    initial_padding = [nil] * start_of_month.wday
    dates = initial_padding + date_range.to_a
    dates.each_slice(@numcols) do |row_of_dates|
      html << "<tr>"
      html << row_of_dates.map { |date| render_date(date) }.join
      html << "</tr>"
    end
    html << "</table>"
    html.html_safe
  end
  
  def render_date(date)
    if date.nil? 
      "<td>&nbsp;</td>"
    else
      decorations = decorations_for(date)
      css_class = decorations.size > 0 ? "class='#{decorations.join(' ')}'" : ''
      "<td #{css_class}>#{date.mday}</td>"
    end
  end
  
  def decorations_for(date)
    @decorations.select do |i, decoration|
      label, date_or_range = decoration
      if date_or_range.is_a?(Date) 
        date == date_or_range
      else
        date_or_range.cover?(date)
      end
    end.keys
  end
   
  private
    def normalize_decorations(decorations)
      if decorations.is_a?(Array)
        Hash[decorations.map.with_index { |decoration, i| ["key-date-#{i}", decoration] }]
      else
        decorations
      end
    end
end