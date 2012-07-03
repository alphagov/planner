class RegisterablePlan
  # A decorator for plan classes, allowing them to be passed to the Panopticon
  # registerer.

  extend Forwardable

  def_delegators :@plan, :slug, :title, :need_id, :description

  def initialize(plan)
    @plan = plan
  end

  def live
    true
  end

  def indexable_content
    ""
  end

end