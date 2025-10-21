-- 히라가나 기본 46자 데이터 삽입
-- あ행부터 わ행까지 순서대로

INSERT INTO learning_items (type, jlpt_level, content, reading, meaning, category, order_index, difficulty_level)
VALUES
  -- あ행 (a-row)
  ('hiragana', 'N5', 'あ', 'a', '아', 'basic', 1, 1),
  ('hiragana', 'N5', 'い', 'i', '이', 'basic', 2, 1),
  ('hiragana', 'N5', 'う', 'u', '우', 'basic', 3, 1),
  ('hiragana', 'N5', 'え', 'e', '에', 'basic', 4, 1),
  ('hiragana', 'N5', 'お', 'o', '오', 'basic', 5, 1),

  -- か행 (ka-row)
  ('hiragana', 'N5', 'か', 'ka', '카', 'basic', 6, 1),
  ('hiragana', 'N5', 'き', 'ki', '키', 'basic', 7, 1),
  ('hiragana', 'N5', 'く', 'ku', '쿠', 'basic', 8, 1),
  ('hiragana', 'N5', 'け', 'ke', '케', 'basic', 9, 1),
  ('hiragana', 'N5', 'こ', 'ko', '코', 'basic', 10, 1),

  -- さ행 (sa-row)
  ('hiragana', 'N5', 'さ', 'sa', '사', 'basic', 11, 1),
  ('hiragana', 'N5', 'し', 'shi', '시', 'basic', 12, 1),
  ('hiragana', 'N5', 'す', 'su', '스', 'basic', 13, 1),
  ('hiragana', 'N5', 'せ', 'se', '세', 'basic', 14, 1),
  ('hiragana', 'N5', 'そ', 'so', '소', 'basic', 15, 1),

  -- た행 (ta-row)
  ('hiragana', 'N5', 'た', 'ta', '타', 'basic', 16, 1),
  ('hiragana', 'N5', 'ち', 'chi', '치', 'basic', 17, 1),
  ('hiragana', 'N5', 'つ', 'tsu', '츠', 'basic', 18, 2),
  ('hiragana', 'N5', 'て', 'te', '테', 'basic', 19, 1),
  ('hiragana', 'N5', 'と', 'to', '토', 'basic', 20, 1),

  -- な행 (na-row)
  ('hiragana', 'N5', 'な', 'na', '나', 'basic', 21, 1),
  ('hiragana', 'N5', 'に', 'ni', '니', 'basic', 22, 1),
  ('hiragana', 'N5', 'ぬ', 'nu', '누', 'basic', 23, 2),
  ('hiragana', 'N5', 'ね', 'ne', '네', 'basic', 24, 1),
  ('hiragana', 'N5', 'の', 'no', '노', 'basic', 25, 1),

  -- は행 (ha-row)
  ('hiragana', 'N5', 'は', 'ha', '하', 'basic', 26, 1),
  ('hiragana', 'N5', 'ひ', 'hi', '히', 'basic', 27, 1),
  ('hiragana', 'N5', 'ふ', 'fu', '후', 'basic', 28, 2),
  ('hiragana', 'N5', 'へ', 'he', '헤', 'basic', 29, 1),
  ('hiragana', 'N5', 'ほ', 'ho', '호', 'basic', 30, 2),

  -- ま행 (ma-row)
  ('hiragana', 'N5', 'ま', 'ma', '마', 'basic', 31, 1),
  ('hiragana', 'N5', 'み', 'mi', '미', 'basic', 32, 1),
  ('hiragana', 'N5', 'む', 'mu', '무', 'basic', 33, 2),
  ('hiragana', 'N5', 'め', 'me', '메', 'basic', 34, 2),
  ('hiragana', 'N5', 'も', 'mo', '모', 'basic', 35, 1),

  -- や행 (ya-row)
  ('hiragana', 'N5', 'や', 'ya', '야', 'basic', 36, 1),
  ('hiragana', 'N5', 'ゆ', 'yu', '유', 'basic', 37, 1),
  ('hiragana', 'N5', 'よ', 'yo', '요', 'basic', 38, 1),

  -- ら행 (ra-row)
  ('hiragana', 'N5', 'ら', 'ra', '라', 'basic', 39, 1),
  ('hiragana', 'N5', 'り', 'ri', '리', 'basic', 40, 1),
  ('hiragana', 'N5', 'る', 'ru', '루', 'basic', 41, 2),
  ('hiragana', 'N5', 'れ', 're', '레', 'basic', 42, 2),
  ('hiragana', 'N5', 'ろ', 'ro', '로', 'basic', 43, 1),

  -- わ행 (wa-row)
  ('hiragana', 'N5', 'わ', 'wa', '와', 'basic', 44, 2),
  ('hiragana', 'N5', 'を', 'wo', '오 (조사)', 'basic', 45, 2),
  ('hiragana', 'N5', 'ん', 'n', '응', 'basic', 46, 1);

