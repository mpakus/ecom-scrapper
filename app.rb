# frozen_string_literal: true

require 'awesome_print'
require 'dotenv'
require 'nokogiri'
require_relative 'src/login'
require_relative 'src/page'

Dotenv.load('environment.env')

cookie = Login.new(ENV['LOGIN_URL'], ENV['LOGIN'], ENV['PSW'], ENV['AUTH_COOKIE'], ENV['UA']).cookie
page = Page.new(cookie, ENV['UA'])

catalogue_root = page.fetch(ENV['CATALOGUE_ROOT_URL'])

doc = Nokogiri::HTML(catalogue_root)

doc.css('a[gid]').each do |link|
  ap link
end
