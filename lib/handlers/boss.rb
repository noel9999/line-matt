module Handlers
  class Boss < Base
    WORDINGS = %w(好秀嗎？ wu你妹 億全 愛溝共 小組抱抱 西咧靠腰 衝啥 亞榆勒 大家好!我叫陳囧).freeze
    def pattern
      /武德|wuder|億全|波斯|boss|好笑嗎|好秀嗎|eggsy/i
    end

    def outcome
      WORDINGS.sample
    end
  end
end
