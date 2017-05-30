# frozen_string_literal: true

require 'json'

# Main Application
class Scraper
  def initialize(page, root_url)
    @page = page
    @root_url = root_url
  end

  def run
    catalogue_root = @page.fetch(@root_url)
    doc = Nokogiri::HTML(catalogue_root)

    doc.css('a[gid]').each do |link|
      ap parse_letter(link.text, link.attr('gid'))
    end
  end

  private

  def parse_tree(text, href)
    # .CGroups > ul > li > a
    path = [{ text: text, href: href }]
    # parse_tree(text, gid)
    path
  end

  def parse_letter(text, gid)
    # ENV['CATALOGUE_ROOT_URL']
    sleep(2)
    body = @page.fetch("#{@root_url}?ExpandTreeItem", :post, gid: gid)
    message = ::JSON.parse(body)['message']
    doc = Nokogiri::HTML(message)
    # .CGroups > ul > li > a
    letter = []
    doc.css('.CGroups > ul > li > a').each do |link|
      letter << [ {text: text, gid: gid} ].merge(parse_tree(link.text, link.attr('href')))
    end
    letter
  end
end
