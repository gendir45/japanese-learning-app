-- 가타카나 46자에 외래어 예제 추가
-- 기존 데이터에 example_sentence, example_reading, example_translation 업데이트

-- 먼저 example_reading 컬럼이 없다면 추가
ALTER TABLE learning_items
ADD COLUMN IF NOT EXISTS example_reading TEXT;

-- ア행 (a-row) - 기본 5행 우선
UPDATE learning_items SET
  example_sentence = 'アイス',
  example_reading = 'あいす',
  example_translation = '아이스크림',
  category = 'katakana_a_row'
WHERE type = 'katakana' AND content = 'ア';

UPDATE learning_items SET
  example_sentence = 'イタリア',
  example_reading = 'いたりあ',
  example_translation = '이탈리아',
  category = 'katakana_a_row'
WHERE type = 'katakana' AND content = 'イ';

UPDATE learning_items SET
  example_sentence = 'ウイルス',
  example_reading = 'ういるす',
  example_translation = '바이러스',
  category = 'katakana_a_row'
WHERE type = 'katakana' AND content = 'ウ';

UPDATE learning_items SET
  example_sentence = 'エアコン',
  example_reading = 'えあこん',
  example_translation = '에어컨',
  category = 'katakana_a_row'
WHERE type = 'katakana' AND content = 'エ';

UPDATE learning_items SET
  example_sentence = 'オレンジ',
  example_reading = 'おれんじ',
  example_translation = '오렌지',
  category = 'katakana_a_row'
WHERE type = 'katakana' AND content = 'オ';

-- カ행 (ka-row) - 기본 5행
UPDATE learning_items SET
  example_sentence = 'カメラ',
  example_reading = 'かめら',
  example_translation = '카메라',
  category = 'katakana_ka_row'
WHERE type = 'katakana' AND content = 'カ';

UPDATE learning_items SET
  example_sentence = 'キャベツ',
  example_reading = 'きゃべつ',
  example_translation = '양배추',
  category = 'katakana_ka_row'
WHERE type = 'katakana' AND content = 'キ';

UPDATE learning_items SET
  example_sentence = 'クッキー',
  example_reading = 'くっきー',
  example_translation = '쿠키',
  category = 'katakana_ka_row'
WHERE type = 'katakana' AND content = 'ク';

UPDATE learning_items SET
  example_sentence = 'ケーキ',
  example_reading = 'けーき',
  example_translation = '케이크',
  category = 'katakana_ka_row'
WHERE type = 'katakana' AND content = 'ケ';

UPDATE learning_items SET
  example_sentence = 'コーヒー',
  example_reading = 'こーひー',
  example_translation = '커피',
  category = 'katakana_ka_row'
WHERE type = 'katakana' AND content = 'コ';

-- サ行 (sa-row) - 기본 5행 (シとソ 분리 배치 위해 난이도 조정)
UPDATE learning_items SET
  example_sentence = 'サッカー',
  example_reading = 'さっかー',
  example_translation = '축구',
  category = 'katakana_sa_row'
WHERE type = 'katakana' AND content = 'サ';

UPDATE learning_items SET
  example_sentence = 'シャツ',
  example_reading = 'しゃつ',
  example_translation = '셔츠',
  category = 'katakana_sa_row',
  notes = 'ツ와 혼동 주의: シ는 가로선이 위로 올라감'
WHERE type = 'katakana' AND content = 'シ';

UPDATE learning_items SET
  example_sentence = 'スーツ',
  example_reading = 'すーつ',
  example_translation = '정장',
  category = 'katakana_sa_row'
WHERE type = 'katakana' AND content = 'ス';

UPDATE learning_items SET
  example_sentence = 'セーター',
  example_reading = 'せーたー',
  example_translation = '스웨터',
  category = 'katakana_sa_row'
WHERE type = 'katakana' AND content = 'セ';

UPDATE learning_items SET
  example_sentence = 'ソース',
  example_reading = 'そーす',
  example_translation = '소스',
  category = 'katakana_sa_row',
  notes = 'ンと 혼동 주의: ソ는 획이 짧고 가로로 퍼짐'
WHERE type = 'katakana' AND content = 'ソ';

