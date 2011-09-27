class PlansController < ApplicationController
  
  def show
    planner_name = params[:id].to_sym
    if planners.has_key?(planner_name)
      @planner = planners[planner_name].new(params)
      render "show_#{planner_name}"
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
end
