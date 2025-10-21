import { ReactNode } from 'react';
import { createClient } from '@/lib/supabase/server';
import { MainLayout } from '@/components/layout';

interface MainGroupLayoutProps {
  children: ReactNode;
}

/**
 * 메인 라우트 그룹 레이아웃
 * 인증된 사용자를 위한 페이지들 (dashboard, learn, review, progress)
 */
export default async function MainGroupLayout({ children }: MainGroupLayoutProps) {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  return <MainLayout user={user}>{children}</MainLayout>;
}
