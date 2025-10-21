import { z } from 'zod';

/**
 * 환경 변수 스키마 정의
 * Supabase 연결에 필요한 모든 환경 변수를 검증합니다.
 */
const envSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.string().url('유효한 Supabase URL이 필요합니다'),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1, 'Supabase Anon Key가 필요합니다'),
});

/**
 * 환경 변수 타입
 */
export type Env = z.infer<typeof envSchema>;

/**
 * 환경 변수 검증 및 파싱
 *
 * @throws {Error} 필수 환경 변수가 누락되거나 유효하지 않은 경우
 * @returns 검증된 환경 변수 객체
 */
function validateEnv(): Env {
  const env = {
    NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
    NEXT_PUBLIC_SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
  };

  const parsed = envSchema.safeParse(env);

  if (!parsed.success) {
    console.error('❌ 환경 변수 검증 실패:');
    console.error(parsed.error.flatten().fieldErrors);

    throw new Error(
      '환경 변수가 올바르게 설정되지 않았습니다. .env.local 파일을 확인해주세요.'
    );
  }

  return parsed.data;
}

/**
 * 검증된 환경 변수
 * 앱 시작 시 한 번만 검증됩니다.
 */
export const env = validateEnv();
