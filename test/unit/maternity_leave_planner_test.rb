# coding:utf-8

require_relative '../test_helper'

class MaternityLeavePlannerTest < ActiveSupport::TestCase
  # References: 
  # http://www.dwp.gov.uk/publications/specialist-guides/technical-guidance/ni17a-a-guide-to-maternity/statutory-maternity-pay-smp/

  context "Maternity Leave planner" do
    should 'give nil key_dates if due_date not specified' do
      assert_nil MaternityLeavePlanner.new().key_dates
    end

    should "have slug, title and need_id" do
      assert_equal "maternity", MaternityLeavePlanner.slug
      assert_equal "Planning your Maternity Leave", MaternityLeavePlanner.title
      assert_equal 855, MaternityLeavePlanner.need_id
    end

    should "report validation error if due date is not valid" do
      m = MaternityLeavePlanner.new(due_date: '31 June 2011')
      assert ! m.valid?
      assert m.errors[:due_date].any?
    end

    should 'accept due date as separate day, month, year parameters' do
      m = MaternityLeavePlanner.new(due_date: {'day' => '13', 'month' => '10', 'year' => '2011'})
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
          ["You must tell your employer by:", Date.parse('05 November, 2011')],
          ["The earliest you can start your Maternity Leave is:", Date.parse('27 November, 2011')],
          ["Ordinary Maternity Leave (first 26 weeks):", Date.parse('Monday, November 28, 2011')..Date.parse('Sunday, May 27, 2012')],
          ["Additional Maternity Leave (up to 26 weeks more):", Date.parse('Monday, May 28, 2012')..Date.parse('Sunday, November 25, 2012')],
          ["Your baby is due on:", Date.parse('17 February 2012')]
        ]
        m = MaternityLeavePlanner.new(due_date: '17-2-2012', start: 'Monday, November 28, 2011')
        assert_equal expected, m.key_dates
      end

      should "report validation error if requested Maternity Leave out of range" do
        assert ! MaternityLeavePlanner.new(due_date: '17-2-2012', start: '26-11-2011').valid?
        assert ! MaternityLeavePlanner.new(due_date: '17-2-2012', start: '17-2-2012').valid?
      end

      should "accept Maternity Leave as separate day, month, year parameters" do
        m = MaternityLeavePlanner.new(due_date: '17-2-2012', start: {'year' => '2011', 'month' => '11', 'day' => '29'})
        assert_equal Date.parse('2011-11-29')..Date.parse('2012-5-28'), Hash[m.key_dates]["Ordinary Maternity Leave (first 26 weeks):"]
      end

      should "accept Maternity Leave as a number of days before due date" do
        m_actual = MaternityLeavePlanner.new(due_date: '17-2-2012', start: {'days_before_due' => '7'})
        m_expected = MaternityLeavePlanner.new(due_date: '17-2-2012', start: '10-2-2012')
        assert_equal Hash[m_expected.key_dates], Hash[m_actual.key_dates]
      end
    end

  end
end
