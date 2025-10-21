-- Add hiragana readings to example sentences
-- Makes it easier for learners to read example sentences

DO $$
BEGIN
  -- Add example_reading column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'learning_items'
    AND column_name = 'example_reading'
  ) THEN
    ALTER TABLE learning_items ADD COLUMN example_reading TEXT;
  END IF;

  -- Update example readings for existing vocabulary

  -- Days of the Week
  UPDATE learning_items SET example_reading = 'げつようびにあいましょう。' WHERE content = '月曜日';
  UPDATE learning_items SET example_reading = 'かようびはいそがしいです。' WHERE content = '火曜日';
  UPDATE learning_items SET example_reading = 'すいようびにしけんがあります。' WHERE content = '水曜日';
  UPDATE learning_items SET example_reading = 'もくようびはやすみです。' WHERE content = '木曜日';
  UPDATE learning_items SET example_reading = 'きんようびのよるはたのしいです。' WHERE content = '金曜日';
  UPDATE learning_items SET example_reading = 'どようびにかいものします。' WHERE content = '土曜日';
  UPDATE learning_items SET example_reading = 'にちようびはかぞくとすごします。' WHERE content = '日曜日';

  -- Time of Day
  UPDATE learning_items SET example_reading = 'あさごはんをたべます。' WHERE content = '朝';
  UPDATE learning_items SET example_reading = 'ひるにともだちとあいます。' WHERE content = '昼';
  UPDATE learning_items SET example_reading = 'よるおそくかえります。' WHERE content = '夜';

  -- Food
  UPDATE learning_items SET example_reading = 'あさごはんをたべましたか。' WHERE content = 'ご飯';
  UPDATE learning_items SET example_reading = 'ぱんとこーひーがすきです。' WHERE content = 'パン';
  UPDATE learning_items SET example_reading = 'さかなをたべます。' WHERE content = '魚';
  UPDATE learning_items SET example_reading = 'にくがすきですか。' WHERE content = '肉';
  UPDATE learning_items SET example_reading = 'やさいはからだにいいです。' WHERE content = '野菜';
  UPDATE learning_items SET example_reading = 'おちゃをください。' WHERE content = 'お茶';
  UPDATE learning_items SET example_reading = 'こーひーをのみます。' WHERE content = 'コーヒー';
  UPDATE learning_items SET example_reading = 'おれんじじゅーすがすきです。' WHERE content = 'ジュース';
  UPDATE learning_items SET example_reading = 'このらーめんはおいしいです。' WHERE content = 'おいしい';
  UPDATE learning_items SET example_reading = 'このりょうりはまずいです。' WHERE content = 'まずい';

  -- Location/Direction
  UPDATE learning_items SET example_reading = 'てーぶるのうえにほんがあります。' WHERE content = '上';
  UPDATE learning_items SET example_reading = 'いすのしたにねこがいます。' WHERE content = '下';
  UPDATE learning_items SET example_reading = 'えきのまえでまってください。' WHERE content = '前';
  UPDATE learning_items SET example_reading = 'わたしのうしろにたってください。' WHERE content = '後ろ';
  UPDATE learning_items SET example_reading = 'みぎにまがってください。' WHERE content = '右';
  UPDATE learning_items SET example_reading = 'ひだりにがっこうがあります。' WHERE content = '左';
  UPDATE learning_items SET example_reading = 'へやのなかにいます。' WHERE content = '中';
  UPDATE learning_items SET example_reading = 'そとはさむいです。' WHERE content = '外';

  -- Transportation
  UPDATE learning_items SET example_reading = 'でんしゃでがっこうにいきます。' WHERE content = '電車';
  UPDATE learning_items SET example_reading = 'ばすにのります。' WHERE content = 'バス';
  UPDATE learning_items SET example_reading = 'たくしーでいきましょう。' WHERE content = 'タクシー';
  UPDATE learning_items SET example_reading = 'ひこうきでにほんにいきます。' WHERE content = '飛行機';
  UPDATE learning_items SET example_reading = 'くるまをうんてんします。' WHERE content = '車';
  UPDATE learning_items SET example_reading = 'じてんしゃにのれますか。' WHERE content = '自転車';

  -- Weather
  UPDATE learning_items SET example_reading = 'きょうのてんきはいいです。' WHERE content = '天気';
  UPDATE learning_items SET example_reading = 'あめがふっています。' WHERE content = '雨';
  UPDATE learning_items SET example_reading = 'ゆきがふりました。' WHERE content = '雪';
  UPDATE learning_items SET example_reading = 'あしたははれです。' WHERE content = '晴れ';

  -- Seasons
  UPDATE learning_items SET example_reading = 'はるはさくらがさきます。' WHERE content = '春';
  UPDATE learning_items SET example_reading = 'なつはあついです。' WHERE content = '夏';
  UPDATE learning_items SET example_reading = 'あきはすずしいです。' WHERE content = '秋';
  UPDATE learning_items SET example_reading = 'ふゆはさむいです。' WHERE content = '冬';

  -- Verbs
  UPDATE learning_items SET example_reading = 'ふくをかいます。' WHERE content = '買う';
  UPDATE learning_items SET example_reading = 'くるまをうります。' WHERE content = '売る';
  UPDATE learning_items SET example_reading = 'りょうりをつくります。' WHERE content = '作る';
  UPDATE learning_items SET example_reading = 'ぱそこんをつかいます。' WHERE content = '使う';
  UPDATE learning_items SET example_reading = 'まどをあけてください。' WHERE content = '開ける';
  UPDATE learning_items SET example_reading = 'どあをしめます。' WHERE content = '閉める';
  UPDATE learning_items SET example_reading = 'へやにはいります。' WHERE content = '入る';
  UPDATE learning_items SET example_reading = 'いえをでます。' WHERE content = '出る';

  RAISE NOTICE 'Added hiragana readings to example sentences';
END $$;
