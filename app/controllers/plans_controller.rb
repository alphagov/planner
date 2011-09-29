class PlansController < ApplicationController
  before_filter :find_planner, only: :show

  def index
    @planners = planners
  end
  
  def show
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
        maternity: MaternityLeavePlanner
      }
    end
    
    def find_planner
      @planner = nil
      @planner_name = params[:id].to_sym
      if planners.has_key?(@planner_name)
        @planner = planners[@planner_name].new(params.symbolize_keys)
      end
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
      
    end
end
