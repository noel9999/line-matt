module Handlers
  class Bubble < Base
    def pattern
      /作弊|泡泡|陳世彥/
    end

    def outcome
      '去後面罰站!'
    end
  end
end