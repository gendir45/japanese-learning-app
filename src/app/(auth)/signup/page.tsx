import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { SignupForm } from '@/components/auth/SignupForm';
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from '@/components/common';
import Link from 'next/link';

/**
 * 회원가입 페이지
 */
export default async function SignupPage() {
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
        <CardTitle className="text-center">회원가입</CardTitle>
        <CardDescription className="text-center">
          일본어 학습을 시작하려면 계정을 만드세요
        </CardDescription>
      </CardHeader>
      <CardContent>
        <SignupForm />

        <div className="mt-6 text-center text-sm text-gray-600">
          이미 계정이 있으신가요?{' '}
          <Link
            href="/login"
            className="font-medium text-blue-600 hover:text-blue-700"
          >
            로그인
          </Link>
        </div>
      </CardContent>
    </Card>
  );
}
