require 'httparty'

module Handlers
  class News < Base
    def pattern
      /^頭條新聞\z/
    end

    def outcome
      news
    end

    private

    def news
      res = HTTParty.get('http://oldpaper.g0v.ronny.tw/index/json')
      res_json = JSON.parse(res.body)
      "#{res_json['data'].first['title']} \n" + "#{res_json['data'].first['headlines'].map {|v| v.join(': ') }.join("\n")}" + "\n#{res_json['data'].first['link']}"
    end
  end
end