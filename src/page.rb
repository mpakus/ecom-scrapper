# frozen_string_literal: true
require 'net/http'

class Page
  def initialize(cookie, ua)
    @cookie = cookie
    @ua = ua
  end

  def fetch(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, 80)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Cookie'] = @cookie.to_s
    request['User-Agent'] = @ua
    r = http.request(request)
    r.body
  end
end
