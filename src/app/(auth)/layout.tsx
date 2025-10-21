import { ReactNode } from 'react';
import Link from 'next/link';

interface AuthGroupLayoutProps {
  children: ReactNode;
}

/**
 * 인증 라우트 그룹 레이아웃
 * 로그인, 회원가입 페이지를 위한 레이아웃
 */
export default function AuthGroupLayout({ children }: AuthGroupLayoutProps) {
  return (
    <div className="min-h-screen flex flex-col bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-900 dark:to-gray-800">
      {/* 상단 로고 */}
      <header className="w-full py-6">
        <div className="mx-auto max-w-md px-4">
          <Link
            href="/"
            className="flex items-center justify-center gap-2 text-2xl font-bold text-blue-600 hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-300 transition-colors"
          >
            <span className="text-3xl">🇯🇵</span>
            <span>Japanese Learning</span>
          </Link>
        </div>
      </header>

      {/* 메인 콘텐츠 */}
      <main className="flex-1 flex items-center justify-center px-4 py-12">
        <div className="w-full max-w-md">
          {children}
        </div>
      </main>

      {/* 푸터 */}
      <footer className="w-full py-6">
        <div className="mx-auto max-w-md px-4 text-center text-sm text-gray-600 dark:text-gray-400">
          <p>© 2025 Japanese Learning App. All rights reserved.</p>
        </div>
      </footer>
    </div>
  );
}