-- タ행 (ta-row) - 기본 5행 (ツ 분리)
UPDATE learning_items SET
  example_sentence = 'タクシー',
  example_reading = 'たくしー',
  example_translation = '택시',
  category = 'katakana_ta_row'
WHERE type = 'katakana' AND content = 'タ';

UPDATE learning_items SET
  example_sentence = 'チーズ',
  example_reading = 'ちーず',
  example_translation = '치즈',
  category = 'katakana_ta_row'
WHERE type = 'katakana' AND content = 'チ';

UPDATE learning_items SET
  example_sentence = 'ツアー',
  example_reading = 'つあー',
  example_translation = '투어',
  category = 'katakana_ta_row',
  notes = 'シ와 혼동 주의: ツ는 가로선이 아래로 내려감',
  difficulty_level = 3
WHERE type = 'katakana' AND content = 'ツ';

UPDATE learning_items SET
  example_sentence = 'テレビ',
  example_reading = 'てれび',
  example_translation = 'TV, 텔레비전',
  category = 'katakana_ta_row'
WHERE type = 'katakana' AND content = 'テ';

UPDATE learning_items SET
  example_sentence = 'トマト',
  example_reading = 'とまと',
  example_translation = '토마토',
  category = 'katakana_ta_row'
WHERE type = 'katakana' AND content = 'ト';

-- ナ행 (na-row) - 기본 5행
UPDATE learning_items SET
  example_sentence = 'ナイフ',
  example_reading = 'ないふ',
  example_translation = '나이프',
  category = 'katakana_na_row'
WHERE type = 'katakana' AND content = 'ナ';

UPDATE learning_items SET
  example_sentence = 'ニュース',
  example_reading = 'にゅーす',
  example_translation = '뉴스',
  category = 'katakana_na_row'
WHERE type = 'katakana' AND content = 'ニ';

UPDATE learning_items SET
  example_sentence = 'ヌードル',
  example_reading = 'ぬーどる',
  example_translation = '누들, 국수',
  category = 'katakana_na_row'
WHERE type = 'katakana' AND content = 'ヌ';

UPDATE learning_items SET
  example_sentence = 'ネット',
  example_reading = 'ねっと',
  example_translation = '인터넷',
  category = 'katakana_na_row'
WHERE type = 'katakana' AND content = 'ネ';

UPDATE learning_items SET
  example_sentence = 'ノート',
  example_reading = 'のーと',
  example_translation = '노트',
  category = 'katakana_na_row'
WHERE type = 'katakana' AND content = 'ノ';

-- ハ행 (ha-row)
UPDATE learning_items SET
  example_sentence = 'ハンバーガー',
  example_reading = 'はんばーがー',
  example_translation = '햄버거',
  category = 'katakana_ha_row'
WHERE type = 'katakana' AND content = 'ハ';

UPDATE learning_items SET
  example_sentence = 'ヒーター',
  example_reading = 'ひーたー',
  example_translation = '히터',
  category = 'katakana_ha_row'
WHERE type = 'katakana' AND content = 'ヒ';

UPDATE learning_items SET
  example_sentence = 'フォーク',
  example_reading = 'ふぉーく',
  example_translation = '포크',
  category = 'katakana_ha_row'
WHERE type = 'katakana' AND content = 'フ';

UPDATE learning_items SET
  example_sentence = 'ヘリコプター',
  example_reading = 'へりこぷたー',
  example_translation = '헬리콥터',
  category = 'katakana_ha_row'
WHERE type = 'katakana' AND content = 'ヘ';

UPDATE learning_items SET
  example_sentence = 'ホテル',
  example_reading = 'ほてる',
  example_translation = '호텔',
  category = 'katakana_ha_row'
WHERE type = 'katakana' AND content = 'ホ';

-- マ행 (ma-row)
UPDATE learning_items SET
  example_sentence = 'マスク',
  example_reading = 'ますく',
  example_translation = '마스크',
  category = 'katakana_ma_row'
WHERE type = 'katakana' AND content = 'マ';

UPDATE learning_items SET
  example_sentence = 'ミルク',
  example_reading = 'みるく',
  example_translation = '우유',
  category = 'katakana_ma_row'
WHERE type = 'katakana' AND content = 'ミ';

UPDATE learning_items SET
  example_sentence = 'ムービー',
  example_reading = 'むーびー',
  example_translation = '영화',
  category = 'katakana_ma_row'
