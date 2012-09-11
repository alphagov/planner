class RegisterablePlan
  # A decorator for plan classes, allowing them to be passed to the Panopticon
  # registerer.

  extend Forwardable

  def_delegators :@plan, :slug, :title, :need_id, :description

  def initialize(plan)
    @plan = plan
  end

  def state
    'live'
  end

  def indexable_content
    ""
  end

  def paths
    path = "#{slug}"
    [path, "#{path}.ics", "#{path}.json", "#{path}.xml"]
  end

  def prefixes
    []
  end
end
