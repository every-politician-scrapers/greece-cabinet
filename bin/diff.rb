#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

# 'ignore_case' doesn't seem to be having any effect, so coerce everything to caps
class Comparison < EveryPoliticianScraper::Comparison
  def wikidata_csv_options
    { converters: [->(v) { v.upcase }] }
  end

  def external_csv_options
    { converters: [->(v) { v.upcase }] }
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
