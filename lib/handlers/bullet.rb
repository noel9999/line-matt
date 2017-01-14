module Handler
  class Bullet < Base
    WORDINGS = %w(
                  翻譯翻譯 黃四郎臉上有四嗎？
                  你給我他媽的翻譯一下他媽的到底什麼是他媽的驚喜！
                  別急，讓子彈飛一會兒。
                  你這是要殺我，還是要睡我呢？
                  屁股在樹上呢！
                  騙了就騙了吧！
                  兄弟們，回鵝城！
                  我聽出來了，你們都個個身懷絕技。
                  你覺得是你對我重要，還是錢對我重要？
                  你再想想？
                  其實你和錢對我都不重要。沒有你，對我很重要！
                  槍在手！跟我走！
                  殺四郎！搶碉樓!
                  兄弟!你太客氣了!
                  三舅，這話能跟他說嗎？
                  他奶奶的這樣八歲!
                  放他媽的屁怎麼沒吹啊！？
                  我要當縣長
                  步子邁大了，容易扯著蛋！
                  明白啦!誰贏他們就幫誰
                 ).freeze

    def pattern
      /大哥|翻譯|子彈|兄弟|縣長|市長/
    end

    def outcome
      WORDINGS.sample
    end
  end
end