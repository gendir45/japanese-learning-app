import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';

/**
 * 로그아웃 Route Handler
 * POST 요청을 처리합니다
 */
export async function POST(request: NextRequest) {
  const supabase = await createClient();

  // 로그아웃
  await supabase.auth.signOut();

  // 로그인 페이지로 리디렉션
  return NextResponse.redirect(new URL('/login', request.url));
}
