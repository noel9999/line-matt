module Handlers
  class CookingMasterBoy < Base
    WORDINGS = [
      '你怎麼帥成這樣',
      '呵呵呵呵呵哈哈哈',
      '母親的味道，我的身體最知道了！',
      '就是媽媽的味道',
      '我是個廚師',
      '向恩，多虧你～＼(^o^)／',
      '就讓我送你到羅歇那去吧',
      '你們ㄘㄘ看',
      '很好ㄘヾ(*´∀｀*)ﾉ',
      '我的兒子會掉到山谷底下',
      '你們幾個給我聽好了',
      '應該還有用那個吧',
      '是那個吧',
      '都是你害我全身濕成這個樣子',
      '沒有完成的料理，根本沒有必要試吃!'
    ].freeze

    def pattern
      /李嚴|帥哥|中華|[小洨笅]當家|[餓吃食廚]/
    end

    def outcome
      WORDINGS.sample
    end
  end
end