require_relative '../test_helper'
require 'gds_api/test_helpers/panopticon'

class PlansControllerTest < ActionController::TestCase
  include AssertNotPresent
  include AssertPresent
  include GdsApi::TestHelpers::Panopticon

  context "GET 'show'" do
    setup do
      stub_panopticon_default_artefact
    end

    should "show welcome message when no input given" do
      get :show, id: 'maternity'
      assert_not_present 'h1', /Calendar and key dates/
      assert_not_present '.error-notification', /a problem/
    end

    should "show calendar when due date given" do
      get :show, id: 'maternity', due_date: {
        'year' => '2011',
        'month' => '05',
        'day' => '12'
      }
      assert_select '#calendar table', /January 2011/
      assert_select '#calendar table', /May 2011/
      assert_select '#calendar table', /April 2012/
    end

    should "send analytics headers" do
      get :show, id: 'maternity'
      assert_equal "family",  @response.headers["X-Slimmer-Section"]
      assert_equal "855",     @response.headers["X-Slimmer-Need-ID"].to_s
      assert_equal "planner", @response.headers["X-Slimmer-Format"]
      assert_equal "citizen", @response.headers["X-Slimmer-Proposition"]
    end

    should "send artefact to slimmer" do
      mock_artefact = {'slug' => 'maternity', "name" => "Planning your Maternity Leave"}
      GdsApi::Panopticon.any_instance.expects(:artefact_for_slug).with('maternity').returns(mock_artefact)

      @controller.expects(:set_slimmer_artefact).with(mock_artefact)

      get :show, id: 'maternity'
    end

    context "invalid date" do
      setup do
        get :show, id: 'maternity', due_date: {
          'year' => '2011',
          'month' => '06',
          'day' => '31'
        }
      end

      should "show an error message" do
        assert_select '.intro .error-area .error-message', /Sorry, that's not a proper date/
      end

      should "hide the calendar" do
        assert_not_present 'h1', /Key Dates/
      end
    end

    context "JSON" do
      should "render key dates as json" do
        get :show, id: 'maternity', format: :json, due_date: {
          'year' => '2011',
          'month' => '01',
          'day' => '12'
        }
        expected_content =
          [
            ["You must tell your employer by:","2010-10-02"],
            ["The earliest you can start your Maternity Leave is:","2010-10-24"],
            ["Ordinary Maternity Leave (first 26 weeks):",{"from" => "2010-12-29","to" => "2011-06-28"}],
            ["Additional Maternity Leave (up to 26 weeks more):",{"from" => "2011-06-29","to" => "2011-12-27"}],
            ["Your baby is due on:","2011-01-12"]
          ]
        assert_equal expected_content, JSON.parse(@response.body)
      end
    end

    context "ical" do
      should "render key dates as ical" do
        get :show, id: 'maternity', format: :ics, due_date: {
          'year' => '2011',
          'month' => '01',
          'day' => '12'
        }
        parsed_calendars = RiCal.parse_string(@response.body)
        assert_equal 5, parsed_calendars.first.events.size, "Should have 5 events in the ical file"
        summaries = parsed_calendars.first.events.map(&:summary)
        assert_match 'Maternity Leave planner: You must tell your employer by:', summaries.first
      end
    end

    should "not include bogus parameters in alternative formats" do
      get :show, id: 'maternity', thing: "BOGUS", due_date: {
        'year' => '2011',
        'month' => '01',
        'day' => '12'
      }
      assert_no_match %r{BOGUS}, response.body
    end
  end
end
