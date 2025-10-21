# 다음 단계: N5 Vocabulary 데이터 삽입

## 📋 현재 상태

✅ **완료된 작업**
- Batch 1 (1-100) SQL 파일 생성 완료
- Batch 2 (101-200) SQL 파일 생성 완료
- Batch 3 (301-400) SQL 파일 생성 완료
- 검증 SQL 쿼리 준비 완료

⏳ **다음 작업**
- Supabase에 데이터 삽입
- 데이터 검증
- 배포된 사이트에서 테스트

---

## 🎯 Step 1: Supabase Dashboard에서 SQL 실행

### 방법 A: Supabase Dashboard 사용 (가장 권장)

1. **Supabase Dashboard 접속**
   ```
   https://supabase.com/dashboard
   ```

2. **프로젝트 선택**
   - Japanese Learning App 프로젝트 클릭

3. **SQL Editor 열기**
   - 좌측 메뉴: "SQL Editor" 클릭
   - "New query" 버튼 클릭

4. **Batch 1 실행 (1-100번 단어)**
   - 파일 열기: `supabase/migrations/18_insert_n5_vocabulary_batch1.sql`
   - 전체 내용 복사 (Ctrl+A, Ctrl+C)
   - SQL Editor에 붙여넣기 (Ctrl+V)
   - "Run" 버튼 클릭 ▶️
   - ✅ 성공 메시지 확인: "Success. No rows returned"

5. **Batch 2 실행 (101-200번 단어)**
   - 파일 열기: `supabase/migrations/19_insert_n5_vocabulary_batch2.sql`
   - 전체 내용 복사
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭 ▶️
   - ✅ 성공 메시지 확인

6. **Batch 3 실행 (301-400번 단어)**
   - 파일 열기: `supabase/migrations/20_insert_n5_vocabulary_batch_301_400.sql`
   - 전체 내용 복사
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭 ▶️
   - ✅ 성공 메시지 확인

---

## 🔍 Step 2: 데이터 검증

### SQL Editor에서 검증 쿼리 실행

파일: `supabase/verify_vocabulary.sql` 내용을 SQL Editor에 복사하여 실행

**주요 확인 사항:**

1. **전체 단어 수**
   ```sql
   SELECT COUNT(*) FROM learning_items
   WHERE type = 'vocabulary' AND jlpt_level = 'N5';
   ```
   - 예상 결과: **700개** (201-300 범위 제외)

2. **배치별 단어 수**
   - Batch 1 (1-100): 100개 ✅
   - Batch 2 (101-200): 100개 ✅
   - Batch 3 (201-300): 0개 ❌ (미생성)
   - Batch 4 (301-400): 100개 ✅
   - Batch 5-8: 각 100개 ✅

3. **order_index 중복 확인**
   - 중복 없어야 함 (0개)

---

## 🌐 Step 3: 배포된 사이트에서 테스트

1. **사이트 접속**
   ```
   https://japanese-learning-app.vercel.app
   ```

2. **로그인 또는 회원가입**
   - 테스트 계정으로 로그인

3. **학습하기 클릭**
   - 메인 페이지 → "학습하기" 버튼

4. **단어 카드 확인**
   - ✅ 단어가 정상적으로 표시되는지
   - ✅ 읽기(reading)가 올바르게 나오는지
   - ✅ 예문과 번역이 정확한지
   - ✅ 카드 넘기기 동작이 부드러운지

5. **진도 확인**
   - 여러 단어 학습 후
   - ✅ XP가 정상적으로 증가하는지
   - ✅ 학습 진도가 저장되는지

---

## 📊 예상 결과

### 데이터베이스 상태

| 범위 | 배치 | 상태 | 단어 수 | 카테고리 |
|------|------|------|---------|----------|
| 1-100 | Batch 1 | ✅ 완료 | 100개 | 숫자, 인사, 대명사, 기본 명사/동사 |
| 101-200 | Batch 2 | ✅ 완료 | 100개 | 시간, 가족, 색상, 방향, 음식, 교통 |
| 201-300 | - | ❌ 없음 | 0개 | (미생성) |
| 301-400 | Batch 3 | ✅ 완료 | 100개 | 날씨/자연, 신체, 의류, 활동, 형용사 |
| 401-500 | Batch 4 | ✅ 기존 | 100개 | 형용사, 부사, 동작 동사, 장소 |
| 501-600 | Batch 5 | ✅ 기존 | 100개 | 감정 형용사, 상태 동사, 의문사 |
| 601-700 | Batch 6 | ✅ 기존 | 100개 | 학교, 일상생활, 날씨 |
| 701-800 | Batch 7 | ✅ 기존 | 100개 | 관계, 추상 명사, 조수사 |
| **총계** | | | **700개** | N5 필수 단어 |

### 학습 시스템 동작

- ✅ FlashcardDeck 컴포넌트가 700개 단어를 정상 로드
- ✅ SRS 알고리즘이 올바르게 작동
- ✅ 진도 추적 시스템 정상 작동
- ✅ XP 시스템 정상 작동

---

## 🚨 문제 해결

### 오류: "duplicate key value"
```sql
-- 해당 범위 데이터 삭제 후 재실행
DELETE FROM learning_items WHERE order_index BETWEEN 1 AND 100;
-- 그리고 해당 배치 SQL 다시 실행
```

### 오류: "column does not exist"
```sql
-- example_reading 컬럼 추가
ALTER TABLE learning_items
ADD COLUMN IF NOT EXISTS example_reading TEXT;
```

### 배치 일부만 삽입된 경우
```sql
-- 해당 범위 확인
SELECT COUNT(*) FROM learning_items
WHERE order_index BETWEEN 1 AND 100;

-- 0이면 다시 실행, 100 미만이면 삭제 후 재실행
DELETE FROM learning_items WHERE order_index BETWEEN 1 AND 100;
```

---

## 📝 추가 개선 사항 (선택)

### Batch 201-300 생성 (선택사항)
현재 201-300 범위가 비어있습니다. 추가로 100개 단어를 더 생성하려면:

```
/japanese-expert 명령어로 201-300 범위 N5 단어 100개 생성 요청
```

**카테고리 제안:**
- 건강/의료: 병원, 약, 증상 관련
- 취미/오락: 스포츠, 게임, 여가 활동
- 감정/상태: 감정 표현, 상태 형용사
- 기타 필수 단어

---

## ✅ 완료 체크리스트

- [ ] Batch 1 (1-100) SQL 실행 완료
- [ ] Batch 2 (101-200) SQL 실행 완료
- [ ] Batch 3 (301-400) SQL 실행 완료
- [ ] 검증 쿼리로 700개 단어 확인
- [ ] order_index 중복 없음 확인
- [ ] 배포된 사이트에서 학습 기능 테스트
- [ ] 단어 카드가 정상 표시되는지 확인
- [ ] 진도 저장 및 XP 증가 확인

---

## 📞 도움이 필요하면

1. **Supabase 접속 문제**
   - `.env.local` 파일에 올바른 credentials 확인
   - Supabase 프로젝트가 활성 상태인지 확인

2. **SQL 실행 오류**
   - 오류 메시지 전체를 복사하여 Claude에게 공유
   - 어떤 배치에서 문제가 발생했는지 명시

3. **학습 기능 문제**
   - 브라우저 콘솔 (F12) 에러 메시지 확인
   - 네트워크 탭에서 API 호출 상태 확인

---

**준비 완료!** 위 단계를 따라 진행하시면 N5 단어 700개가 정상적으로 삽입됩니다. 🎉
