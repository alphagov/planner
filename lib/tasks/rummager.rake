namespace :rummager do
  desc "Reindex search engine"
  task :index => :environment do
    documents = [{
      "title" => "Planning your Maternity Leave",
      "description" => "Maternity Leave is time off work to look after your new baby. Find out when you can take it.",
      "format" => "planner",
      "section" => "family",
      "subsection" => "maternity-and-paternity",
      "link" => "/maternity",
      "indexable_content" => "",
    }, {
      "title" => "Planning your paternity Leave",
      "description" => "Paternity Leave is time off work to look after your new baby. Find out when you can take it.",
      "format" => "planner",
      "section" => "family",
      "subsection" => "maternity-and-paternity",
      "link" => "/paternity",
      "indexable_content" => "",
    }]
    Rummageable.index documents
  end
end
