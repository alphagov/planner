require_relative '../test_helper'

require 'gds_api/panopticon'

class PanopticonRegistrationTest < ActiveSupport::TestCase

  context "Panopticon registration" do

    should "translate to Panopticon artefacts" do
      registerer = GdsApi::Panopticon::Registerer.new(owning_app: "planner")
      plan = MaternityLeavePlanner
      artefact = registerer.record_to_artefact(RegisterablePlan.new(plan))
      [:name, :description, :slug].each do |key|
        assert artefact.has_key? key
      end
      assert_equal 'live', artefact[:state]
    end
  end
end
