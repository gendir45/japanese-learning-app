# ease_factor NULL 에러 해결 가이드

## 문제
`null value in column "ease_factor" of relation "user_progress" violates not-null constraint`

## 원인
이전 코드 버전에서 `ease_factor`가 NULL로 저장된 데이터가 있습니다.

## 해결 방법

### 방법 1: 잘못된 데이터 삭제 (권장)

Supabase SQL Editor에서 실행:

```sql
-- ease_factor가 NULL인 모든 레코드 삭제
DELETE FROM user_progress WHERE ease_factor IS NULL;
```

### 방법 2: 특정 사용자의 진도만 초기화

```sql
-- 현재 사용자의 진도 초기화
DELETE FROM user_progress
WHERE user_id = (
  SELECT id FROM auth.users
  WHERE email = '사용자이메일@example.com'
);
```

### 방법 3: 모든 사용자 진도 초기화 (테스트 환경)

```sql
-- 모든 사용자의 진도 초기화 (주의!)
TRUNCATE user_progress;
```

### 방법 4: NULL 값을 기본값으로 업데이트

```sql
-- NULL 값을 기본값 2.5로 업데이트
UPDATE user_progress
SET ease_factor = 2.5
WHERE ease_factor IS NULL;
```

## 실행 후 확인

```sql
-- ease_factor가 NULL인 레코드가 없는지 확인
SELECT COUNT(*) FROM user_progress WHERE ease_factor IS NULL;
-- 결과: 0이어야 함
```

## 이후 예방

코드가 수정되어 이제 `ease_factor`가 항상 포함됩니다:
- 신규 항목: `easeFactor: 2.5`
- 기존 항목: `easeFactor: existingProgress.ease_factor || 2.5`
