# frozen_string_literal: true

require 'json'
require 'uri'

# Main Application
class Scraper
  def initialize(page, root_url)
    @page = page
    @root_url = root_url
    uri = URI.parse(root_url)
    @root_base = "#{uri.scheme}://#{uri.host}"
  end

  def run
    catalogue_root = @page.fetch(@root_url)
    doc = Nokogiri::HTML(catalogue_root)

    doc.css('a[gid]').each do |link|
      puts "run: #{link.text} #{link.attr('gid')}"
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
      puts "brand: #{link.text} - #{link.attr('href')}"
      return letter << parse_tree(link.text, link.attr('href'), [{ text: link.text, link: link.attr('href') }])
    end
    letter
  end

  # def parse_brand(text, href)
  #   path = [{ text: text, href: href }] + parse_tree(text, href)
  #   path
  # end

  def parse_tree(text, href, path)
    paths = []
    puts "fetch: #{@root_base}/#{href}"
    body = @page.fetch("#{@root_base}/#{href}")
    doc = Nokogiri::HTML(body)
    doc.css('.CGroups > ul > li > a').each_with_index do |link, i|
      puts "item: #{link.text} - #{link.attr('href')}"
      return paths[i] = parse_tree(link.text, link.attr('href'), path + [{text: link.text, link: link.attr('href')}])
    end
    path
  end
end
