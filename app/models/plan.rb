class Plan
  def self.all_slugs
    all.map { |planner| planner.slug }.sort
  end

  def self.all
    [MaternityLeavePlanner, PaternityLeavePlanner]
  end
  
  def self.load slug, attributes = {}
    all.find {|planner| planner.slug == slug}.new attributes
  end
end
