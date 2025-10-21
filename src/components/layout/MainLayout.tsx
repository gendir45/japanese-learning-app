import { ReactNode } from 'react';
import { Navigation } from './Navigation';
import type { User } from '@supabase/supabase-js';

interface MainLayoutProps {
  children: ReactNode;
  user: User | null;
}

/**
 * 메인 레이아웃 컴포넌트
 * 네비게이션과 푸터를 포함합니다.
 */
export function MainLayout({ children, user }: MainLayoutProps) {
  return (
    <div className="min-h-screen flex flex-col bg-gray-50">
      <Navigation user={user} />

      <main className="flex-1">
        {children}
      </main>

      <footer className="border-t border-gray-200 bg-white py-6">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4 text-sm text-gray-600">
            <div className="flex items-center gap-2">
              <span className="text-xl">🇯🇵</span>
              <span>© 2025 Japanese Learning App. All rights reserved.</span>
            </div>

            <div className="flex items-center gap-6">
              <a
                href="#"
                className="hover:text-blue-600 transition-colors"
              >
                사용 가이드
              </a>
              <a
                href="#"
                className="hover:text-blue-600 transition-colors"
              >
                문의하기
              </a>
              <a
                href="#"
                className="hover:text-blue-600 transition-colors"
              >
                개인정보처리방침
              </a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
