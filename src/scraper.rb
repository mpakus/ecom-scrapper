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
    puts catalogue_root
    doc = Nokogiri::HTML(catalogue_root)

    doc.css('a[gid]').each do |link|
      puts "*** #{link.text} #{link.attr('gid')}"
      ap parse_letter(link.text, link.attr('gid')) # once and 1st letter
      return
    end
  end

  private

  def parse_letter(text, gid)
    body = @page.fetch("#{@root_url}?ExpandTreeItem", :post, id: gid)
    message = ::JSON.parse(body)['message']
    doc = Nokogiri::HTML(message)
    letter = []
    doc.css('li > a').each do |link|
      puts "- #{link.text} - #{link.attr('href')}"
      letter << [ {text: text, gid: gid} ] + parse_brand(link.text, link.attr('href'))
    end
    letter
  end

  def parse_brand(text, href)
    path = [{ text: text, href: href }]# + parse_tree(text, href)
    path
  end

  def parse_tree(text, href)
    # .CGroups > ul > li > a
    path = [{ text: text, href: href }]
    # parse_tree(text, gid)
    path
  end
end
