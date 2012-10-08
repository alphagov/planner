Planner::Application.routes.draw do
  match '/:id', :to => 'plans#show', :as => :plan
end
