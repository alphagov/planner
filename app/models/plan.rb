class Plan
  PLANS = {
    maternity: MaternityLeavePlanner,
    paternity: PaternityLeavePlanner
  }.freeze

  def self.all_slugs
    PLANS.keys.sort_by { |s| s.to_s }
  end

  def self.load slug, attributes = {}
    PLANS[slug.to_sym].new attributes
  end
end
