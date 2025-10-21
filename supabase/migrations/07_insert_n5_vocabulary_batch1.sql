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
