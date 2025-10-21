# Japanese Learning App - 프로젝트 설정

## 개발 규칙

### 에이전트 사용 정책 (필수)

개발 작업 시 다음 상황에서는 **반드시 에이전트를 사용**해야 합니다:

#### 1. 아키텍처 및 설계
- **컴포넌트 설계**: `frontend-architect` 사용
- **API/DB 설계**: `backend-architect` 사용
- **시스템 아키텍처**: `system-architect` 사용

#### 2. 코드 품질
- **보안 검토**: `security-engineer` 사용
- **성능 최적화**: `performance-engineer` 사용
- **리팩토링**: `refactoring-expert` 사용
- **테스트 전략**: `quality-engineer` 사용

#### 3. 도메인 전문성
- **일본어 학습 관련**: `/japanese-expert` 또는 적절한 도메인 에이전트
- **복잡한 비즈니스 로직**: 관련 전문 에이전트 활용

#### 4. 구현 전 필수 체크
- 복잡한 기능 구현 전 → 해당 분야 architect 에이전트 검토
- 다중 파일 변경 전 → `system-architect` 또는 `refactoring-expert` 검토
- 새로운 아키텍처 도입 전 → 관련 architect 에이전트 자문

#### 5. 병렬 실행
- 독립적인 작업은 여러 에이전트를 **동시에** 실행
- 예: 프론트엔드 + 백엔드 설계를 동시에 진행

### 에이전트 우선 원칙
```
구현 전 → 에이전트 검토 → 구현 → 에이전트 검증
```

❌ **잘못된 방식**: 바로 구현 → 문제 발생 → 수정
✅ **올바른 방식**: 에이전트 설계 → 구현 → 에이전트 검증

## 프로젝트 정보

### 기술 스택
- Next.js 15.1.4
- React 19
- TypeScript
- Supabase (인증 및 데이터베이스)

### 언어 설정
- **주 언어**: 한국어
- 모든 응답과 문서는 한국어로 작성

### 개발 명령어
- `npm run dev`: 개발 서버 시작
- `npm run build`: 프로덕션 빌드
- `npm run lint`: 코드 린트 검사

### 디렉토리 구조
```
src/
├── app/              # Next.js App Router 페이지
├── components/       # 재사용 가능한 컴포넌트
├── lib/             # 유틸리티 및 라이브러리
└── middleware.ts    # 인증 미들웨어
```