-- 데이터 삽입 확인
DO $$
DECLARE
  item_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO item_count FROM learning_items WHERE type = 'hiragana';
  RAISE NOTICE '히라가나 데이터 % 개 삽입 완료', item_count;
END $$;
-- 가타카나 기본 46자 데이터 삽입
-- ア행부터 ワ행까지 순서대로

INSERT INTO learning_items (type, jlpt_level, content, reading, meaning, category, order_index, difficulty_level)
VALUES
  -- ア행 (a-row)
  ('katakana', 'N5', 'ア', 'a', '아', 'basic', 101, 1),
  ('katakana', 'N5', 'イ', 'i', '이', 'basic', 102, 1),
  ('katakana', 'N5', 'ウ', 'u', '우', 'basic', 103, 1),
  ('katakana', 'N5', 'エ', 'e', '에', 'basic', 104, 1),
  ('katakana', 'N5', 'オ', 'o', '오', 'basic', 105, 1),

  -- カ행 (ka-row)
  ('katakana', 'N5', 'カ', 'ka', '카', 'basic', 106, 1),
  ('katakana', 'N5', 'キ', 'ki', '키', 'basic', 107, 1),
  ('katakana', 'N5', 'ク', 'ku', '쿠', 'basic', 108, 1),
  ('katakana', 'N5', 'ケ', 'ke', '케', 'basic', 109, 1),
  ('katakana', 'N5', 'コ', 'ko', '코', 'basic', 110, 1),

  -- サ행 (sa-row)
  ('katakana', 'N5', 'サ', 'sa', '사', 'basic', 111, 1),
  ('katakana', 'N5', 'シ', 'shi', '시', 'basic', 112, 1),
  ('katakana', 'N5', 'ス', 'su', '스', 'basic', 113, 1),
  ('katakana', 'N5', 'セ', 'se', '세', 'basic', 114, 1),
  ('katakana', 'N5', 'ソ', 'so', '소', 'basic', 115, 2),

  -- タ행 (ta-row)
  ('katakana', 'N5', 'タ', 'ta', '타', 'basic', 116, 1),
  ('katakana', 'N5', 'チ', 'chi', '치', 'basic', 117, 1),
  ('katakana', 'N5', 'ツ', 'tsu', '츠', 'basic', 118, 2),
  ('katakana', 'N5', 'テ', 'te', '테', 'basic', 119, 1),
  ('katakana', 'N5', 'ト', 'to', '토', 'basic', 120, 1),

  -- ナ행 (na-row)
  ('katakana', 'N5', 'ナ', 'na', '나', 'basic', 121, 1),
  ('katakana', 'N5', 'ニ', 'ni', '니', 'basic', 122, 1),
  ('katakana', 'N5', 'ヌ', 'nu', '누', 'basic', 123, 2),
  ('katakana', 'N5', 'ネ', 'ne', '네', 'basic', 124, 2),
  ('katakana', 'N5', 'ノ', 'no', '노', 'basic', 125, 1),

  -- ハ행 (ha-row)
  ('katakana', 'N5', 'ハ', 'ha', '하', 'basic', 126, 1),
  ('katakana', 'N5', 'ヒ', 'hi', '히', 'basic', 127, 1),
  ('katakana', 'N5', 'フ', 'fu', '후', 'basic', 128, 2),
  ('katakana', 'N5', 'ヘ', 'he', '헤', 'basic', 129, 1),
  ('katakana', 'N5', 'ホ', 'ho', '호', 'basic', 130, 1),

  -- マ행 (ma-row)
  ('katakana', 'N5', 'マ', 'ma', '마', 'basic', 131, 1),
  ('katakana', 'N5', 'ミ', 'mi', '미', 'basic', 132, 2),
  ('katakana', 'N5', 'ム', 'mu', '무', 'basic', 133, 1),
  ('katakana', 'N5', 'メ', 'me', '메', 'basic', 134, 1),
  ('katakana', 'N5', 'モ', 'mo', '모', 'basic', 135, 1),

  -- ヤ행 (ya-row)
  ('katakana', 'N5', 'ヤ', 'ya', '야', 'basic', 136, 1),
  ('katakana', 'N5', 'ユ', 'yu', '유', 'basic', 137, 1),
  ('katakana', 'N5', 'ヨ', 'yo', '요', 'basic', 138, 1),

  -- ラ행 (ra-row)
  ('katakana', 'N5', 'ラ', 'ra', '라', 'basic', 139, 1),
  ('katakana', 'N5', 'リ', 'ri', '리', 'basic', 140, 1),
  ('katakana', 'N5', 'ル', 'ru', '루', 'basic', 141, 1),
  ('katakana', 'N5', 'レ', 're', '레', 'basic', 142, 1),
  ('katakana', 'N5', 'ロ', 'ro', '로', 'basic', 143, 1),

  -- ワ행 (wa-row)
  ('katakana', 'N5', 'ワ', 'wa', '와', 'basic', 144, 1),
  ('katakana', 'N5', 'ヲ', 'wo', '오 (조사)', 'basic', 145, 2),
  ('katakana', 'N5', 'ン', 'n', '응', 'basic', 146, 1);

