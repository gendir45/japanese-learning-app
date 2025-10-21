# N5 Vocabulary 데이터 삽입 가이드

## 🎯 목표
N5 필수 단어 300개를 Supabase 데이터베이스에 삽입합니다.
- Batch 1 (1-100): 숫자, 인사, 대명사, 기본 명사/동사
- Batch 2 (101-200): 시간, 가족, 색상, 방향, 음식, 교통
- Batch 3 (301-400): 날씨/자연, 신체, 의류, 활동, 형용사

## ⚡ 빠른 시작 (3단계)

### 1단계: Supabase Dashboard 접속

```
https://supabase.com/dashboard
```

1. 로그인
2. **Japanese Learning App** 프로젝트 클릭
3. 좌측 메뉴에서 **SQL Editor** 클릭
4. **New query** 버튼 클릭

---

### 2단계: SQL 파일 실행 (3번 반복)

#### 📝 Batch 1 실행

1. 파일 열기: `supabase/migrations/18_insert_n5_vocabulary_batch1.sql`
2. 전체 선택: **Ctrl+A**
3. 복사: **Ctrl+C**
4. Supabase SQL Editor에 붙여넣기: **Ctrl+V**
5. **Run** 버튼 클릭 ▶️
6. ✅ 성공 확인

#### 📝 Batch 2 실행

1. 파일 열기: `supabase/migrations/19_insert_n5_vocabulary_batch2.sql`
2. 전체 선택: **Ctrl+A**
3. 복사: **Ctrl+C**
4. Supabase SQL Editor에 붙여넣기: **Ctrl+V**
5. **Run** 버튼 클릭 ▶️
6. ✅ 성공 확인

#### 📝 Batch 3 실행

1. 파일 열기: `supabase/migrations/20_insert_n5_vocabulary_batch_301_400.sql`
2. 전체 선택: **Ctrl+A**
3. 복사: **Ctrl+C**
4. Supabase SQL Editor에 붙여넣기: **Ctrl+V**
5. **Run** 버튼 클릭 ▶️
6. ✅ 성공 확인

---

### 3단계: 검증

Supabase SQL Editor에서 다음 쿼리 실행:

```sql
-- 총 N5 단어 수 확인
SELECT COUNT(*) as total_words
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5';
```

**예상 결과**: 700개 (기존 400개 + 신규 300개)

```sql
-- 배치별 확인
SELECT
  CASE
    WHEN order_index BETWEEN 1 AND 100 THEN 'Batch 1'
    WHEN order_index BETWEEN 101 AND 200 THEN 'Batch 2'
    WHEN order_index BETWEEN 301 AND 400 THEN 'Batch 3'
    WHEN order_index BETWEEN 401 AND 500 THEN 'Batch 4'
    WHEN order_index BETWEEN 501 AND 600 THEN 'Batch 5'
    WHEN order_index BETWEEN 601 AND 700 THEN 'Batch 6'
    WHEN order_index BETWEEN 701 AND 800 THEN 'Batch 7'
  END as batch_name,
  COUNT(*) as word_count
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY batch_name
ORDER BY MIN(order_index);
```

**예상 결과**: 각 배치 100개씩

---

## 🌐 배포된 사이트에서 테스트

1. 접속: https://japanese-learning-app.vercel.app
2. 로그인
3. **학습하기** 클릭
4. 단어 카드 확인:
   - ✅ 단어가 표시되는지
   - ✅ 읽기가 정확한지
   - ✅ 예문이 올바른지
   - ✅ 번역이 맞는지

---

## 📊 최종 데이터 구조

삽입 완료 후:

| 범위 | 상태 | 단어 수 | 카테고리 |
|------|------|---------|----------|
| 1-100 | ✅ 신규 | 100 | 숫자, 인사, 대명사, 기본 명사/동사 |
| 101-200 | ✅ 신규 | 100 | 시간, 가족, 색상, 방향, 음식, 교통 |
| 201-300 | ❌ 없음 | 0 | (미생성) |
| 301-400 | ✅ 신규 | 100 | 날씨/자연, 신체, 의류, 활동, 형용사 |
| 401-500 | ✅ 기존 | 100 | 형용사, 부사, 동작 동사, 장소 |
| 501-600 | ✅ 기존 | 100 | 감정 형용사, 상태 동사, 의문사 |
| 601-700 | ✅ 기존 | 100 | 학교, 일상생활, 날씨 |
| 701-800 | ✅ 기존 | 100 | 관계, 추상 명사, 조수사 |
| **총계** | | **700** | |

---

## 🚨 문제 해결

### ❌ "duplicate key" 오류 발생 시

```sql
-- 해당 범위 삭제 후 재실행
DELETE FROM learning_items WHERE order_index BETWEEN 1 AND 100;
-- 그 다음 Batch 1 SQL 다시 실행
```

### ❌ "column does not exist" 오류 시

```sql
-- example_reading 컬럼 추가
ALTER TABLE learning_items
ADD COLUMN IF NOT EXISTS example_reading TEXT;
```

### ⚠️ 일부만 삽입된 경우

각 배치별로 개수 확인:

```sql
SELECT COUNT(*) FROM learning_items WHERE order_index BETWEEN 1 AND 100;
-- 100이 아니면 삭제 후 재실행
DELETE FROM learning_items WHERE order_index BETWEEN 1 AND 100;
```

---

## ✅ 완료 체크리스트

- [ ] Batch 1 SQL 실행 (1-100번 단어)
- [ ] Batch 2 SQL 실행 (101-200번 단어)
- [ ] Batch 3 SQL 실행 (301-400번 단어)
- [ ] 총 단어 수 700개 확인
- [ ] 배치별 100개씩 확인
- [ ] 배포 사이트에서 학습 테스트
- [ ] 단어 카드 정상 표시 확인
- [ ] 진도 저장 확인

---

## 📚 추가 리소스

- 상세 가이드: `claudedocs/NEXT_STEPS.md`
- 검증 쿼리: `supabase/verify_vocabulary.sql`
- 삽입 가이드: `claudedocs/vocabulary_insertion_guide.md`

---

## 🎉 완료 후

N5 단어 700개가 데이터베이스에 성공적으로 저장되면, 사용자들은 다음을 경험할 수 있습니다:

- ✨ **풍부한 학습 콘텐츠**: 700개의 체계적인 N5 단어
- 📈 **체계적인 진도 관리**: SRS 알고리즘 기반 학습
- 🎯 **카테고리별 학습**: 주제별로 구조화된 단어
- 💪 **효과적인 암기**: 예문과 번역이 포함된 실용적 학습

**수고하셨습니다!** 🎊
