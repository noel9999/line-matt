module Handlers
  class BadLanguage < Base
    def pattern
      [/(他|她)媽的/, /^[幹操]\s?.+/, /fuck/i, /shit/i]
    end

    def outcome
      ['對不起，下次不敢了', '阿扁錯了嗎?', '有話好說!', '猴，沒收功就說髒話', '幹，單挑啊( #｀Д´)', '塊陶啊～'].sample
    end
  end
end