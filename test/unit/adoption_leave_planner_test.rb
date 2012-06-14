# coding:utf-8

require_relative '../test_helper'

class AdoptionLeavePlannerTest < ActiveSupport::TestCase

  context "Adoption Leave planner" do
    should 'give nil key_dates if due_date not specified' do
      assert_nil AdoptionLeavePlanner.new().key_dates
    end

    should "have slug, title and need_id" do
      assert_equal "adoption", AdoptionLeavePlanner.slug
      assert_equal "Planning your Adoption Leave", AdoptionLeavePlanner.title
      assert_equal 1948, AdoptionLeavePlanner.need_id
    end

    should "report validation error if match date is not valid" do
      m = AdoptionLeavePlanner.new(match_date: '31 June 2011')
      assert ! m.valid?
      assert m.errors[:match_date].any?
    end

    should "report validation error if arrival date is not valid" do
      m = AdoptionLeavePlanner.new(arrival_date: '31 June 2011')
      assert ! m.valid?
      assert m.errors[:arrival_date].any?
    end

    should "report validation error if arrival date is before match date" do
      m = AdoptionLeavePlanner.new(arrival_date: '28 July 2012', match_date: '1 August 2012', start: '25 July 2012')
      assert ! m.valid?
      assert m.errors[:arrival_date].any?
    end

    should 'qualifying week is 1 week before expected week of arrival' do
      m = AdoptionLeavePlanner.new(match_date: '13 October 2011')
      assert_equal Date.parse('2 October 2011')..Date.parse('8 October 2011'), m.qualifying_week
    end

    context "key dates" do
      should 'list key dates' do
        expected = [
          ["You must tell your employer by:", Date.parse('11 February, 2012')],
          ["Earliest date you can start your Adoption Leave:", Date.parse('20 February, 2012')],
          ["Ordinary Adoption Leave:", Date.parse('3 March, 2012')..Date.parse('1 September, 2012')],
          ["Additional Adoption Leave:", Date.parse("1 September 2012")..Date.parse("2 March 2013")]
        ]
        m = AdoptionLeavePlanner.new(match_date: '17-2-2012', arrival_date: '5-3-2012', start: '3-3-2012')
        assert_equal expected, m.key_dates
      end
    end

  end
end
