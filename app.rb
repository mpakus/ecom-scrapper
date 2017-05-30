# frozen_string_literal: true

require 'awesome_print'
require 'dotenv'
require 'nokogiri'
require_relative 'src/login'
require_relative 'src/page'
require_relative 'src/scraper'

Dotenv.load('environment.env')

logger = ENV['DEBUG'] ? Logger.new('logs/development.log') : nil
cookie = Login.new(ENV['LOGIN_URL'], ENV['LOGIN'], ENV['PSW'], ENV['AUTH_COOKIE'], ENV['UA'], logger).cookie
page = Page.new(cookie, ENV['UA'], logger)

Scraper.new(page, ENV['CATALOGUE_ROOT_URL']).run
