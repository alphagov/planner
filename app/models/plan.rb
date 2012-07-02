class Plan
  def self.all_slugs
    all.map(&:slug).sort
  end

  def self.all
    [MaternityLeavePlanner, PaternityLeavePlanner, AdoptionLeavePlanner]
  end

  def self.load slug, attributes = {}
    all.find {|planner| planner.slug == slug}.new attributes
  end
end
