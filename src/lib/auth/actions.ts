'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

/**
 * 이메일/비밀번호 회원가입
 */
export async function signUp(formData: FormData) {
  const supabase = await createClient()

  const data = {
    email: formData.get('email') as string,
    password: formData.get('password') as string,
  }

  const { data: authData, error } = await supabase.auth.signUp({
    ...data,
    options: {
      emailRedirectTo: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3001'}/auth/callback`,
      // 개발 환경: 이메일 인증 없이 바로 로그인 (Supabase 설정에서 "Enable email confirmations" 비활성화 필요)
    },
  })

  if (error) {
    return { error: error.message }
  }

  // 이메일 인증이 필요한 경우 메시지 표시
  if (authData?.user && !authData.user.email_confirmed_at) {
    return {
      error: '회원가입이 완료되었습니다. 이메일을 확인하여 인증을 완료해주세요.',
      needsEmailConfirmation: true
    }
  }

  revalidatePath('/', 'layout')
  return { success: true }
}

/**
 * 이메일/비밀번호 로그인
 */
export async function signIn(formData: FormData) {
  try {
    console.log('🔧 Server Action: signIn 시작');
    const supabase = await createClient()

    const data = {
      email: formData.get('email') as string,
      password: formData.get('password') as string,
    }

    console.log('📧 로그인 시도:', { email: data.email });

    const { error, data: authData } = await supabase.auth.signInWithPassword(data)

    if (error) {
      console.error('❌ Supabase 인증 오류:', error);
      // 에러 메시지를 한글로 변환
      let errorMessage = error.message;
      if (error.message.includes('Invalid login credentials')) {
        errorMessage = '이메일 또는 비밀번호가 올바르지 않습니다.';
      } else if (error.message.includes('Email not confirmed')) {
        errorMessage = '이메일 인증이 완료되지 않았습니다. 이메일을 확인해주세요.';
      }
      return { error: errorMessage }
    }

    console.log('✅ Supabase 인증 성공:', { userId: authData?.user?.id });

    revalidatePath('/', 'layout')
    return { success: true }
  } catch (error) {
    console.error('💥 Server Action 에러:', error);
    return { error: '서버 오류가 발생했습니다.' }
  }
}

/**
 * 로그아웃
 */
export async function signOut() {
  const supabase = await createClient()

  const { error } = await supabase.auth.signOut()

  if (error) {
    return { error: error.message }
  }

  revalidatePath('/', 'layout')
  redirect('/')
}

/**
 * 현재 로그인된 사용자 정보 가져오기
 */
export async function getUser() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  return user
}
