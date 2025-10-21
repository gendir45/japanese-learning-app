# 학습 항목 없음 오류 해결 가이드

## 문제 상황
"학습할 항목이 없습니다. 관리자에게 문의하세요." 메시지가 표시됩니다.

## 원인
데이터베이스 마이그레이션이 원격 Supabase 데이터베이스에 적용되지 않았습니다.

## 해결 방법

### 방법 1: Supabase 대시보드에서 직접 실행 (권장)

1. **Supabase 대시보드 접속**
   - https://supabase.com/dashboard 로 이동
   - 프로젝트 선택: `odvclorksivqxyostkcz`

2. **SQL Editor 열기**
   - 좌측 메뉴에서 "SQL Editor" 클릭
   - "New query" 클릭

3. **스키마 생성 (첫 번째 쿼리)**
   - `supabase/migrations/combined_schema.sql` 파일 내용 복사
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭

4. **데이터 삽입 (두 번째 쿼리)**
   - `supabase/migrations/combined_data.sql` 파일 내용 복사
   - SQL Editor에 붙여넣기
   - "Run" 버튼 클릭

### 방법 2: CLI를 통한 자동 푸시

```bash
# 1. Supabase 프로젝트 링크 (한 번만 실행)
npx supabase link --project-ref odvclorksivqxyostkcz

# 2. 마이그레이션 적용 (dry-run으로 먼저 확인)
npx supabase db push --dry-run

# 3. 실제 적용
npx supabase db push
```

## 확인 방법

### Supabase 대시보드에서 확인
1. Table Editor 열기
2. `learning_items` 테이블 선택
3. 데이터가 있는지 확인 (약 200개 항목 예상)

### 앱에서 확인
1. 브라우저 새로고침
2. "학습하기" 버튼 클릭
3. 플래시카드가 표시되는지 확인

## 예상 데이터 수
- **히라가나**: 46개
- **가타카나**: 46개
- **N5 단어**: 150개
- **총 학습 항목**: 약 242개

## 문제가 계속되면
1. 브라우저 콘솔 확인 (F12 → Console)
2. 네트워크 탭에서 API 호출 실패 확인
3. Supabase 로그 확인
