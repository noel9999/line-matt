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
        text = case event.message['text']
               when /[馬螞皇蝗騜]/i
                 MA_SAYS.sample             
               when /所以我說那個.+呢/i, /醬汁呢/i
                 JIANGZHINE.sample             
               when /李老闆|作弊|泡泡|陳世彥/
                 '去後面罰站!'
               when /武德|(W|w)uder|億全|波斯|(B|b)oss|好笑嗎|好秀嗎/
                 BOSS_SAY.sample
               when /大哥|翻譯｜子彈/
                 BULLETS.sample
               when /你的錯|怪我囉|都你害的/
                 '大人，冤枉啊'
               when /(m|M)att|radar/
                 MATT_SAY.sample
               when /欸/
                 %w(欸 欸屁).sample
               when /^wiki\s{1}(.+)$/
                 key_word = event.message['text'].match(/^wiki\s{1}(.+)$/)[1]
                 wiki(key_word)
               end
        message = {
          type: 'text',
          text: text
        }
        client.reply_message(event['replyToken'], message) if 'a' == %w(a b c).sample
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
  'Hello World WTF'
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
        '再給我一分鐘我一定能完成的。'
      ]
BOSS_SAY = %w(好秀嗎？ wu你妹 億全 愛溝共 小組抱抱 西咧靠腰 衝啥)
BULLETS = %w(翻譯翻譯 黃四郎臉上有四嗎？ 你給我他媽的翻譯一下他媽的到底什麼是他媽的驚喜！ 讓子彈飛一會兒。 你這是要殺我，還是要睡我呢？ 屁股在樹上呢！ 騙了就騙了吧！ 兄弟們，回鵝城！)
MATT_SAY =  %w(Exactly..Exactly 那我也不想給你看)

def wiki(query)
  query = CGI.escape(query)
  query_string = "?action=opensearch&search=#{query}&limit=1&namespace=0&format=json"
  res = HTTParty.get(WIKIPEDIA_URL + query_string)
  JSON.parse(res.body).last.first
end