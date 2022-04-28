#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'open-uri/cached'
require 'pry'

class MemberList
  class Member
    field :name do
      position_and_name.last
    end

    field :position do
      return raw_position unless raw_position == 'ΥΠΟΥΡΓΟΣ'

      ministry.gsub('ΥΠΟΥΡΓΕΙΟ', 'ΥΠΟΥΡΓΟΣ')
    end

    private

    def ministry
      noko.parent.xpath('preceding-sibling::p[strong][1]').text.tidy
    end

    def position_and_name
      noko.text.tidy.split(':').map(&:tidy)
    end

    def raw_position
      position_and_name.first
    end
  end

  class Members
    def members
      [node_with('ΠΡΩΘΥΠΟΥΡΓΟΣ'), node_with('ΑΝΤΙΠΡΟΕΔΡΟΣ ΤΗΣ ΚΥΒΕΡΝΗΣΗΣ'), super].flatten
    end

    def member_container
      noko.css('.td-main-content').xpath('.//li[contains(.,":")]')
    end

    def node_with(position)
      {
        name: noko.xpath("//strong[contains(., '#{position}')]//following-sibling::text()").text.tidy,
        position: position
      }
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
