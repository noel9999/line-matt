require 'httparty'

module Handlers
  class Gif < Base
    def pattern
      /^gif\s{1}([\w\s]+)\S$/i
    end

    def outcome
      gif
    end

    private

    def gif
      word = key_words[0]
      url = "http://api.giphy.com/v1/gifs/search?q=#{word}&api_key=dc6zaTOxFJmzC&limit=15"
      res = HTTParty.get(url)
      res_json = JSON.parse(res.body)
      res_json = res_json['data'].sample
      content_url = res_json['images']['fixed_height']['mp4']
      content_url.sub!('http', 'https') unless content_url =~ /^https/
    end
  end
end