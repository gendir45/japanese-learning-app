import { createBrowserClient } from '@supabase/ssr'
import { env } from '@/lib/env'

/**
 * 브라우저 환경에서 사용하는 Supabase 클라이언트
 * Client Components에서 사용
 */
export function createClient() {
  return createBrowserClient(
    env.NEXT_PUBLIC_SUPABASE_URL,
    env.NEXT_PUBLIC_SUPABASE_ANON_KEY
  )
}
