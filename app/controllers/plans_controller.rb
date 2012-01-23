class PlansController < ApplicationController
  before_filter :find_planner
  rescue_from ActionView::Template::Error, with: :simple_500

  def show
    expires_in 24.hours, :public => true unless Rails.env.development?
    if @planner
      respond_to do |format|
        format.html { render "show_#{@planner_name}" }
        format.xml { render :xml => ranges_as_hashes(@planner.key_dates).to_xml }
        format.json { render :json => ranges_as_hashes(@planner.key_dates).to_json }
        format.ics { render :text => to_ics(@planner.key_dates) }
      end
    else
      render file: "#{Rails.root}/public/404.html",  status: 404
    end
  end

  private
    def planners
      {
        maternity: {
          planner: MaternityLeavePlanner,
          need_id: 855,
        },
        paternity: {
          planner: PaternityLeavePlanner,
          need_id: 1947,
        },
      }
    end

    def find_planner
      @planner = nil
      @planner_name = params[:id].to_sym
      details = planners[@planner_name] or return

      @planner = details[:planner].new(params.symbolize_keys)
      set_slimmer_headers need_id: details[:need_id]

    rescue ArgumentError
      nil
    end

    def ranges_as_hashes(key_dates)
      key_dates.map do |label, date_or_range|
        if date_or_range.is_a?(Range)
          date_or_range = {from: date_or_range.first, to: date_or_range.last}
        end
        [label, date_or_range]
      end
    end

    def to_ics(key_dates)
      RiCal.Calendar do |cal|
        key_dates.each do |label, date_or_range|
          cal.event do |event|
            event.summary "Maternity Leave planner: #{label}"
            case date_or_range
            when Date
              event.dtstart     date_or_range
              event.dtend       date_or_range
            when Range
              event.dtstart     date_or_range.first
              event.dtend       date_or_range.last
            else
              raise "Unexpected data #{date_or_range.inspect} in key_dates"
            end
          end
        end
      end.export
    end

    def simple_500
      head 500 and return
    end
end
