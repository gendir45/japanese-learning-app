import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { LoginForm } from '@/components/auth/LoginForm';
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from '@/components/common';
import Link from 'next/link';

/**
 * 로그인 페이지
 */
export default async function LoginPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  // 이미 로그인된 경우 대시보드로 리디렉션
  if (user) {
    redirect('/dashboard');
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-center">로그인</CardTitle>
        <CardDescription className="text-center">
          일본어 학습을 계속하려면 로그인하세요
        </CardDescription>
      </CardHeader>
      <CardContent>
        <LoginForm />

        <div className="mt-6 text-center text-sm text-gray-600">
          계정이 없으신가요?{' '}
          <Link
            href="/signup"
            className="font-medium text-blue-600 hover:text-blue-700"
          >
            회원가입
          </Link>
        </div>
      </CardContent>
    </Card>
  );
}
