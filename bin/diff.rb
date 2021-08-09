#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

# Skip missing junior ministers for now
# TODO: make sure all are included
class Comparison < EveryPoliticianScraper::Comparison
  def external
    @external ||= super.delete_if { |row| !row[:position].start_with? 'ΥΠΟΥΡΓΟΣ' }
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