-- 데이터 삽입 확인
DO $$
DECLARE
  item_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO item_count FROM learning_items WHERE type = 'katakana';
  RAISE NOTICE '가타카나 데이터 % 개 삽입 완료', item_count;
END $$;
-- N5 Vocabulary - 1st Batch (50 words)
-- Essential daily life vocabulary: time, food, location, transportation, weather

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
  -- Days of the Week (251-257)
  ('vocabulary', 'N5', '月曜日', 'getsuyoubi', '월요일', 'time', 'days', '月曜日に会いましょう。', '월요일에 만나요.', 251, 1),
  ('vocabulary', 'N5', '火曜日', 'kayoubi', '화요일', 'time', 'days', '火曜日は忙しいです。', '화요일은 바빠요.', 252, 1),
  ('vocabulary', 'N5', '水曜日', 'suiyoubi', '수요일', 'time', 'days', '水曜日に試験があります。', '수요일에 시험이 있어요.', 253, 1),
  ('vocabulary', 'N5', '木曜日', 'mokuyoubi', '목요일', 'time', 'days', '木曜日は休みです。', '목요일은 쉬는 날이에요.', 254, 1),
  ('vocabulary', 'N5', '金曜日', 'kinyoubi', '금요일', 'time', 'days', '金曜日の夜は楽しいです。', '금요일 밤은 즐거워요.', 255, 1),
  ('vocabulary', 'N5', '土曜日', 'doyoubi', '토요일', 'time', 'days', '土曜日に買い物します。', '토요일에 쇼핑해요.', 256, 1),
  ('vocabulary', 'N5', '日曜日', 'nichiyoubi', '일요일', 'time', 'days', '日曜日は家族と過ごします。', '일요일은 가족과 보내요.', 257, 1),

  -- Time of Day (258-260)
  ('vocabulary', 'N5', '朝', 'asa', '아침', 'time', 'period', '朝ご飯を食べます。', '아침밥을 먹어요.', 258, 1),
  ('vocabulary', 'N5', '昼', 'hiru', '낮', 'time', 'period', '昼に友達と会います。', '낮에 친구를 만나요.', 259, 1),
  ('vocabulary', 'N5', '夜', 'yoru', '밤', 'time', 'period', '夜遅く帰ります。', '밤 늦게 돌아와요.', 260, 1),

  -- Food - Meals (261-265)
  ('vocabulary', 'N5', 'ご飯', 'gohan', '밥, 식사', 'food', 'meals', '朝ご飯を食べましたか。', '아침밥 먹었어요?', 261, 1),
  ('vocabulary', 'N5', 'パン', 'pan', '빵', 'food', 'meals', 'パンとコーヒーが好きです。', '빵과 커피를 좋아해요.', 262, 1),
  ('vocabulary', 'N5', '魚', 'sakana', '생선', 'food', 'ingredients', '魚を食べます。', '생선을 먹어요.', 263, 1),
  ('vocabulary', 'N5', '肉', 'niku', '고기', 'food', 'ingredients', '肉が好きですか。', '고기를 좋아해요?', 264, 1),
  ('vocabulary', 'N5', '野菜', 'yasai', '채소', 'food', 'ingredients', '野菜は体にいいです。', '채소는 몸에 좋아요.', 265, 1),

  -- Food - Drinks (266-268)
  ('vocabulary', 'N5', 'お茶', 'ocha', '차', 'food', 'drinks', 'お茶をください。', '차 주세요.', 266, 1),
  ('vocabulary', 'N5', 'コーヒー', 'koohii', '커피', 'food', 'drinks', 'コーヒーを飲みます。', '커피를 마셔요.', 267, 1),
  ('vocabulary', 'N5', 'ジュース', 'juusu', '주스', 'food', 'drinks', 'オレンジジュースが好きです。', '오렌지 주스를 좋아해요.', 268, 1),

  -- Food - Taste (269-270)
  ('vocabulary', 'N5', 'おいしい', 'oishii', '맛있다', 'adjectives', 'taste', 'このラーメンはおいしいです。', '이 라면은 맛있어요.', 269, 1),
  ('vocabulary', 'N5', 'まずい', 'mazui', '맛없다', 'adjectives', 'taste', 'この料理はまずいです。', '이 요리는 맛없어요.', 270, 1),

  -- Location/Direction (271-278)
  ('vocabulary', 'N5', '上', 'ue', '위', 'location', 'direction', 'テーブルの上に本があります。', '테이블 위에 책이 있어요.', 271, 1),
  ('vocabulary', 'N5', '下', 'shita', '아래', 'location', 'direction', '椅子の下に猫がいます。', '의자 아래에 고양이가 있어요.', 272, 1),
  ('vocabulary', 'N5', '前', 'mae', '앞', 'location', 'direction', '駅の前で待ってください。', '역 앞에서 기다려 주세요.', 273, 1),
  ('vocabulary', 'N5', '後ろ', 'ushiro', '뒤', 'location', 'direction', '私の後ろに立ってください。', '제 뒤에 서주세요.', 274, 1),
  ('vocabulary', 'N5', '右', 'migi', '오른쪽', 'location', 'direction', '右に曲がってください。', '오른쪽으로 돌아주세요.', 275, 1),
  ('vocabulary', 'N5', '左', 'hidari', '왼쪽', 'location', 'direction', '左に学校があります。', '왼쪽에 학교가 있어요.', 276, 1),
  ('vocabulary', 'N5', '中', 'naka', '안', 'location', 'direction', '部屋の中にいます。', '방 안에 있어요.', 277, 1),
  ('vocabulary', 'N5', '外', 'soto', '밖', 'location', 'direction', '外は寒いです。', '밖은 추워요.', 278, 1),

  -- Transportation (279-284)
  ('vocabulary', 'N5', '電車', 'densha', '전철', 'transportation', 'vehicle', '電車で学校に行きます。', '전철로 학교에 가요.', 279, 1),
  ('vocabulary', 'N5', 'バス', 'basu', '버스', 'transportation', 'vehicle', 'バスに乗ります。', '버스를 타요.', 280, 1),
  ('vocabulary', 'N5', 'タクシー', 'takushii', '택시', 'transportation', 'vehicle', 'タクシーで行きましょう。', '택시로 갑시다.', 281, 1),
  ('vocabulary', 'N5', '飛行機', 'hikouki', '비행기', 'transportation', 'vehicle', '飛行機で日本に行きます。', '비행기로 일본에 가요.', 282, 1),
  ('vocabulary', 'N5', '車', 'kuruma', '차', 'transportation', 'vehicle', '車を運転します。', '차를 운전해요.', 283, 1),
  ('vocabulary', 'N5', '自転車', 'jitensha', '자전거', 'transportation', 'vehicle', '自転車に乗れますか。', '자전거를 탈 수 있어요?', 284, 1),

  -- Weather (285-288)
  ('vocabulary', 'N5', '天気', 'tenki', '날씨', 'weather', 'general', '今日の天気はいいです。', '오늘 날씨가 좋아요.', 285, 1),
  ('vocabulary', 'N5', '雨', 'ame', '비', 'weather', 'condition', '雨が降っています。', '비가 오고 있어요.', 286, 1),
  ('vocabulary', 'N5', '雪', 'yuki', '눈', 'weather', 'condition', '雪が降りました。', '눈이 왔어요.', 287, 1),
  ('vocabulary', 'N5', '晴れ', 'hare', '맑음', 'weather', 'condition', '明日は晴れです。', '내일은 맑아요.', 288, 1),

  -- Seasons (289-292)
  ('vocabulary', 'N5', '春', 'haru', '봄', 'time', 'seasons', '春は桜が咲きます。', '봄에는 벚꽃이 피어요.', 289, 1),
  ('vocabulary', 'N5', '夏', 'natsu', '여름', 'time', 'seasons', '夏は暑いです。', '여름은 더워요.', 290, 1),
  ('vocabulary', 'N5', '秋', 'aki', '가을', 'time', 'seasons', '秋は涼しいです。', '가을은 시원해요.', 291, 1),
  ('vocabulary', 'N5', '冬', 'fuyu', '겨울', 'time', 'seasons', '冬は寒いです。', '겨울은 추워요.', 292, 1),

  -- Basic Verbs Extension (293-300)
  ('vocabulary', 'N5', '買う', 'kau', '사다', 'verbs', 'action', '服を買います。', '옷을 사요.', 293, 1),
  ('vocabulary', 'N5', '売る', 'uru', '팔다', 'verbs', 'action', '車を売ります。', '차를 팔아요.', 294, 1),
  ('vocabulary', 'N5', '作る', 'tsukuru', '만들다', 'verbs', 'action', '料理を作ります。', '요리를 만들어요.', 295, 1),
  ('vocabulary', 'N5', '使う', 'tsukau', '사용하다', 'verbs', 'action', 'パソコンを使います。', '컴퓨터를 사용해요.', 296, 1),
  ('vocabulary', 'N5', '開ける', 'akeru', '열다', 'verbs', 'action', '窓を開けてください。', '창문을 열어주세요.', 297, 1),
  ('vocabulary', 'N5', '閉める', 'shimeru', '닫다', 'verbs', 'action', 'ドアを閉めます。', '문을 닫아요.', 298, 1),
  ('vocabulary', 'N5', '入る', 'hairu', '들어가다', 'verbs', 'movement', '部屋に入ります。', '방에 들어가요.', 299, 1),
  ('vocabulary', 'N5', '出る', 'deru', '나가다', 'verbs', 'movement', '家を出ます。', '집을 나가요.', 300, 1);

  GET DIAGNOSTICS inserted_count = ROW_COUNT;
  RAISE NOTICE 'Inserted % N5 vocabulary items (1st batch)', inserted_count;

