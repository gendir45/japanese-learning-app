-- Update vocabulary readings from romaji to hiragana
-- This makes it easier to read for learners

DO $$
BEGIN
  -- Days of the Week
  UPDATE learning_items SET reading = 'げつようび' WHERE content = '月曜日';
  UPDATE learning_items SET reading = 'かようび' WHERE content = '火曜日';
  UPDATE learning_items SET reading = 'すいようび' WHERE content = '水曜日';
  UPDATE learning_items SET reading = 'もくようび' WHERE content = '木曜日';
  UPDATE learning_items SET reading = 'きんようび' WHERE content = '金曜日';
  UPDATE learning_items SET reading = 'どようび' WHERE content = '土曜日';
  UPDATE learning_items SET reading = 'にちようび' WHERE content = '日曜日';

  -- Time of Day
  UPDATE learning_items SET reading = 'あさ' WHERE content = '朝';
  UPDATE learning_items SET reading = 'ひる' WHERE content = '昼';
  UPDATE learning_items SET reading = 'よる' WHERE content = '夜';

  -- Food
  UPDATE learning_items SET reading = 'ごはん' WHERE content = 'ご飯';
  UPDATE learning_items SET reading = 'ぱん' WHERE content = 'パン';
  UPDATE learning_items SET reading = 'さかな' WHERE content = '魚';
  UPDATE learning_items SET reading = 'にく' WHERE content = '肉';
  UPDATE learning_items SET reading = 'やさい' WHERE content = '野菜';
  UPDATE learning_items SET reading = 'おちゃ' WHERE content = 'お茶';
  UPDATE learning_items SET reading = 'こーひー' WHERE content = 'コーヒー';
  UPDATE learning_items SET reading = 'じゅーす' WHERE content = 'ジュース';
  UPDATE learning_items SET reading = 'おいしい' WHERE content = 'おいしい';
  UPDATE learning_items SET reading = 'まずい' WHERE content = 'まずい';

  -- Location/Direction
  UPDATE learning_items SET reading = 'うえ' WHERE content = '上';
  UPDATE learning_items SET reading = 'した' WHERE content = '下';
  UPDATE learning_items SET reading = 'まえ' WHERE content = '前';
  UPDATE learning_items SET reading = 'うしろ' WHERE content = '後ろ';
  UPDATE learning_items SET reading = 'みぎ' WHERE content = '右';
  UPDATE learning_items SET reading = 'ひだり' WHERE content = '左';
  UPDATE learning_items SET reading = 'なか' WHERE content = '中';
  UPDATE learning_items SET reading = 'そと' WHERE content = '外';

  -- Transportation
  UPDATE learning_items SET reading = 'でんしゃ' WHERE content = '電車';
  UPDATE learning_items SET reading = 'ばす' WHERE content = 'バス';
  UPDATE learning_items SET reading = 'たくしー' WHERE content = 'タクシー';
  UPDATE learning_items SET reading = 'ひこうき' WHERE content = '飛行機';
  UPDATE learning_items SET reading = 'くるま' WHERE content = '車';
  UPDATE learning_items SET reading = 'じてんしゃ' WHERE content = '自転車';

  -- Weather
  UPDATE learning_items SET reading = 'てんき' WHERE content = '天気';
  UPDATE learning_items SET reading = 'あめ' WHERE content = '雨';
  UPDATE learning_items SET reading = 'ゆき' WHERE content = '雪';
  UPDATE learning_items SET reading = 'はれ' WHERE content = '晴れ';

  -- Seasons
  UPDATE learning_items SET reading = 'はる' WHERE content = '春';
  UPDATE learning_items SET reading = 'なつ' WHERE content = '夏';
  UPDATE learning_items SET reading = 'あき' WHERE content = '秋';
  UPDATE learning_items SET reading = 'ふゆ' WHERE content = '冬';

  -- Verbs
  UPDATE learning_items SET reading = 'かう' WHERE content = '買う';
  UPDATE learning_items SET reading = 'うる' WHERE content = '売る';
  UPDATE learning_items SET reading = 'つくる' WHERE content = '作る';
  UPDATE learning_items SET reading = 'つかう' WHERE content = '使う';
  UPDATE learning_items SET reading = 'あける' WHERE content = '開ける';
  UPDATE learning_items SET reading = 'しめる' WHERE content = '閉める';
  UPDATE learning_items SET reading = 'はいる' WHERE content = '入る';
  UPDATE learning_items SET reading = 'でる' WHERE content = '出る';

  -- First 50 vocabulary words
  UPDATE learning_items SET reading = 'おはよう' WHERE content = 'おはよう';
  UPDATE learning_items SET reading = 'こんにちは' WHERE content = 'こんにちは';
  UPDATE learning_items SET reading = 'ありがとう' WHERE content = 'ありがとう';
  UPDATE learning_items SET reading = 'すみません' WHERE content = 'すみません';
  UPDATE learning_items SET reading = 'さようなら' WHERE content = 'さようなら';
  UPDATE learning_items SET reading = 'いち' WHERE content = '一';
  UPDATE learning_items SET reading = 'に' WHERE content = '二';
  UPDATE learning_items SET reading = 'さん' WHERE content = '三';
  UPDATE learning_items SET reading = 'し・よん' WHERE content = '四';
  UPDATE learning_items SET reading = 'ご' WHERE content = '五';
  UPDATE learning_items SET reading = 'ろく' WHERE content = '六';
  UPDATE learning_items SET reading = 'しち・なな' WHERE content = '七';
  UPDATE learning_items SET reading = 'はち' WHERE content = '八';
  UPDATE learning_items SET reading = 'きゅう・く' WHERE content = '九';
  UPDATE learning_items SET reading = 'じゅう' WHERE content = '十';
  UPDATE learning_items SET reading = 'きょう' WHERE content = '今日';
  UPDATE learning_items SET reading = 'あした' WHERE content = '明日';
  UPDATE learning_items SET reading = 'きのう' WHERE content = '昨日';
  UPDATE learning_items SET reading = 'まいにち' WHERE content = '毎日';
  UPDATE learning_items SET reading = 'いま' WHERE content = '今';
  UPDATE learning_items SET reading = 'かぞく' WHERE content = '家族';
  UPDATE learning_items SET reading = 'ちち' WHERE content = '父';
  UPDATE learning_items SET reading = 'はは' WHERE content = '母';
  UPDATE learning_items SET reading = 'きょうだい' WHERE content = '兄弟';
  UPDATE learning_items SET reading = 'ともだち' WHERE content = '友達';
  UPDATE learning_items SET reading = 'がっこう' WHERE content = '学校';
  UPDATE learning_items SET reading = 'いえ' WHERE content = '家';
  UPDATE learning_items SET reading = 'みせ' WHERE content = '店';
  UPDATE learning_items SET reading = 'えき' WHERE content = '駅';
  UPDATE learning_items SET reading = 'くに' WHERE content = '国';
  UPDATE learning_items SET reading = 'たべる' WHERE content = '食べる';
  UPDATE learning_items SET reading = 'のむ' WHERE content = '飲む';
  UPDATE learning_items SET reading = 'いく' WHERE content = '行く';
  UPDATE learning_items SET reading = 'くる' WHERE content = '来る';
  UPDATE learning_items SET reading = 'みる' WHERE content = '見る';
  UPDATE learning_items SET reading = 'きく' WHERE content = '聞く';
  UPDATE learning_items SET reading = 'はなす' WHERE content = '話す';
  UPDATE learning_items SET reading = 'かく' WHERE content = '書く';
  UPDATE learning_items SET reading = 'よむ' WHERE content = '読む';
  UPDATE learning_items SET reading = 'する' WHERE content = 'する';
  UPDATE learning_items SET reading = 'おおきい' WHERE content = '大きい';
  UPDATE learning_items SET reading = 'ちいさい' WHERE content = '小さい';
  UPDATE learning_items SET reading = 'あたらしい' WHERE content = '新しい';
  UPDATE learning_items SET reading = 'ふるい' WHERE content = '古い';
  UPDATE learning_items SET reading = 'すき' WHERE content = '好き';
  UPDATE learning_items SET reading = 'ひと' WHERE content = '人';
  UPDATE learning_items SET reading = 'じかん' WHERE content = '時間';
  UPDATE learning_items SET reading = 'ほん' WHERE content = '本';
  UPDATE learning_items SET reading = 'みず' WHERE content = '水';
  UPDATE learning_items SET reading = 'にほんご' WHERE content = '日本語';

  RAISE NOTICE 'Updated all vocabulary readings to hiragana';
END $$;
