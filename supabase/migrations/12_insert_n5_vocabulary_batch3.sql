-- N5 Vocabulary - 3rd Batch (Final 50 words, 351-400)
-- Essential vocabulary: numbers, verbs, adjectives, daily objects

DO $$
DECLARE
  inserted_count INTEGER;
BEGIN

INSERT INTO learning_items (
  type,
  jlpt_level,
  content,
  reading,
  meaning,
  category,
  subcategory,
  example_sentence,
  example_reading,
  example_translation,
  order_index,
  difficulty_level
)
VALUES
  -- Numbers (351-360)
  ('vocabulary', 'N5', '一', 'いち', '하나, 1', 'numbers', 'basic', 'りんごを一つください。', 'りんごをひとつください。', '사과를 하나 주세요.', 351, 1),
  ('vocabulary', 'N5', '二', 'に', '둘, 2', 'numbers', 'basic', 'ペンが二本あります。', 'ぺんがにほんあります。', '펜이 두 개 있어요.', 352, 1),
  ('vocabulary', 'N5', '三', 'さん', '셋, 3', 'numbers', 'basic', '三時に会いましょう。', 'さんじにあいましょう。', '3시에 만나요.', 353, 1),
  ('vocabulary', 'N5', '四', 'し・よん', '넷, 4', 'numbers', 'basic', '四人家族です。', 'よにんかぞくです。', '4인 가족이에요.', 354, 1),
  ('vocabulary', 'N5', '五', 'ご', '다섯, 5', 'numbers', 'basic', '五分待ってください。', 'ごふんまってください。', '5분 기다려주세요.', 355, 1),
  ('vocabulary', 'N5', '六', 'ろく', '여섯, 6', 'numbers', 'basic', '六月に日本に行きます。', 'ろくがつににほんにいきます。', '6월에 일본에 가요.', 356, 1),
  ('vocabulary', 'N5', '七', 'しち・なな', '일곱, 7', 'numbers', 'basic', '七時に起きます。', 'しちじにおきます。', '7시에 일어나요.', 357, 1),
  ('vocabulary', 'N5', '八', 'はち', '여덟, 8', 'numbers', 'basic', '八百円です。', 'はっぴゃくえんです。', '800엔이에요.', 358, 1),
  ('vocabulary', 'N5', '九', 'きゅう・く', '아홉, 9', 'numbers', 'basic', '九時に寝ます。', 'くじにねます。', '9시에 자요.', 359, 1),
  ('vocabulary', 'N5', '十', 'じゅう', '열, 10', 'numbers', 'basic', '十分前に着きました。', 'じゅっぷんまえにつきました。', '10분 전에 도착했어요.', 360, 1),

  -- Common Verbs (361-375)
  ('vocabulary', 'N5', '行く', 'いく', '가다', 'verbs', 'movement', '学校に行きます。', 'がっこうにいきます。', '학교에 가요.', 361, 1),
  ('vocabulary', 'N5', '来る', 'くる', '오다', 'verbs', 'movement', '明日来てください。', 'あしたきてください。', '내일 와주세요.', 362, 1),
  ('vocabulary', 'N5', '帰る', 'かえる', '돌아가다', 'verbs', 'movement', '六時に家に帰ります。', 'ろくじにいえにかえります。', '6시에 집에 돌아가요.', 363, 1),
  ('vocabulary', 'N5', '食べる', 'たべる', '먹다', 'verbs', 'daily', '朝ご飯を食べます。', 'あさごはんをたべます。', '아침밥을 먹어요.', 364, 1),
  ('vocabulary', 'N5', '飲む', 'のむ', '마시다', 'verbs', 'daily', 'コーヒーを飲みます。', 'こーひーをのみます。', '커피를 마셔요.', 365, 1),
  ('vocabulary', 'N5', '見る', 'みる', '보다', 'verbs', 'action', 'テレビを見ます。', 'てれびをみます。', 'TV를 봐요.', 366, 1),
  ('vocabulary', 'N5', '聞く', 'きく', '듣다, 묻다', 'verbs', 'action', '音楽を聞きます。', 'おんがくをききます。', '음악을 들어요.', 367, 1),
  ('vocabulary', 'N5', '話す', 'はなす', '말하다', 'verbs', 'action', '日本語を話します。', 'にほんごをはなします。', '일본어를 말해요.', 368, 1),
  ('vocabulary', 'N5', '読む', 'よむ', '읽다', 'verbs', 'action', '本を読みます。', 'ほんをよみます。', '책을 읽어요.', 369, 1),
  ('vocabulary', 'N5', '書く', 'かく', '쓰다', 'verbs', 'action', '手紙を書きます。', 'てがみをかきます。', '편지를 써요.', 370, 1),
  ('vocabulary', 'N5', '寝る', 'ねる', '자다', 'verbs', 'daily', '十一時に寝ます。', 'じゅういちじにねます。', '11시에 자요.', 371, 1),
  ('vocabulary', 'N5', '起きる', 'おきる', '일어나다', 'verbs', 'daily', '毎朝七時に起きます。', 'まいあさしちじにおきます。', '매일 아침 7시에 일어나요.', 372, 1),
  ('vocabulary', 'N5', '座る', 'すわる', '앉다', 'verbs', 'action', 'ここに座ってください。', 'ここにすわってください。', '여기 앉으세요.', 373, 1),
  ('vocabulary', 'N5', '立つ', 'たつ', '서다', 'verbs', 'action', '立って待っています。', 'たってまっています。', '서서 기다리고 있어요.', 374, 1),
  ('vocabulary', 'N5', '歩く', 'あるく', '걷다', 'verbs', 'movement', '公園を歩きます。', 'こうえんをあるきます。', '공원을 걸어요.', 375, 1),

  -- Additional Adjectives (376-385)
  ('vocabulary', 'N5', '良い', 'よい・いい', '좋다', 'adjectives', 'quality', '天気が良いです。', 'てんきがいいです。', '날씨가 좋아요.', 376, 1),
  ('vocabulary', 'N5', '悪い', 'わるい', '나쁘다', 'adjectives', 'quality', '成績が悪いです。', 'せいせきがわるいです。', '성적이 나빠요.', 377, 1),
  ('vocabulary', 'N5', '暑い', 'あつい', '덥다', 'adjectives', 'weather', '今日は暑いです。', 'きょうはあついです。', '오늘은 더워요.', 378, 1),
  ('vocabulary', 'N5', '寒い', 'さむい', '춥다', 'adjectives', 'weather', '冬は寒いです。', 'ふゆはさむいです。', '겨울은 추워요.', 379, 1),
  ('vocabulary', 'N5', '難しい', 'むずかしい', '어렵다', 'adjectives', 'difficulty', 'この問題は難しいです。', 'このもんだいはむずかしいです。', '이 문제는 어려워요.', 380, 1),
  ('vocabulary', 'N5', '易しい', 'やさしい', '쉽다, 친절하다', 'adjectives', 'difficulty', 'テストが易しかったです。', 'てすとがやさしかったです。', '시험이 쉬웠어요.', 381, 1),
  ('vocabulary', 'N5', '近い', 'ちかい', '가깝다', 'adjectives', 'distance', '駅が近いです。', 'えきがちかいです。', '역이 가까워요.', 382, 1),
  ('vocabulary', 'N5', '遠い', 'とおい', '멀다', 'adjectives', 'distance', '学校は遠いです。', 'がっこうはとおいです。', '학교는 멀어요.', 383, 1),
  ('vocabulary', 'N5', '若い', 'わかい', '젊다', 'adjectives', 'age', 'まだ若いです。', 'まだわかいです。', '아직 젊어요.', 384, 1),
  ('vocabulary', 'N5', '速い', 'はやい', '빠르다', 'adjectives', 'speed', '車が速いです。', 'くるまがはやいです。', '차가 빨라요.', 385, 1),

  -- Daily Objects (386-400)
  ('vocabulary', 'N5', '水', 'みず', '물', 'objects', 'daily', '水を飲みます。', 'みずをのみます。', '물을 마셔요.', 386, 1),
  ('vocabulary', 'N5', '本', 'ほん', '책', 'objects', 'daily', '本を読みます。', 'ほんをよみます。', '책을 읽어요.', 387, 1),
  ('vocabulary', 'N5', 'ペン', 'ぺん', '펜', 'objects', 'stationery', 'ペンで書きます。', 'ぺんでかきます。', '펜으로 써요.', 388, 1),
  ('vocabulary', 'N5', '紙', 'かみ', '종이', 'objects', 'stationery', '白い紙をください。', 'しろいかみをください。', '흰 종이를 주세요.', 389, 1),
  ('vocabulary', 'N5', '傘', 'かさ', '우산', 'objects', 'daily', '傘を持っていきます。', 'かさをもっていきます。', '우산을 가져가요.', 390, 1),
  ('vocabulary', 'N5', '鞄', 'かばん', '가방', 'objects', 'daily', '新しい鞄を買いました。', 'あたらしいかばんをかいました。', '새 가방을 샀어요.', 391, 1),
  ('vocabulary', 'N5', '時計', 'とけい', '시계', 'objects', 'daily', '時計を見ます。', 'とけいをみます。', '시계를 봐요.', 392, 1),
  ('vocabulary', 'N5', '電話', 'でんわ', '전화', 'objects', 'electronics', '電話をかけます。', 'でんわをかけます。', '전화를 걸어요.', 393, 1),
  ('vocabulary', 'N5', 'お金', 'おかね', '돈', 'objects', 'money', 'お金がありません。', 'おかねがありません。', '돈이 없어요.', 394, 1),
  ('vocabulary', 'N5', 'ドア', 'どあ', '문', 'objects', 'furniture', 'ドアを開けてください。', 'どあをあけてください。', '문을 열어주세요.', 395, 1),
  ('vocabulary', 'N5', '窓', 'まど', '창문', 'objects', 'furniture', '窓を閉めます。', 'まどをしめます。', '창문을 닫아요.', 396, 1),
  ('vocabulary', 'N5', 'テーブル', 'てーぶる', '테이블', 'objects', 'furniture', 'テーブルの上に本があります。', 'てーぶるのうえにほんがあります。', '테이블 위에 책이 있어요.', 397, 1),
  ('vocabulary', 'N5', '椅子', 'いす', '의자', 'objects', 'furniture', '椅子に座ります。', 'いすにすわります。', '의자에 앉아요.', 398, 1),
  ('vocabulary', 'N5', 'ベッド', 'べっど', '침대', 'objects', 'furniture', 'ベッドで寝ます。', 'べっどでねます。', '침대에서 자요.', 399, 1),
  ('vocabulary', 'N5', '部屋', 'へや', '방', 'objects', 'housing', '部屋がきれいです。', 'へやがきれいです。', '방이 깨끗해요.', 400, 1);

  GET DIAGNOSTICS inserted_count = ROW_COUNT;
  RAISE NOTICE 'Inserted % N5 vocabulary items (3rd batch - FINAL)', inserted_count;

END $$;
