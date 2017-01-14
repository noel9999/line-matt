module Handlers
  class Matt < Base
    WORDINGS = [
      'Exactly..Exactly',
      '那我也不想給你看' ,
      'Hi,I\'m Matt.',
      '你們喜歡在這工作嗎?',
      '你們有看過凱羅忍的光劍嗎?',
      '你們覺得凱羅忍怎麼樣?',
      '你們相信他能像他所說的完成達斯.維達的遺願嗎?',
      '你這樣我壓力很大!',
      '嘿, 你踢我的扳手',
      '才不是, 它超屌的',
      'After Rain, Comes the Rainbow',
      '我看我能不能找到, 讓你們見識一下',
      '你們看！我找到凱羅忍的光劍了',
      '他說凱羅忍有八塊肌, 說他身材超健美',
      '我能知道你在想什麼',
      '你的想法..很愚蠢!!',
      '噢不, 他被食物噎到了!',
      '我想吃瑪芬蛋糕!',
      '別叫了，機器人也是會累的..',
      '連我爸爸都沒打過我',
      '你已經死了',
      '混蛋',
      'ZZZz..zzZ..zzz..Zz',
      'ZZZ',
      'zzzZzz.zz.ZZ',
      '你這樣不累嗎?'
    ].freeze

    def pattern
      /matt|radar|雷達/i
    end

    def outcome
      WORDINGS.sample
    end
  end
end