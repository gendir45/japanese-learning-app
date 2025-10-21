# Supabase 데이터베이스 설정 가이드

이 폴더에는 Supabase 데이터베이스 마이그레이션 파일들이 포함되어 있습니다.

## 📋 마이그레이션 파일 순서

1. `01_create_learning_items.sql` - 학습 항목 테이블
2. `02_create_user_progress.sql` - 사용자 진도 테이블 (SRS 핵심)
3. `03_create_study_sessions.sql` - 학습 세션 기록
4. `04_create_user_stats.sql` - 사용자 통계 (게임화)
5. `05_create_user_badges.sql` - 배지 시스템
6. `06_setup_rls.sql` - Row Level Security 정책

## 🚀 설정 방법

### Step 1: Supabase 프로젝트 생성

1. https://supabase.com 접속
2. "New Project" 클릭
3. 프로젝트 정보 입력:
   - Name: `japanese-learning-app`
   - Database Password: 안전한 비밀번호 (저장 필수!)
   - Region: `Northeast Asia (Seoul)`
4. 프로젝트 생성 완료 대기 (약 2분)

### Step 2: API 정보 복사

1. 프로젝트 대시보드 → Settings → API로 이동
2. 다음 정보 복사:
   - `Project URL` (예: https://xxxxx.supabase.co)
   - `anon public` Key

### Step 3: 환경 변수 설정

프로젝트 루트의 `.env.local` 파일을 열고 복사한 정보 입력:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

### Step 4: SQL 마이그레이션 실행

Supabase 대시보드에서:

1. **SQL Editor** 메뉴로 이동
2. "New query" 클릭
3. 각 마이그레이션 파일의 내용을 **순서대로** 복사해서 실행:

#### 실행 순서:
```
01_create_learning_items.sql 실행 → Run
02_create_user_progress.sql 실행 → Run
03_create_study_sessions.sql 실행 → Run
04_create_user_stats.sql 실행 → Run
05_create_user_badges.sql 실행 → Run
06_setup_rls.sql 실행 → Run
```

### Step 5: 테이블 확인

1. **Table Editor** 메뉴로 이동
2. 다음 테이블들이 생성되었는지 확인:
   - ✅ learning_items
   - ✅ user_progress
   - ✅ study_sessions
   - ✅ user_stats
   - ✅ user_badges
   - ✅ badge_definitions

### Step 6: RLS 정책 확인

1. **Authentication** → **Policies** 로 이동
2. 각 테이블에 RLS 정책이 활성화되어 있는지 확인

## 📊 데이터베이스 구조

### 핵심 테이블

#### learning_items (학습 콘텐츠)
- 히라가나, 가타카나, 단어, 문법, 한자 저장
- JLPT 레벨별 분류
- 모든 사용자가 읽기 가능 (RLS)

#### user_progress (SRS 진도 추적)
- 각 사용자의 각 항목별 학습 진도
- SRS 알고리즘 파라미터 (ease_factor, interval, repetitions)
- 복습 스케줄 (next_review_at)
- 본인 데이터만 접근 가능 (RLS)

#### study_sessions (학습 기록)
- 일일 학습 세션 통계
- 스트릭 계산에 사용
- 본인 데이터만 접근 가능 (RLS)

#### user_stats (게임화 통계)
- 레벨, XP, 스트릭
- 누적 학습 통계
- 본인 데이터만 접근 가능 (RLS)

#### user_badges (배지)
- 획득한 배지 기록
- badge_definitions와 연결
- 본인 데이터만 접근 가능 (RLS)

### 유용한 함수

#### add_user_xp(user_id, xp_amount)
- XP 추가 및 자동 레벨업
- 반환: 새 레벨, 총 XP, 레벨업 여부

#### update_user_streak(user_id, study_date)
- 스트릭 업데이트
- 반환: 현재 스트릭, 최장 스트릭, 끊김 여부

#### check_and_award_badges(user_id)
- 배지 획득 조건 자동 확인 및 부여
- 반환: 새로 획득한 배지 목록

### 유용한 뷰

#### due_reviews
- 오늘 복습할 항목 목록
- `next_review_at <= NOW()` 조건

#### user_progress_stats
- 사용자별 진도 통계
- new/learning/reviewing/mastered 개수

#### daily_study_stats
- 일일 학습 통계
- 정답률, XP 등

#### weekly_study_stats
- 주간 학습 통계
- 주별 학습 일수, 총 XP

## 🔧 문제 해결

### 마이그레이션 실패 시
1. 모든 테이블 삭제 후 처음부터 다시 실행
2. SQL Editor에서 에러 메시지 확인
3. 순서대로 실행했는지 확인

### RLS 정책 문제 시
1. Authentication → Policies에서 정책 확인
2. 각 테이블에 정책이 활성화되어 있는지 확인
3. 필요 시 `06_setup_rls.sql` 재실행

### 연결 문제 시
1. `.env.local` 파일의 URL과 Key 확인
2. 프로젝트가 활성화 상태인지 확인
3. 네트워크 연결 확인

## 📝 다음 단계

1. ✅ Supabase 설정 완료
2. ⏳ 학습 데이터 준비 (히라가나 46자)
3. ⏳ 프론트엔드 UI 개발
4. ⏳ SRS 알고리즘 구현

---

**작성일**: 2025-10-19
**버전**: 1.0.0
