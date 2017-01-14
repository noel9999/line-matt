require 'httparty'

module Handlers
  class Wiki < Base
    def pattern
      /^wiki\s{1}(.+)\z/i
    end

    def outcome
      wiki
    end

    private

    def wiki
      query = key_words[0]
      query = CGI.escape(query)
      query_string = "?action=opensearch&search=#{query}&limit=1&namespace=0&format=json"
      res = HTTParty.get(WIKIPEDIA_URL + query_string)
      res = JSON.parse(res.body)
      "#{res[2][0][0..40]}... \n #{res[3][0]}"
    end
  end
end