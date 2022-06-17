#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

# Skip junior ministers for now
# TODO: make sure all are included
class Comparison < EveryPoliticianScraper::DecoratedComparison
  def wikidata
    @wikidata ||= super.delete_if { |row| row[:position].start_with? 'Υπουργός Επικρατείας' }
  end

  def external
    @external ||= super.delete_if { |row| row[:position] !~ /^(ΠΡΩΘΥΠΟΥΡΓΟΣ|ΑΝΤΙΠΡΟΕΔΡΟΣ|ΥΠΟΥΡΓΟΣ)/ }
  end
end

diff = Comparison.new('wikidata.csv', 'scraped.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
