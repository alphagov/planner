# coding:utf-8

require_relative '../test_helper'

class PaternityLeavePlannerTest < ActiveSupport::TestCase

  context "Paternity Leave planner" do
    should 'give nil key_dates if due_date not specified' do
      assert_nil PaternityLeavePlanner.new().key_dates
    end

    should "have slug, title, description and need_id" do
      assert_equal "paternity", PaternityLeavePlanner.slug
      assert_equal "Planning your Paternity Leave", PaternityLeavePlanner.title
      assert_equal 1947, PaternityLeavePlanner.need_id
      assert_match /paternity leave/i, PaternityLeavePlanner.description
    end

    should "report validation error if due date is not valid" do
      m = PaternityLeavePlanner.new(due_date: '31 June 2011')
      assert ! m.valid?
      assert m.errors[:due_date].any?
    end

    should 'accept due date as separate day, month, year parameters' do
      m = PaternityLeavePlanner.new(due_date: {'day' => '13', 'month' => '10', 'year' => '2011'})
      assert_equal Date.parse('9 October 2011')..Date.parse('15 October 2011'), m.expected_week_of_childbirth
    end

    should 'qualifying week is 15 weeks before expected week of childbirth' do
      m = PaternityLeavePlanner.new(due_date: '13 October 2011')
      assert_equal Date.parse('26 June 2011')..Date.parse('2 July 2011'), m.qualifying_week
    end

    context "key dates" do
      should 'list key dates' do
        expected = [
          ["You must tell your employer by:", Date.parse('24 September, 2011')],
          ["Your chosen Ordinary Paternity Leave dates:", Date.parse('Sunday, 15 January, 2012')..Date.parse('Saturday, 28 January, 2012')],
          ["You could take Ordinary Paternity Leave during this period:", Date.parse('Sunday, 1 January, 2012')..Date.parse('Saturday, February 25, 2012')],
          ["You could take Additional Paternity Leave during this period:", Date.parse('Sunday, May 13, 2012')..Date.parse('Saturday, November 10, 2012')],
          ["Your baby is due on:", Date.parse('1 January 2012')]
        ]
        m = PaternityLeavePlanner.new(due_date: '1-1-2012', start: '15 January, 2012')
        assert_equal expected, m.key_dates
      end

      should "report validation error if requested Paternity Leave out of range" do
        assert ! PaternityLeavePlanner.new(due_date: '1-1-2012', start: '31-12-2011').valid?
        assert ! PaternityLeavePlanner.new(due_date: '1-1-2012', start: '26-2-2012').valid?
      end

      should "accept Paternity Leave as separate day, month, year parameters" do
        m = PaternityLeavePlanner.new(due_date: '10-2-2012', start: {'year' => '2012', 'month' => '2', 'day' => '24'})
        assert_equal Date.parse('2012-2-24')..Date.parse('2012-3-8'), Hash[m.key_dates]["Your chosen Ordinary Paternity Leave dates:"]
      end

      should "accept Paternity Leave as a number of days after due date" do
        m_actual = PaternityLeavePlanner.new(due_date: '10-2-2012', start: {'days_after_due' => '6'})
        m_expected = PaternityLeavePlanner.new(due_date: '10-2-2012', start: '16-2-2012')
        assert_equal Hash[m_expected.key_dates], Hash[m_actual.key_dates]
      end
    end

  end
end
