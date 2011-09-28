# coding:utf-8

require 'test_helper'

class CalendarRendererTest < ActiveSupport::TestCase
  context "Calendar renderer" do
    should "render a single table if the requested range is one month" do
      range = Date.parse('2012-01-01')..Date.parse('2012-01-31')
      html = CalendarRenderer.new(range).render
      assert_equal 1, html.scan(/<table[^>]*?>/).size, "Expect exactly one table"
    end

    should "apply single date decorations to table cells" do
      range = Date.parse('2012-01-01')..Date.parse('2012-01-31')
      decorations = [
        ['first', Date.parse('2012-01-01')]
      ]
      html = CalendarRenderer.new(range, decorations: decorations).render
      assert_match %r{<table[^>]*?>.*<td class='key-date-0'>1</td>}, html
    end

    should "apply date range decorations to table cells" do
      range = Date.parse('2012-01-01')..Date.parse('2012-01-31')
      decorations = [
        ['first', Date.parse('2012-01-01')..Date.parse('2012-01-02')]
      ]
      html = CalendarRenderer.new(range, decorations: decorations).render
      assert_match %r{<table[^>]*?>.*<td class='key-date-0'>1</td><td class='key-date-0'>2</td>}, html
    end

    should "apply multiple decorations to table cells" do
      range = Date.parse('2012-01-01')..Date.parse('2012-01-31')
      decorations = [
        ['first', Date.parse('2012-01-01')],
        ['second', Date.parse('2012-01-01')]
      ]
      html = CalendarRenderer.new(range, decorations: decorations).render
      assert_match %r{<table[^>]*?>.*<td class='key-date-0 key-date-1'>1</td>}, html
    end
  end
end