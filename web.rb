require 'sinatra'
require 'line/bot'
require 'httparty'

WIKIPEDIA_URL = 'https://zh.wikipedia.org/w/api.php'.freeze

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = case event.message['text']
                  when /^wiki\s{1}(.+)$/i
                    key_word = event.message['text'].match(/^wiki\s{1}(.+)\z/i)[1]
                    {
                      text: wiki(key_word),
                      type: 'text'
                    }
                  when /[馬螞皇蝗騜]/i
                    {
                      text: MA_SAYS.sample,
                      type: 'text'
                    }
                  when /所以我說那個.+呢/i, /醬汁呢/i
                    {
                      text: JIANGZHINE.sample,
                      type: 'text'
                    }
                  when /李老闆|作弊|泡泡|陳世彥/
                    {
                      text: '去後面罰站!',
                      type: 'text'
                    }
                  when /武德|Wuder|億全|波斯|boss|好笑嗎|好秀嗎/i
                    {
                      text: BOSS_SAY.sample,
                      type: 'text'
                    }
                  when /大哥|翻譯｜子彈/
                    {
                      text: BULLETS.sample,
                      type: 'text'
                    }
                  when /你的錯|怪我囉|都你害的/
                    {
                      text: '大人，冤枉啊!',
                      type: 'text'
                    }
                  when /matt|radar/i
                    {
                      text: MATT_SAY.sample,
                      type: 'text'
                    }
                  when /欸/
                    {
                      text: %w(欸 欸屁).sample,
                      type: 'text'
                    }
                  when /^頭條新聞\z/
                    {
                      text: news,
                      type: 'text'
                    }
                  when /^gif\s{1}([\w\s]+)\S$/i
                    key_word = event.message['text'].match(/^gif\s{1}([\w\s]+)\S$/i)[1]
                    preview_url = gif(key_word)
                    {
                      text: preview_url,
                      type: 'text'
                    }
                  when /(他|她)媽的/, /^幹\s?.+/
                    {
                      text: ['對不起,下次不敢了', '阿扁錯了嗎?', '有話好說!', '猴，沒收功就說髒話']
                      type: 'text'
                    }
                  when /李嚴/, /(小|洨|笅)當家/
                    {
                      text: ['你怎麼帥成這樣', '呵呵呵呵呵哈哈哈', '母親的味道，我的身體最知道了！', '就是媽媽的味道', '我是個廚師', '向恩，多虧你～＼(^o^)／', '就讓我送你到羅歇那去吧', '你們ㄘㄘ看', '很好ㄘ', '我的兒子會掉到山谷底下', '你們幾個給我聽好了', '應該還有用那個吧', '是那個吧', '都是你害我全身濕成這個樣子', '沒有完成的料理，根本沒有必要試吃!'].sample,
                      tpye: 'text'
                    }
                  end
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    end
  }

  'OK'
end

get '/hello' do
  # name = params[:name]
  # "Hello World #{name}!"
  params.inspect
end

MA_SAYS = %w(
        嚴查重罰、立即下架、增加人力、妥編預算、鼓勵檢舉、動員志工、長期監測。
        檢討檢討再檢討，改進改進再改進，努力努力再努力。
        爾俸爾祿，民脂民膏，公僕加薪，加倍用心。
        安全容許，牛豬分離，強制標示，排除內臟。
        跨區結盟、日新又新、截長補短、圓圓滿滿。
        主動發掘、明快處置、配合偵辦、對外說明。
        勿驕勿餒、團結一心、堅持改革、深化民主。
        夏日炎炎，溺水連連，下水之前，注意安全。
        事到如今，恐需速定，勿再猶豫，嫁給我吧。
        以民為先、精誠合作、和衷共濟、再創雙贏。
        坦然面對、記取教訓、堅持改革、大步向前。
        正視現實，累積互信，求同存異，續創雙贏。
        廉政、明快、主動、親切、務實、建設、創新、多元。
        同舟共濟、相互扶持、深化合作、開創未來。
        積極人生、謙虛滿分、充實自我、關懷他人。
        誠以待人、敬以治事、勤能補拙、儉以助廉。
        務實面對、冷靜思考、徹底檢討、找出解方。
        大敵當前、嚴陣以待、料敵從寬、禦敵從嚴。
        正視現實，開創未來；擱置爭議，追求雙贏。
        青山綠水，長橋臥波，龍舟競渡，共慶端午。
        主權在我、擱置爭議、和平互惠、共同開發。
        排除障礙，調整心態，八年入T，能快就快。
        ECFA是維他命，但不是萬靈丹。
        台灣民主史上最恥辱的一天。
        虛心傾聽、徹底檢討、積極改進。
        超前部署、預置兵力、隨時防救。
        勿枉勿縱、妥審速結、重罪重典。
        你可以憋氣兩分鐘，真不簡單。
        永久屋住起來像在普羅旺斯。
        子彈已經上膛，會死的很難看。
        改造產業結構，提高薪資水準。
        這不是關說，什麼才是關說。
        633做不到，願捐出薪水。
        決心做宅男，誓死不出門。
        一、二、三、四、五、六、七、八、九、十。
        做很多事，卻得不到掌聲。
        不簽ECFA會要命。
        料敵從寬，禦敵從嚴。
        我姓馬稍微吃點虧。
        沒聽到有人有意見。
        你的基因沒有問題。
        我是看報紙才知道。
        妳可不要拒絕我喔。
        等我講完再來救你。
        爾俸爾祿，民脂民膏。
        不畏艱險、攜手向前。
        我們不是被嚇大的。
        他們已經得到教訓。
        總統不換，經濟無望。
        你怎麼不早說呢。
        你不是見到了嗎。
        子彈已經上膛了。
        民眾不懂經濟學。
        大家要共體時艱。
        我看報紙才知道。
        我爸爸是馬鶴凌。
        我不是來了嗎。
        我媽媽支持我。
        天仙也沒有用。
        我把你當人看。
        我要教育你們。
        我還會蓋貓纜。
        不運動就是懶。
        氣象局不準。
        好心沒好報。
        何不食二盒。
        大是大非。
        毛骨悚然。
        我、管、定、了！
        逆風高灰。
        黃金十年。
        幹得要死。
        謝謝指教。
        依法行政。
        世事難料。
        自求多福。
        米酒總統。
        幫不上忙。
        人間極品。
        悲天憫人。
        不惜一戰。
        毛毛的。
        相信我。
        六三三。
        沒~有~啦~
        去他的。
        管他娘。
        吹喇叭。
        知道了。
        歐耶。
        謝謝。
        唉。
        欸。
        哼！
        懶~
      )
