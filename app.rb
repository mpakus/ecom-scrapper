# frozen_string_literal: true

require 'awesome_print'
require 'dotenv'
require 'nokogiri'
require_relative 'src/login'
require_relative 'src/page'
require_relative 'src/scraper'

Dotenv.load('environment.env')

cookie = Login.new(ENV['LOGIN_URL'], ENV['LOGIN'], ENV['PSW'], ENV['AUTH_COOKIE'], ENV['UA']).cookie
page = Page.new(cookie, ENV['UA'])

Scraper.new(page, ENV['CATALOGUE_ROOT_URL']).run
