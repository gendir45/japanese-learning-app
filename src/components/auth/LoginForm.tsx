'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/common';
import { signIn } from '@/lib/auth/actions';

/**
 * 로그인 폼 컴포넌트
 */
export function LoginForm() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsLoading(true);
    setError(null);

    const formData = new FormData(event.currentTarget);

    try {
      console.log('🔐 로그인 시도 시작...');
      const result = await signIn(formData);
      console.log('📩 서버 응답:', result);

      if (result?.error) {
        console.error('❌ 로그인 실패:', result.error);
        setError(result.error);
        setIsLoading(false);
      } else if (result?.success) {
        console.log('✅ 로그인 성공! 대시보드로 이동...');
        // 로그인 성공 시 대시보드로 이동
        router.push('/dashboard');
        router.refresh();
      } else {
        console.error('⚠️ 예상치 못한 응답:', result);
        setError('예상치 못한 응답입니다. 다시 시도해주세요.');
        setIsLoading(false);
      }
    } catch (err) {
      console.error('💥 로그인 에러:', err);
      // 에러 객체의 전체 내용 출력
      if (err instanceof Error) {
        console.error('에러 메시지:', err.message);
        console.error('에러 스택:', err.stack);
      }
      setError('로그인 중 오류가 발생했습니다. 다시 시도해주세요.');
      setIsLoading(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {/* 에러 메시지 */}
      {error && (
        <div
          className="rounded-lg bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 p-3 text-sm text-red-800 dark:text-red-400"
          role="alert"
        >
          {error}
        </div>
      )}

      {/* 이메일 */}
      <div>
        <label
          htmlFor="email"
          className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
        >
          이메일
        </label>
        <input
          id="email"
          name="email"
          type="email"
          autoComplete="email"
          required
          className="w-full rounded-lg border border-gray-300 dark:border-gray-600 px-4 py-2 text-gray-900 dark:text-white bg-white dark:bg-gray-800 placeholder-gray-500 dark:placeholder-gray-400 focus:border-blue-500 dark:focus:border-blue-400 focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400"
          placeholder="your@email.com"
          disabled={isLoading}
        />
      </div>

      {/* 비밀번호 */}
      <div>
        <label
          htmlFor="password"
          className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1"
        >
          비밀번호
        </label>
        <input
          id="password"
          name="password"
          type="password"
          autoComplete="current-password"
          required
          className="w-full rounded-lg border border-gray-300 dark:border-gray-600 px-4 py-2 text-gray-900 dark:text-white bg-white dark:bg-gray-800 placeholder-gray-500 dark:placeholder-gray-400 focus:border-blue-500 dark:focus:border-blue-400 focus:outline-none focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400"
          placeholder="••••••••"
          disabled={isLoading}
        />
      </div>

      {/* 로그인 버튼 */}
      <Button
        type="submit"
        variant="primary"
        fullWidth
        isLoading={isLoading}
      >
        로그인
      </Button>
    </form>
  );
}