JIANGZHINE = [
        '那要先將蘋果，洋蔥等切成末之後，跟各種調味料以絕妙的比例互相調合。',
        '再給我一分鐘我一定能完成的。',
        '你從什麼時候開始產生了我有醬汁的錯覺？',
        '醬汁?醬汁你老木!你有醬汁嗎?'
      ]
BOSS_SAY = %w(好秀嗎？ wu你妹 億全 愛溝共 小組抱抱 西咧靠腰 衝啥)
BULLETS = %w(翻譯翻譯 黃四郎臉上有四嗎？ 你給我他媽的翻譯一下他媽的到底什麼是他媽的驚喜！ 別急，讓子彈飛一會兒。 你這是要殺我，還是要睡我呢？ 屁股在樹上呢！ 騙了就騙了吧！ 兄弟們，回鵝城！ 我聽出來了，你們都個個身懷絕技。 你覺得是你對我重要，還是錢對我重要？ 你再想想？ 其實你和錢對我都不重要。沒有你，對我很重要！ 槍在手！跟我走！ 殺四郎！搶碉樓! 兄弟!你太客氣了! 三舅，這話能跟他說嗎？ 他奶奶的這樣八歲! 放他媽的屁怎麼沒吹啊！？ 我要當縣長 步子邁大了，容易扯著蛋！ 明白啦!誰贏他們就幫誰)
MATT_SAY =  ['Exactly..Exactly', '那我也不想給你看' , 'Hi,I\'m Matt.', '你們喜歡在這工作嗎?', '你們有看過凱羅忍的光劍嗎?', '你們覺得凱羅忍怎麼樣?', '你們相信他能像他所說的完成達斯.維達的遺願嗎?', '你這樣我壓力很大!', '嘿, 你踢我的版手', '才不是, 它超屌的', 'After Rain, Comes the Rainbow', '我看我能不能找到, 讓你們見識一下', '你們看！我找到凱羅忍的光劍了', '他說凱羅忍有八塊肌, 說他身材超健美', '我能知道你在想什麼', '你的想法..很愚蠢!!', '噢不, 他被食物噎到了!', ]

def wiki(query)
  query = CGI.escape(query)
  query_string = "?action=opensearch&search=#{query}&limit=1&namespace=0&format=json"
  res = HTTParty.get(WIKIPEDIA_URL + query_string)
  JSON.parse(res.body).last.first
end

def news
  res = HTTParty.get('http://oldpaper.g0v.ronny.tw/index/json')
  res_json = JSON.parse(res.body)
  "#{res_json['data'].first['title']} \n" + "#{res_json['data'].first['headlines'].map {|v| v.join(': ') }.join("\n")}" + "\n#{res_json['data'].first['link']}"
end

def gif(word)
  word = CGI.escape(word)
  url = "http://api.giphy.com/v1/gifs/search?q=#{word}&api_key=dc6zaTOxFJmzC&limit=15"
  res = HTTParty.get(url)
  res_json = JSON.parse(res.body)
  res_json['data'].sample['images']['original']['url']
end