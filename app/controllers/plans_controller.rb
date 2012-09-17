require 'gds_api/helpers'

class PlansController < ApplicationController
  include GdsApi::Helpers
  before_filter :find_planner

  def show
    expires_in 24.hours, :public => true unless Rails.env.development?
    if @planner
      respond_to do |format|
        format.html do
          @artefact = content_api.artefact(params[:id])
          set_slimmer_artefact(@artefact)
          render "show_#{@planner.class.slug}"
        end
        if @planner.errors.any? || @planner.key_dates.nil?
          format.any(:xml, :json, :ics) { head 400 }
        else
          format.xml { render :xml => ranges_as_hashes(@planner.key_dates).to_xml }
          format.json { render :json => ranges_as_hashes(@planner.key_dates).to_json }
          format.ics { render :text => to_ics(@planner.key_dates, @planner.class.slug) }
        end
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
        adoption: {
          planner: AdoptionLeavePlanner,
          need_id: 1948
        }
      }
    end

    def find_planner
      @planner = nil
      planner_name = params[:id].to_sym
      details = planners[planner_name] or return

      @planner = details[:planner].new(params.symbolize_keys)

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

    def to_ics(key_dates, title)
      RiCal.Calendar do |cal|
        key_dates.each do |label, date_or_range|
          cal.event do |event|
            event.summary "#{title.capitalize} Leave planner: #{label}"
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
end
