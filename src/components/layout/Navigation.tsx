'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import { Button } from '@/components/common';
import { ThemeToggle } from '@/components/theme/ThemeToggle';
import type { User } from '@supabase/supabase-js';

interface NavigationProps {
  user: User | null;
}

/**
 * 메인 네비게이션 바 컴포넌트
 * 로그인 상태에 따라 다른 메뉴를 표시합니다.
 */
export function Navigation({ user }: NavigationProps) {
  const pathname = usePathname();

  const navItems = [
    { href: '/dashboard', label: '대시보드', icon: '📊' },
    { href: '/learn', label: '학습하기', icon: '📚' },
    { href: '/review', label: '복습하기', icon: '🔄' },
    { href: '/progress', label: '진도', icon: '📈' },
  ];

  const isActive = (href: string) => pathname === href;

  return (
    <nav className="border-b border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-900 shadow-sm">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="flex h-16 items-center justify-between">
          {/* 로고 */}
          <Link
            href={user ? '/dashboard' : '/'}
            className="flex items-center gap-2 text-xl font-bold text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 transition-colors"
          >
            <span className="text-2xl">🇯🇵</span>
            <span>Japanese Learning</span>
          </Link>

          {/* 메인 메뉴 (로그인된 경우) */}
          {user && (
            <div className="hidden md:flex items-center gap-1">
              {navItems.map((item) => (
                <Link
                  key={item.href}
                  href={item.href}
                  className={cn(
                    'flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-medium transition-colors',
                    isActive(item.href)
                      ? 'bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300'
                      : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-gray-900 dark:hover:text-gray-100'
                  )}
                >
                  <span>{item.icon}</span>
                  <span>{item.label}</span>
                </Link>
              ))}
            </div>
          )}

          {/* 우측 메뉴 */}
          <div className="flex items-center gap-4">
            {/* 다크모드 토글 */}
            <ThemeToggle />

            {user ? (
              <>
                {/* 사용자 정보 */}
                <div className="hidden sm:flex items-center gap-2 text-sm">
                  <div className="h-8 w-8 rounded-full bg-blue-100 dark:bg-blue-900 flex items-center justify-center text-blue-600 dark:text-blue-300 font-semibold">
                    {user.email?.[0]?.toUpperCase() || 'U'}
                  </div>
                  <span className="text-gray-700 dark:text-gray-300">{user.email?.split('@')[0] || '사용자'}</span>
                </div>

                {/* 로그아웃 버튼 */}
                <form action="/auth/signout" method="post">
                  <Button type="submit" variant="ghost" size="sm">
                    로그아웃
                  </Button>
                </form>
              </>
            ) : (
              <>
                <Link href="/login">
                  <Button variant="ghost" size="sm">
                    로그인
                  </Button>
                </Link>
                <Link href="/signup">
                  <Button variant="primary" size="sm">
                    회원가입
                  </Button>
                </Link>
              </>
            )}
          </div>
        </div>

        {/* 모바일 메뉴 (로그인된 경우) */}
        {user && (
          <div className="md:hidden border-t border-gray-200 dark:border-gray-700 py-2">
            <div className="flex flex-col gap-1">
              {navItems.map((item) => (
                <Link
                  key={item.href}
                  href={item.href}
                  className={cn(
                    'flex items-center gap-2 rounded-lg px-4 py-2 text-sm font-medium transition-colors',
                    isActive(item.href)
                      ? 'bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300'
                      : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 hover:text-gray-900 dark:hover:text-gray-100'
                  )}
                >
                  <span>{item.icon}</span>
                  <span>{item.label}</span>
                </Link>
              ))}
            </div>
          </div>
        )}
      </div>
    </nav>
  );
}
