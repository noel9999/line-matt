module Handlers
  class Expletive < Base
    WORDINGS = %W(%s %s屁).freeze
    def pattern
      /(唉|欸)/
    end

    def outcome
      WORDINGS.sample % key_words[0]
    end
  end
end