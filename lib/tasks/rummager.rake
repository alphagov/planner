namespace :rummager do
  desc "Reindex search engine"
  task :index => :environment do
    documents = [{
      "title" => "Planning your maternity leave",
      "description" => "",
      "format" => "planner",
      "link" => Plek.current.find("frontend") + "/maternity",
      "indexable_content" => "",
    }, {
      "title" => "Planning your paternity leave",
      "description" => "",
      "format" => "planner",
      "link" => Plek.current.find("frontend") + "/paternity",
      "indexable_content" => "",
    }]
    Rummageable.index documents
  end
end
