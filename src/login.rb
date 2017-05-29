# frozen_string_literal: true

require 'mechanize'

# Login user and return auth cookie
class Login
  def initialize(url, login, password, cookie, ua)
    @url = url
    @login = login
    @password = password
    @cookie = cookie
    @ua = ua
  end

  def cookie
    @authorized_cookie ||= fetch_cookie
  end

  private

  def fetch_cookie
    scraper = Mechanize.new do |agent|
      agent.open_timeout = 60
      agent.read_timeout = 60
      agent.follow_meta_refresh = true
      agent.log = Logger.new('logs/login.log')
      agent.user_agent = @ua
    end
    scraper.history_added = proc { sleep 0.5 }

    scraper.get(@url) do |page|
      login_form = page.form_with(id: 'login-form') do |form|
        form['_username'] = @login
        form['_password'] = @password
        form.checkbox_with(name: '_remember_me').check
      end
      login_form.submit

      return scraper.cookie_jar.jar[URI(@url).host]['/'][@cookie]
    end
  end
end
