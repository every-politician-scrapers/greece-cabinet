#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'open-uri/cached'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      position_and_name.last
    end

    field :position do
      return raw_position unless raw_position == 'ΥΠΟΥΡΓΟΣ'

      ministry.gsub('ΥΠΟΥΡΓΕΙΟ', 'ΥΠΟΥΡΓΟΣ')
    end

    private

    def ministry
      noko.parent.xpath('preceding-sibling::ol[1]').text.tidy
    end

    def position_and_name
      noko.text.tidy.split(':').map(&:tidy)
    end

    def raw_position
      position_and_name.first
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.map { |member| fragment(member => Member).to_h }
    end

    private

    def member_container
      noko.css('.td-main-content').xpath('.//li[contains(.,":")]')
    end
  end
end

url = 'https://government.gov.gr/kivernisi/'
puts EveryPoliticianScraper::ScraperData.new(url).csv
