module Handlers
  class BossLee < Base
    WORDINGS = ['去後面罰站!', '不要怕，我後台很硬!', '朋友只是個過程，我們在一起吧(　^ω^)', '這裡的馬鈴薯燉肉很好吃!', '我要去北投泡溫泉', '好了，你可以回來了'].freeze

    def pattern
      /李老闆/
    end

    def outcome
      WORDINGS.sample
    end
  end
end