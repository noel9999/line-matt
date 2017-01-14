module Handlers
  class Blame < Base
    def pattern
      /你的錯|怪我囉|都你|說清楚|解釋/
    end

    def outcome
      ['大人，冤枉啊!', '怪我囉(╯⊙ ⊱⊙╰　)', '出來面對!'].sample
    end
  end
end