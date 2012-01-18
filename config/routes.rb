Planner::Application.routes.draw do
  match '/warmup', controller: "GdsWarmupController::Warmup", action: :index
  match '/:id', :to => 'plans#show', :as => :plan
end