END $$;
-- N5 Vocabulary - 2nd Batch (50 words)
-- Essential vocabulary: colors, body parts, family, places, time expressions, adjectives

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
  -- Colors (301-310)
  ('vocabulary', 'N5', '赤', 'あか', '빨강, 빨간색', 'colors', 'basic', '赤いりんごが好きです。', 'あかいりんごがすきです。', '빨간 사과를 좋아해요.', 301, 1),
  ('vocabulary', 'N5', '青', 'あお', '파랑, 파란색', 'colors', 'basic', '青い空がきれいです。', 'あおいそらがきれいです。', '파란 하늘이 예뻐요.', 302, 1),
  ('vocabulary', 'N5', '黄色', 'きいろ', '노랑, 노란색', 'colors', 'basic', '黄色い花が咲いています。', 'きいろいはながさいています。', '노란 꽃이 피어 있어요.', 303, 1),
  ('vocabulary', 'N5', '白', 'しろ', '하양, 흰색', 'colors', 'basic', '白い雲が浮かんでいます。', 'しろいくもがういています。', '흰 구름이 떠 있어요.', 304, 1),
  ('vocabulary', 'N5', '黒', 'くろ', '검정, 검은색', 'colors', 'basic', '黒い猫がいます。', 'くろいねこがいます。', '검은 고양이가 있어요.', 305, 1),
  ('vocabulary', 'N5', '緑', 'みどり', '초록, 초록색', 'colors', 'basic', '緑の木が多いです。', 'みどりのきがおおいです。', '초록색 나무가 많아요.', 306, 1),
  ('vocabulary', 'N5', '茶色', 'ちゃいろ', '갈색', 'colors', 'basic', '茶色いかばんを買いました。', 'ちゃいろいかばんをかいました。', '갈색 가방을 샀어요.', 307, 1),
  ('vocabulary', 'N5', 'ピンク', 'ぴんく', '분홍색', 'colors', 'basic', 'ピンクの服を着ています。', 'ぴんくのふくをきています。', '분홍색 옷을 입고 있어요.', 308, 1),
  ('vocabulary', 'N5', 'オレンジ', 'おれんじ', '주황색', 'colors', 'basic', 'オレンジ色の花がきれいです。', 'おれんじいろのはながきれいです。', '주황색 꽃이 예뻐요.', 309, 1),
  ('vocabulary', 'N5', '灰色', 'はいいろ', '회색', 'colors', 'basic', '灰色の空です。', 'はいいろのそらです。', '회색 하늘이에요.', 310, 1),

  -- Body Parts (311-320)
  ('vocabulary', 'N5', '頭', 'あたま', '머리', 'body', 'parts', '頭が痛いです。', 'あたまがいたいです。', '머리가 아파요.', 311, 1),
  ('vocabulary', 'N5', '顔', 'かお', '얼굴', 'body', 'parts', '顔を洗います。', 'かおをあらいます。', '얼굴을 씻어요.', 312, 1),
  ('vocabulary', 'N5', '目', 'め', '눈', 'body', 'parts', '目が大きいです。', 'めがおおきいです。', '눈이 커요.', 313, 1),
  ('vocabulary', 'N5', '耳', 'みみ', '귀', 'body', 'parts', '耳が痛いです。', 'みみがいたいです。', '귀가 아파요.', 314, 1),
  ('vocabulary', 'N5', '鼻', 'はな', '코', 'body', 'parts', '鼻が高いです。', 'はながたかいです。', '코가 높아요.', 315, 1),
  ('vocabulary', 'N5', '口', 'くち', '입', 'body', 'parts', '口を開けてください。', 'くちをあけてください。', '입을 벌려주세요.', 316, 1),
  ('vocabulary', 'N5', '手', 'て', '손', 'body', 'parts', '手を洗ってください。', 'てをあらってください。', '손을 씻어주세요.', 317, 1),
  ('vocabulary', 'N5', '足', 'あし', '발, 다리', 'body', 'parts', '足が速いです。', 'あしがはやいです。', '발이 빨라요.', 318, 1),
  ('vocabulary', 'N5', '体', 'からだ', '몸', 'body', 'parts', '体が元気です。', 'からだがげんきです。', '몸이 건강해요.', 319, 1),
  ('vocabulary', 'N5', '髪', 'かみ', '머리카락', 'body', 'parts', '髪が長いです。', 'かみがながいです。', '머리카락이 길어요.', 320, 1),

  -- Family (321-328)
  ('vocabulary', 'N5', '家族', 'かぞく', '가족', 'family', 'general', '家族で旅行します。', 'かぞくでりょこうします。', '가족과 여행해요.', 321, 1),
  ('vocabulary', 'N5', '父', 'ちち', '아버지 (나의)', 'family', 'members', '父は会社員です。', 'ちちはかいしゃいんです。', '아버지는 회사원이에요.', 322, 1),
  ('vocabulary', 'N5', '母', 'はは', '어머니 (나의)', 'family', 'members', '母は料理が上手です。', 'ははりょうりがじょうずです。', '어머니는 요리를 잘해요.', 323, 1),
  ('vocabulary', 'N5', '兄', 'あに', '오빠, 형 (나의)', 'family', 'members', '兄は大学生です。', 'あにはだいがくせいです。', '형은 대학생이에요.', 324, 1),
  ('vocabulary', 'N5', '姉', 'あね', '언니, 누나 (나의)', 'family', 'members', '姉は先生です。', 'あねはせんせいです。', '언니는 선생님이에요.', 325, 1),
  ('vocabulary', 'N5', '弟', 'おとうと', '남동생 (나의)', 'family', 'members', '弟は高校生です。', 'おとうとはこうこうせいです。', '남동생은 고등학생이에요.', 326, 1),
  ('vocabulary', 'N5', '妹', 'いもうと', '여동생 (나의)', 'family', 'members', '妹はまだ小さいです。', 'いもうとはまだちいさいです。', '여동생은 아직 어려요.', 327, 1),
  ('vocabulary', 'N5', '子供', 'こども', '아이, 어린이', 'family', 'general', '子供が三人います。', 'こどもがさんにんいます。', '아이가 세 명 있어요.', 328, 1),

  -- Places (329-336)
  ('vocabulary', 'N5', '家', 'いえ', '집', 'places', 'daily', '家に帰ります。', 'いえにかえります。', '집에 돌아가요.', 329, 1),
  ('vocabulary', 'N5', '学校', 'がっこう', '학교', 'places', 'daily', '学校に行きます。', 'がっこうにいきます。', '학교에 가요.', 330, 1),
  ('vocabulary', 'N5', '会社', 'かいしゃ', '회사', 'places', 'daily', '会社で働きます。', 'かいしゃではたらきます。', '회사에서 일해요.', 331, 1),
  ('vocabulary', 'N5', '店', 'みせ', '가게', 'places', 'daily', 'あの店で買い物します。', 'あのみせでかいものします。', '저 가게에서 쇼핑해요.', 332, 1),
  ('vocabulary', 'N5', '病院', 'びょういん', '병원', 'places', 'facilities', '病院に行きます。', 'びょういんにいきます。', '병원에 가요.', 333, 1),
  ('vocabulary', 'N5', '駅', 'えき', '역', 'places', 'facilities', '駅で待っています。', 'えきでまっています。', '역에서 기다리고 있어요.', 334, 1),
  ('vocabulary', 'N5', '図書館', 'としょかん', '도서관', 'places', 'facilities', '図書館で勉強します。', 'としょかんでべんきょうします。', '도서관에서 공부해요.', 335, 1),
  ('vocabulary', 'N5', '銀行', 'ぎんこう', '은행', 'places', 'facilities', '銀行でお金をおろします。', 'ぎんこうでおかねをおろします。', '은행에서 돈을 뽑아요.', 336, 1),

  -- Time Expressions (337-343)
  ('vocabulary', 'N5', '今日', 'きょう', '오늘', 'time', 'expressions', '今日は暑いです。', 'きょうはあついです。', '오늘은 더워요.', 337, 1),
  ('vocabulary', 'N5', '明日', 'あした', '내일', 'time', 'expressions', '明日会いましょう。', 'あしたあいましょう。', '내일 만나요.', 338, 1),
  ('vocabulary', 'N5', '昨日', 'きのう', '어제', 'time', 'expressions', '昨日映画を見ました。', 'きのうえいがをみました。', '어제 영화를 봤어요.', 339, 1),
  ('vocabulary', 'N5', '今', 'いま', '지금', 'time', 'expressions', '今、忙しいです。', 'いま、いそがしいです。', '지금 바빠요.', 340, 1),
  ('vocabulary', 'N5', '時間', 'じかん', '시간', 'time', 'units', '時間がありません。', 'じかんがありません。', '시간이 없어요.', 341, 1),
  ('vocabulary', 'N5', '分', 'ふん', '분', 'time', 'units', '十分待ってください。', 'じゅっぷんまってください。', '10분 기다려주세요.', 342, 1),
  ('vocabulary', 'N5', '年', 'とし', '년, 해', 'time', 'units', '来年日本に行きます。', 'らいねんにほんにいきます。', '내년에 일본에 가요.', 343, 1),

  -- Common Adjectives (344-350)
  ('vocabulary', 'N5', '大きい', 'おおきい', '크다', 'adjectives', 'size', '大きい家に住んでいます。', 'おおきいいえにすんでいます。', '큰 집에 살고 있어요.', 344, 1),
  ('vocabulary', 'N5', '小さい', 'ちいさい', '작다', 'adjectives', 'size', '小さい犬がかわいいです。', 'ちいさいいぬがかわいいです。', '작은 개가 귀여워요.', 345, 1),
  ('vocabulary', 'N5', '新しい', 'あたらしい', '새롭다', 'adjectives', 'quality', '新しい服を買いました。', 'あたらしいふくをかいました。', '새 옷을 샀어요.', 346, 1),
  ('vocabulary', 'N5', '古い', 'ふるい', '오래되다', 'adjectives', 'quality', '古い建物です。', 'ふるいたてものです。', '오래된 건물이에요.', 347, 1),
  ('vocabulary', 'N5', '高い', 'たかい', '높다, 비싸다', 'adjectives', 'quality', 'この時計は高いです。', 'このとけいはたかいです。', '이 시계는 비싸요.', 348, 1),
  ('vocabulary', 'N5', '安い', 'やすい', '싸다', 'adjectives', 'quality', '安い店を探しています。', 'やすいみせをさがしています。', '싼 가게를 찾고 있어요.', 349, 1),
  ('vocabulary', 'N5', '多い', 'おおい', '많다', 'adjectives', 'quantity', '人が多いです。', 'ひとがおおいです。', '사람이 많아요.', 350, 1);

  GET DIAGNOSTICS inserted_count = ROW_COUNT;
  RAISE NOTICE 'Inserted % N5 vocabulary items (2nd batch)', inserted_count;

END $$;
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
