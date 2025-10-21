-- N5 Level Vocabulary (50 words)
-- Insert 50 common N5 vocabulary words organized by category

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
  example_translation,
  order_index,
  difficulty_level
)
VALUES
  -- Greetings (201-205)
  ('vocabulary', 'N5', 'おはよう', 'ohayou', '좋은 아침', 'expressions', 'greetings', 'おはよう、田中さん。', '좋은 아침, 다나카 씨.', 201, 1),
  ('vocabulary', 'N5', 'こんにちは', 'konnichiwa', '안녕하세요', 'expressions', 'greetings', 'こんにちは、元気ですか。', '안녕하세요, 잘 지내세요?', 202, 1),
  ('vocabulary', 'N5', 'ありがとう', 'arigatou', '감사합니다', 'expressions', 'greetings', 'ありがとうございます。', '감사합니다.', 203, 1),
  ('vocabulary', 'N5', 'すみません', 'sumimasen', '죄송합니다', 'expressions', 'greetings', 'すみません、遅れました。', '죄송합니다, 늦었습니다.', 204, 1),
  ('vocabulary', 'N5', 'さようなら', 'sayounara', '안녕히 가세요', 'expressions', 'greetings', 'さようなら、また明日。', '안녕히 가세요, 내일 또 봐요.', 205, 1),

  -- Numbers (206-215)
  ('vocabulary', 'N5', '一', 'ichi', '일, 하나', 'numbers', 'basic', '一つください。', '하나 주세요.', 206, 1),
  ('vocabulary', 'N5', '二', 'ni', '이, 둘', 'numbers', 'basic', '二人で行きます。', '두 명이서 갑니다.', 207, 1),
  ('vocabulary', 'N5', '三', 'san', '삼, 셋', 'numbers', 'basic', '三日に会いましょう。', '3일에 만나요.', 208, 1),
  ('vocabulary', 'N5', '四', 'shi/yon', '사, 넷', 'numbers', 'basic', '四時に来てください。', '4시에 와주세요.', 209, 1),
  ('vocabulary', 'N5', '五', 'go', '오, 다섯', 'numbers', 'basic', '五分待ってください。', '5분 기다려주세요.', 210, 1),
  ('vocabulary', 'N5', '六', 'roku', '육, 여섯', 'numbers', 'basic', '六月に始まります。', '6월에 시작합니다.', 211, 1),
  ('vocabulary', 'N5', '七', 'shichi/nana', '칠, 일곱', 'numbers', 'basic', '七時に起きます。', '7시에 일어납니다.', 212, 1),
  ('vocabulary', 'N5', '八', 'hachi', '팔, 여덟', 'numbers', 'basic', '八百円です。', '800엔입니다.', 213, 1),
  ('vocabulary', 'N5', '九', 'kyuu/ku', '구, 아홉', 'numbers', 'basic', '九月です。', '9월입니다.', 214, 1),
  ('vocabulary', 'N5', '十', 'juu', '십, 열', 'numbers', 'basic', '十分です。', '충분합니다.', 215, 1),

  -- Time Words (216-220)
  ('vocabulary', 'N5', '今日', 'kyou', '오늘', 'time', 'day', '今日は暑いです。', '오늘은 덥습니다.', 216, 1),
  ('vocabulary', 'N5', '明日', 'ashita', '내일', 'time', 'day', '明日会いましょう。', '내일 만나요.', 217, 1),
  ('vocabulary', 'N5', '昨日', 'kinou', '어제', 'time', 'day', '昨日は雨でした。', '어제는 비였습니다.', 218, 1),
  ('vocabulary', 'N5', '毎日', 'mainichi', '매일', 'time', 'frequency', '毎日勉強します。', '매일 공부합니다.', 219, 1),
  ('vocabulary', 'N5', '今', 'ima', '지금', 'time', 'moment', '今、行きます。', '지금 갑니다.', 220, 1),

  -- Family (221-225)
  ('vocabulary', 'N5', '家族', 'kazoku', '가족', 'people', 'family', '家族と旅行します。', '가족과 여행합니다.', 221, 1),
  ('vocabulary', 'N5', '父', 'chichi', '아버지', 'people', 'family', '父は会社員です。', '아버지는 회사원입니다.', 222, 1),
  ('vocabulary', 'N5', '母', 'haha', '어머니', 'people', 'family', '母は料理が上手です。', '어머니는 요리를 잘합니다.', 223, 1),
  ('vocabulary', 'N5', '兄弟', 'kyoudai', '형제', 'people', 'family', '兄弟がいますか。', '형제가 있습니까?', 224, 1),
  ('vocabulary', 'N5', '友達', 'tomodachi', '친구', 'people', 'relations', '友達と遊びます。', '친구와 놉니다.', 225, 1),

  -- Places (226-230)
  ('vocabulary', 'N5', '学校', 'gakkou', '학교', 'places', 'education', '学校へ行きます。', '학교에 갑니다.', 226, 1),
  ('vocabulary', 'N5', '家', 'ie', '집', 'places', 'building', '家に帰ります。', '집에 돌아갑니다.', 227, 1),
  ('vocabulary', 'N5', '店', 'mise', '가게', 'places', 'commercial', 'あの店で買います。', '저 가게에서 삽니다.', 228, 1),
  ('vocabulary', 'N5', '駅', 'eki', '역', 'places', 'transport', '駅で会いましょう。', '역에서 만나요.', 229, 1),
  ('vocabulary', 'N5', '国', 'kuni', '나라', 'places', 'geography', 'どこの国ですか。', '어느 나라입니까?', 230, 1),

  -- Verbs (231-240)
  ('vocabulary', 'N5', '食べる', 'taberu', '먹다', 'verbs', 'action', 'ご飯を食べます。', '밥을 먹습니다.', 231, 1),
  ('vocabulary', 'N5', '飲む', 'nomu', '마시다', 'verbs', 'action', '水を飲みます。', '물을 마십니다.', 232, 1),
  ('vocabulary', 'N5', '行く', 'iku', '가다', 'verbs', 'movement', '学校へ行きます。', '학교에 갑니다.', 233, 1),
  ('vocabulary', 'N5', '来る', 'kuru', '오다', 'verbs', 'movement', 'ここに来てください。', '여기 와주세요.', 234, 1),
  ('vocabulary', 'N5', '見る', 'miru', '보다', 'verbs', 'perception', 'テレビを見ます。', 'TV를 봅니다.', 235, 1),
  ('vocabulary', 'N5', '聞く', 'kiku', '듣다', 'verbs', 'perception', '音楽を聞きます。', '음악을 듣습니다.', 236, 1),
  ('vocabulary', 'N5', '話す', 'hanasu', '말하다', 'verbs', 'communication', '日本語を話します。', '일본어를 말합니다.', 237, 1),
  ('vocabulary', 'N5', '書く', 'kaku', '쓰다', 'verbs', 'communication', '手紙を書きます。', '편지를 씁니다.', 238, 1),
  ('vocabulary', 'N5', '読む', 'yomu', '읽다', 'verbs', 'communication', '本を読みます。', '책을 읽습니다.', 239, 1),
  ('vocabulary', 'N5', 'する', 'suru', '하다', 'verbs', 'action', '勉強します。', '공부합니다.', 240, 1),

  -- Adjectives (241-245)
  ('vocabulary', 'N5', '大きい', 'ookii', '크다', 'adjectives', 'size', '大きい家です。', '큰 집입니다.', 241, 1),
  ('vocabulary', 'N5', '小さい', 'chiisai', '작다', 'adjectives', 'size', '小さい犬です。', '작은 개입니다.', 242, 1),
  ('vocabulary', 'N5', '新しい', 'atarashii', '새롭다', 'adjectives', 'state', '新しい本です。', '새 책입니다.', 243, 1),
  ('vocabulary', 'N5', '古い', 'furui', '오래되다', 'adjectives', 'state', '古い写真です。', '오래된 사진입니다.', 244, 1),
  ('vocabulary', 'N5', '好き', 'suki', '좋아하다', 'adjectives', 'preference', '日本が好きです。', '일본을 좋아합니다.', 245, 1),

  -- Basic Nouns (246-250)
  ('vocabulary', 'N5', '人', 'hito', '사람', 'nouns', 'person', 'あの人は誰ですか。', '저 사람은 누구입니까?', 246, 1),
  ('vocabulary', 'N5', '時間', 'jikan', '시간', 'nouns', 'time', '時間がありません。', '시간이 없습니다.', 247, 1),
  ('vocabulary', 'N5', '本', 'hon', '책', 'nouns', 'object', '本を読みます。', '책을 읽습니다.', 248, 1),
  ('vocabulary', 'N5', '水', 'mizu', '물', 'nouns', 'substance', '水をください。', '물 주세요.', 249, 1),
  ('vocabulary', 'N5', '日本語', 'nihongo', '일본어', 'nouns', 'language', '日本語を勉強します。', '일본어를 공부합니다.', 250, 1);

  GET DIAGNOSTICS inserted_count = ROW_COUNT;
  RAISE NOTICE 'Inserted % N5 vocabulary items', inserted_count;

END $$;