WHERE type = 'katakana' AND content = 'ム';

UPDATE learning_items SET
  example_sentence = 'メニュー',
  example_reading = 'めにゅー',
  example_translation = '메뉴',
  category = 'katakana_ma_row'
WHERE type = 'katakana' AND content = 'メ';

UPDATE learning_items SET
  example_sentence = 'モニター',
  example_reading = 'もにたー',
  example_translation = '모니터',
  category = 'katakana_ma_row'
WHERE type = 'katakana' AND content = 'モ';

-- ヤ행 (ya-row)
UPDATE learning_items SET
  example_sentence = 'ヤード',
  example_reading = 'やーど',
  example_translation = '야드(단위)',
  category = 'katakana_ya_row'
WHERE type = 'katakana' AND content = 'ヤ';

UPDATE learning_items SET
  example_sentence = 'ユニフォーム',
  example_reading = 'ゆにふぉーむ',
  example_translation = '유니폼',
  category = 'katakana_ya_row'
WHERE type = 'katakana' AND content = 'ユ';

UPDATE learning_items SET
  example_sentence = 'ヨーグルト',
  example_reading = 'よーぐるとす',
  example_translation = '요구르트',
  category = 'katakana_ya_row'
WHERE type = 'katakana' AND content = 'ヨ';

-- ラ행 (ra-row)
UPDATE learning_items SET
  example_sentence = 'ラジオ',
  example_reading = 'らじお',
  example_translation = '라디오',
  category = 'katakana_ra_row'
WHERE type = 'katakana' AND content = 'ラ';

UPDATE learning_items SET
  example_sentence = 'リモコン',
  example_reading = 'りもこん',
  example_translation = '리모컨',
  category = 'katakana_ra_row'
WHERE type = 'katakana' AND content = 'リ';

UPDATE learning_items SET
  example_sentence = 'ルール',
  example_reading = 'るーる',
  example_translation = '규칙',
  category = 'katakana_ra_row'
WHERE type = 'katakana' AND content = 'ル';

UPDATE learning_items SET
  example_sentence = 'レストラン',
  example_reading = 'れすとらん',
  example_translation = '레스토랑',
  category = 'katakana_ra_row'
WHERE type = 'katakana' AND content = 'レ';

UPDATE learning_items SET
  example_sentence = 'ロボット',
  example_reading = 'ろぼっと',
  example_translation = '로봇',
  category = 'katakana_ra_row'
WHERE type = 'katakana' AND content = 'ロ';

-- ワ행 (wa-row)
UPDATE learning_items SET
  example_sentence = 'ワイン',
  example_reading = 'わいん',
  example_translation = '와인',
  category = 'katakana_wa_row'
WHERE type = 'katakana' AND content = 'ワ';

UPDATE learning_items SET
  example_sentence = 'ヲ',
  example_reading = 'を',
  example_translation = '(조사)',
  category = 'katakana_wa_row',
  notes = '거의 사용되지 않음. 조사 を의 가타카나 표기'
WHERE type = 'katakana' AND content = 'ヲ';

UPDATE learning_items SET
  example_sentence = 'レストラン',
  example_reading = 'れすとらん',
  example_translation = '레스토랑',
  category = 'katakana_wa_row',
  notes = '단어 끝에서 받침 ㄴ 소리를 표현'
WHERE type = 'katakana' AND content = 'ン';

-- 업데이트 확인
DO $$
DECLARE
  updated_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO updated_count
  FROM learning_items
  WHERE type = 'katakana' AND example_sentence IS NOT NULL;

  RAISE NOTICE '가타카나 예제 데이터 % 개 업데이트 완료', updated_count;
END $$;

-- 학습 순서 최적화 (혼동하기 쉬운 문자 분리)
-- シ/ツ, ソ/ン 등은 이미 난이도로 구분되어 있음
-- 추가 학습 팁 업데이트
UPDATE learning_items
SET notes = '혼동 주의 그룹: シ(위로), ツ(아래로)'
WHERE type = 'katakana' AND content IN ('シ', 'ツ') AND notes IS NULL;

UPDATE learning_items
SET notes = '혼동 주의 그룹: ソ(짧고 가로), ン(길고 세로)'
WHERE type = 'katakana' AND content IN ('ソ', 'ン') AND notes IS NULL;
