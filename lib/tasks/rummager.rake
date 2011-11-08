namespace :rummager do
  desc "Reindex search engine"
  task :index => :environment do
    documents = [{
      "title" => "Planning your maternity leave",
      "description" => "Maternity leave is time off work to look after your new baby. Find out when you can take it.",
      "format" => "planner",
      "link" => Plek.current.find("frontend") + "/maternity",
      "indexable_content" => "",
    }, {
      "title" => "Planning your paternity leave",
      "description" => "Paternity leave is time off work to look after your new baby. Find out when you can take it.",
      "format" => "planner",
      "link" => Plek.current.find("frontend") + "/paternity",
      "indexable_content" => "",
    }]
    Rummageable.index documents
  end
end
