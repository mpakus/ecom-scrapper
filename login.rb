# frozen_string_literal: true

require 'awesome_print'
require 'dotenv'
require 'mechanize'

Dotenv.load('environment.env')

scraper = Mechanize.new do |agent|
  agent.open_timeout = 5
  agent.read_timeout = 5
  agent.follow_meta_refresh = true
  agent.log = Logger.new('logs/login.log')
end
scraper.history_added = proc { sleep 0.5 }
ADDRESS = 'http://dya' + 'dko' + '.ru/login_user' # kick search

scraper.get(ADDRESS) do |page|
  login_form = page.form_with(id: 'login-form') do |form|
    form['_username'] = ENV['LOGIN']
    form['_password'] = ENV['PSW']
  end
  result = login_form.submit

  ap result
end
