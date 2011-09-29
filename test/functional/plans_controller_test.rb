require_relative '../test_helper'

class PlansControllerTest < ActionController::TestCase
  include AssertNotPresent
  
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
      assert_select 'h1', /Key Dates/
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
    
  end
end
