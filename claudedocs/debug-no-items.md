# 학습 항목 없음 문제 디버깅 가이드

## 증상
- 새 계정: 학습 항목이 정상적으로 보임 ✅
- 이전 계정: "학습할 항목이 없습니다" 오류 ❌

## 가능한 원인

### 1. RLS(Row Level Security) 정책 문제
learning_items 테이블에 대한 읽기 권한이 없을 수 있습니다.

### 2. user_progress 테이블 문제
이전 계정이 모든 항목을 이미 학습했거나, 복습 시간이 아직 안 됐을 수 있습니다.

## 디버깅 단계

### 1단계: Supabase SQL Editor에서 실행

```sql
-- 전체 학습 항목 수 확인
SELECT COUNT(*) as total_items FROM learning_items;

-- 타입별 학습 항목 수
SELECT type, COUNT(*) as count
FROM learning_items
GROUP BY type;

-- RLS 정책 확인
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'learning_items';
```

### 2단계: 특정 사용자 진도 확인

이전 계정의 이메일을 여기에 적으세요: `__________________`

```sql
-- 사용자 ID 찾기 (이메일로)
SELECT id, email FROM auth.users WHERE email = 'YOUR_EMAIL@example.com';

-- 해당 사용자의 진도 확인
SELECT
  up.status,
  COUNT(*) as count,
  COUNT(*) FILTER (WHERE up.next_review_at IS NOT NULL AND up.next_review_at <= NOW()) as due_reviews
FROM user_progress up
WHERE up.user_id = 'USER_ID_HERE'
GROUP BY up.status;

-- 학습 가능한 항목 수 확인
SELECT
  COUNT(*) FILTER (WHERE up.item_id IS NULL) as new_items_available,
  COUNT(*) FILTER (WHERE up.next_review_at IS NOT NULL AND up.next_review_at <= NOW()) as review_items_due
FROM learning_items li
LEFT JOIN user_progress up ON li.id = up.item_id AND up.user_id = 'USER_ID_HERE';
```

### 3단계: 문제별 해결 방법

#### 문제 A: RLS 정책이 없거나 잘못됨
```sql
-- learning_items 읽기 권한 추가
CREATE POLICY "learning_items는 모두 읽기 가능"
  ON learning_items
  FOR SELECT
  TO authenticated
  USING (true);
```

#### 문제 B: 모든 항목을 이미 학습했고 복습 시간이 안 됨
```sql
-- 특정 사용자의 모든 진도 초기화 (주의!)
DELETE FROM user_progress WHERE user_id = 'USER_ID_HERE';
```

#### 문제 C: 학습 항목 자체가 없음
```sql
-- combined_data.sql 파일 실행
-- (이전에 제공한 파일)
```

## 임시 해결책

이전 계정 대신 새 계정을 사용하거나, 이전 계정의 진도를 초기화하세요.

## 근본 원인 파악

브라우저 콘솔(F12)에서 네트워크 탭을 열고:
1. "학습하기" 버튼 클릭
2. `/api/...` 또는 Supabase API 호출 확인
3. 응답 내용에서 에러 메시지 확인
4. 에러 메시지를 여기에 복사: `__________________`
