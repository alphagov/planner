require_relative '../test_helper'

class PlansControllerTest < ActionController::TestCase
  include AssertNotPresent
  include AssertPresent
  
  context 'GET /plans/maternity' do
    should "show welcome message when no input given" do
      get :show, id: 'maternity'
      assert_select '.date-planner h2', /How this works/
      assert_not_present '.error-notification', /a problem/
    end
    
    should "show calendar when due date given" do
      get :show, id: 'maternity', due_date: {
        'year' => '2011', 
        'month' => '05',
        'day' => '12'
      }
      assert_present 'h1', /Calendar and key dates/
      assert_select '#calendar table', /January 2011/
      assert_select '#calendar table', /May 2011/
      assert_select '#calendar table', /April 2012/
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
            ["Date by which you must have notified your employer","2010-10-02"],
            ["Earliest you may start maternity leave","2010-10-24"],
            ["Period of Ordinary Maternity Leave",{"from" => "2010-12-29","to" => "2011-06-28"}],
            ["Period of Additional Maternity Leave",{"from" => "2011-06-29","to" => "2011-12-27"}],
            ["Expected week of childbirth",{"from" => "2011-01-09","to" => "2011-01-15"}],
            ["Baby's due date","2011-01-12"]
          ]
        assert_equal expected_content, JSON.parse(@response.body)
      end
    end
    
    context "ical" do
      should_eventually "render key dates as ical" do
      end
    end
  end
end
