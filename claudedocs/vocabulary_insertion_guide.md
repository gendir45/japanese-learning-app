# N5 Vocabulary 배치 삽입 가이드

## 개요
N5 필수 단어 300개(1-100, 101-200, 301-400)를 Supabase 데이터베이스에 삽입하는 가이드입니다.

## 📁 준비된 SQL 파일
1. `supabase/migrations/18_insert_n5_vocabulary_batch1.sql` - 1-100번 단어
2. `supabase/migrations/19_insert_n5_vocabulary_batch2.sql` - 101-200번 단어
3. `supabase/migrations/20_insert_n5_vocabulary_batch_301_400.sql` - 301-400번 단어

## 🔧 삽입 방법

### 방법 1: Supabase Dashboard 사용 (권장)

1. **Supabase Dashboard 접속**
   - https://supabase.com/dashboard 로그인
   - 프로젝트 선택

2. **SQL Editor 열기**
   - 좌측 메뉴에서 "SQL Editor" 클릭
   - "New query" 버튼 클릭

3. **각 배치 파일 실행**

   **Batch 1 실행 (1-100)**
   - `supabase/migrations/18_insert_n5_vocabulary_batch1.sql` 파일 내용 복사
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭
   - 결과: "Batch 1 완료: 100 단어 추가됨 (1-100)" 메시지 확인

   **Batch 2 실행 (101-200)**
   - `supabase/migrations/19_insert_n5_vocabulary_batch2.sql` 파일 내용 복사
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭
   - 결과: "Batch 2 완료: 100 단어 추가됨 (101-200)" 메시지 확인

   **Batch 3 실행 (301-400)**
   - `supabase/migrations/20_insert_n5_vocabulary_batch_301_400.sql` 파일 내용 복사
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭
   - 결과: "Batch 3 (301-400) 완료: 100 단어 추가됨" 메시지 확인

### 방법 2: Supabase CLI 사용

```bash
# Supabase 프로젝트 연결 (처음 한 번만)
npx supabase link --project-ref YOUR_PROJECT_REF

# 마이그레이션 실행
npx supabase db push
```

### 방법 3: psql 직접 연결

```bash
# Supabase 데이터베이스에 직접 연결
psql "postgresql://postgres:[YOUR-PASSWORD]@[YOUR-PROJECT-REF].supabase.co:5432/postgres"

# 각 파일 실행
\i supabase/migrations/18_insert_n5_vocabulary_batch1.sql
\i supabase/migrations/19_insert_n5_vocabulary_batch2.sql
\i supabase/migrations/20_insert_n5_vocabulary_batch_301_400.sql
```

## ✅ 검증

### 1. 총 단어 수 확인
```sql
SELECT COUNT(*) as total_count
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5';
```
**예상 결과**: 800개

### 2. 각 배치별 확인
```sql
-- Batch 1 (1-100)
SELECT COUNT(*) FROM learning_items WHERE order_index BETWEEN 1 AND 100;

-- Batch 2 (101-200)
SELECT COUNT(*) FROM learning_items WHERE order_index BETWEEN 101 AND 200;

-- Batch 3 (301-400)
SELECT COUNT(*) FROM learning_items WHERE order_index BETWEEN 301 AND 400;

-- 기존 Batch 4-7 (401-800)
SELECT COUNT(*) FROM learning_items WHERE order_index BETWEEN 401 AND 800;
```

### 3. 범위별 단어 확인
```sql
SELECT
  CASE
    WHEN order_index BETWEEN 1 AND 100 THEN 'Batch 1 (1-100)'
    WHEN order_index BETWEEN 101 AND 200 THEN 'Batch 2 (101-200)'
    WHEN order_index BETWEEN 201 AND 300 THEN 'Batch 3 (201-300)'
    WHEN order_index BETWEEN 301 AND 400 THEN 'Batch 4 (301-400)'
    WHEN order_index BETWEEN 401 AND 500 THEN 'Batch 5 (401-500)'
    WHEN order_index BETWEEN 501 AND 600 THEN 'Batch 6 (501-600)'
    WHEN order_index BETWEEN 601 AND 700 THEN 'Batch 7 (601-700)'
    WHEN order_index BETWEEN 701 AND 800 THEN 'Batch 8 (701-800)'
    ELSE 'Other'
  END as batch,
  COUNT(*) as count
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY batch
ORDER BY batch;
```

### 4. 카테고리별 확인
```sql
SELECT category, COUNT(*) as count
FROM learning_items
WHERE type = 'vocabulary' AND jlpt_level = 'N5'
GROUP BY category
ORDER BY count DESC;
```

## 📊 예상 결과

배치 삽입 후 예상되는 데이터 구조:

| 범위 | 배치 | 단어 수 | 카테고리 |
|------|------|---------|----------|
| 1-100 | Batch 1 | 100개 | 숫자, 인사, 대명사, 기본 명사/동사 |
| 101-200 | Batch 2 | 100개 | 시간, 가족, 색상, 방향, 음식, 교통 |
| 201-300 | ❌ 미완성 | 0개 | (향후 추가 예정) |
| 301-400 | Batch 3 | 100개 | 날씨/자연, 신체, 의류, 활동, 형용사 |
| 401-500 | Batch 4 | 100개 | 형용사, 부사, 동작 동사, 장소 |
| 501-600 | Batch 5 | 100개 | 감정 형용사, 상태 동사, 의문사 |
| 601-700 | Batch 6 | 100개 | 학교, 일상생활, 날씨 |
| 701-800 | Batch 7 | 100개 | 관계, 추상 명사, 조수사 |
| **합계** | | **700개** | 201-300 범위 제외 |

> **참고**: 201-300 범위는 아직 생성되지 않았습니다. 현재 총 700개의 N5 단어가 데이터베이스에 있습니다.

## 🚨 문제 해결

### 오류: "duplicate key value violates unique constraint"
```sql
-- 해당 범위의 기존 데이터 삭제 후 재실행
DELETE FROM learning_items WHERE order_index BETWEEN 1 AND 100;
DELETE FROM learning_items WHERE order_index BETWEEN 101 AND 200;
DELETE FROM learning_items WHERE order_index BETWEEN 301 AND 400;
```

### 오류: "column does not exist"
```sql
-- example_reading 컬럼 추가 (이미 17번 마이그레이션에서 추가됨)
ALTER TABLE learning_items ADD COLUMN IF NOT EXISTS example_reading TEXT;
```

### RLS 정책 확인
```sql
-- learning_items 테이블의 RLS 정책 확인
SELECT * FROM pg_policies WHERE tablename = 'learning_items';
```

## 🎯 다음 단계

1. ✅ **Batch 1, 2, 3 삽입 완료**
2. ⏳ **검증 쿼리 실행**
3. ⏳ **배포된 사이트에서 테스트**
4. 🔜 **Batch 201-300 추가 생성** (선택사항)

## 📝 참고사항

- 각 배치는 독립적으로 실행 가능
- 실행 순서는 상관없음 (order_index로 정렬)
- 중복 실행 시 기존 데이터는 그대로 유지됨
- 각 SQL 파일은 DO 블록으로 트랜잭션 처리되어 안전함
