class PlansController < ApplicationController
  before_filter :find_planner, only: :show

  def index
    @planners = planners
  end
  
  def show
    if @planner
      render "show_#{@planner_name}"
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
end
