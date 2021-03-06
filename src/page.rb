# frozen_string_literal: true

require 'net/http'

# Fetch pages
class Page
  def initialize(cookie, ua, logger = nil)
    @cookie = cookie
    @ua = ua
    @logger = logger
  end

  def fetch(url, method = :get, params = {})
    uri = URI(url)
    http = Net::HTTP.new(uri.host, 80)
    http.set_debug_output(@logger) if @logger
    request = method == :get ? get(uri) : post(uri, params)
    request['Cookie'] = @cookie.to_s
    request['User-Agent'] = @ua
    r = http.request(request)
    r.body
  end

  private

  def get(uri)
    Net::HTTP::Get.new(uri.request_uri)
  end

  def post(uri, params)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(params)
    request
  end
end
