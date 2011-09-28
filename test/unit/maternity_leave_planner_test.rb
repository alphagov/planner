# coding:utf-8

require 'test_helper'

class MaternityLeavePlannerTest < ActiveSupport::TestCase
  # References: 
  # http://www.dwp.gov.uk/publications/specialist-guides/technical-guidance/ni17a-a-guide-to-maternity/statutory-maternity-pay-smp/
  
  
  context "Maternity leave planner" do
    should 'give nil key_dates if due_date not specified' do
      assert_nil MaternityLeavePlanner.new().key_dates
    end
    
    should 'calculate the expected week of childbirth based on a week from Sunday to Saturday' do
      m = MaternityLeavePlanner.new(due_date: '13 October 2011')
      assert_equal Date.parse('9 October 2011')..Date.parse('15 October 2011'), m.expected_week_of_childbirth
      m = MaternityLeavePlanner.new(due_date: '9 October 2011')
      assert_equal Date.parse('9 October 2011')..Date.parse('15 October 2011'), m.expected_week_of_childbirth
      m = MaternityLeavePlanner.new(due_date: '8 October 2011')
      assert_equal Date.parse('2 October 2011')..Date.parse('8 October 2011'), m.expected_week_of_childbirth
    end

    should 'accept date as separate day, month, year parameters' do
      m = MaternityLeavePlanner.new(due_day: '13', due_month: '10', due_year: '2011')
      assert_equal Date.parse('9 October 2011')..Date.parse('15 October 2011'), m.expected_week_of_childbirth
    end

    should 'qualifying week is 15 weeks before expected week of childbirth' do
      m = MaternityLeavePlanner.new(due_date: '13 October 2011')
      assert_equal Date.parse('26 June 2011')..Date.parse('2 July 2011'), m.qualifying_week
    end

    should 'give its range' do
      m = MaternityLeavePlanner.new(due_date: '17-2-2012')
      assert_equal Date.parse('1/11/2011')..Date.parse('28/2/2013'), m.range
    end
    
    context "key dates" do
      should 'list key dates' do
        expected = [
          ["Date by which you must have notified your employer", Date.parse('05 November, 2011')],
          ["Earliest you may start maternity leave", Date.parse('27 November, 2011')],
          ["Period of Ordinary Maternity Leave", Date.parse('Monday, November 28, 2011')..Date.parse('Sunday, May 27, 2012')],
          ["Period of Additional Maternity Leave", Date.parse('Monday, May 28, 2012')..Date.parse('Sunday, November 25, 2012')],
          ["Expected week of childbirth", Date.parse('12 February, 2012')..Date.parse('18 February, 2012')],
          ["Baby's due date", Date.parse('17 February 2012')]
        ]
        m = MaternityLeavePlanner.new(due_date: '17-2-2012', start: 'Monday, November 28, 2011')
        assert_equal expected, m.key_dates
      end
      
      should "raise if requested maternity leave out of range" do
        assert_raises do
          MaternityLeavePlanner.new(due_date: '17-2-2012', start: '26-11-2011')
        end
        assert_raises do
          MaternityLeavePlanner.new(due_date: '17-2-2012', start: '17-2-2012')
        end
      end
      
    end
    
  end
end