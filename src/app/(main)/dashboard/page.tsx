import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { Card, CardHeader, CardTitle, CardDescription, CardContent, Button } from '@/components/common';
import Link from 'next/link';
import { getDashboardStats, getRecentActivity } from '@/lib/actions/study';
import { getUserStats, getTodayStats } from '@/lib/actions/gamification';
import LevelProgress from '@/components/gamification/LevelProgress';
import StreakCounter from '@/components/gamification/StreakCounter';
import TodayStats from '@/components/gamification/TodayStats';
import { ActivityHeatmap } from '@/components/dashboard/ActivityHeatmap';

/**
 * 대시보드 페이지
 * 오늘의 학습 목표, 복습 대기 항목, 학습 통계, 게임화 요소를 표시합니다.
 */
export default async function DashboardPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect('/login');
  }

  // 실제 통계 데이터 가져오기
  const stats = await getDashboardStats();

  // 게임화 데이터 가져오기
  const userStats = await getUserStats(user.id);
  const todayStats = await getTodayStats(user.id);

  // 최근 활동 데이터 가져오기
  const recentActivity = await getRecentActivity(30);

  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-8">
      {/* 헤더 */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">
          안녕하세요, {user.email?.split('@')[0]}님! 👋
        </h1>
        <p className="mt-2 text-gray-600">
          오늘도 일본어 학습을 시작해볼까요?
        </p>
      </div>

      {/* 게임화 요소 */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
        {/* 레벨 진행률 */}
        <div className="lg:col-span-2">
          <LevelProgress totalXP={userStats.total_xp} />
        </div>

        {/* 스트릭 카운터 */}
        <div>
          <StreakCounter
            currentStreak={userStats.current_streak}
            longestStreak={userStats.longest_streak}
          />
        </div>
      </div>

      {/* 오늘의 학습 통계 */}
      <div className="mb-8">
        <TodayStats
          itemsStudied={todayStats.itemsStudied}
          itemsCorrect={todayStats.itemsCorrect}
          xpEarned={todayStats.xpEarned}
          duration={todayStats.duration}
          accuracy={todayStats.accuracy}
        />
      </div>

      {/* 주요 액션 카드 */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        {/* 복습하기 */}
        <Card variant="interactive">
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle>복습하기 🔄</CardTitle>
                <CardDescription>
                  {stats.todayReviewCount}개의 카드가 복습을 기다리고 있어요
                </CardDescription>
              </div>
              <div className="text-4xl font-bold text-blue-600">
                {stats.todayReviewCount}
              </div>
            </div>
          </CardHeader>
          <CardContent>
            <Link href="/review">
              <Button variant="primary" fullWidth>
                지금 복습하기
              </Button>
            </Link>
          </CardContent>
        </Card>

        {/* 새로 학습하기 */}
        <Card variant="interactive">
          <CardHeader>
            <div className="flex items-center justify-between">
              <div>
                <CardTitle>새로 학습하기 📚</CardTitle>
                <CardDescription>
                  오늘 {stats.newItemsCount}개의 새로운 항목을 학습해보세요
                </CardDescription>
              </div>
              <div className="text-4xl font-bold text-green-600">
                {stats.newItemsCount}
              </div>
            </div>
          </CardHeader>
          <CardContent>
            <Link href="/learn">
              <Button variant="primary" fullWidth>
                학습 시작하기
              </Button>
            </Link>
          </CardContent>
        </Card>
      </div>

      {/* 통계 카드 */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* 연속 학습 */}
        <Card>
          <CardHeader>
            <CardTitle className="text-lg">연속 학습 🔥</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-4xl font-bold text-orange-600 mb-2">
              {stats.currentStreak}일
            </div>
            <p className="text-sm text-gray-600">
              대단해요! 계속 이어가보세요
            </p>
          </CardContent>
        </Card>

        {/* 마스터한 항목 */}
        <Card>
          <CardHeader>
            <CardTitle className="text-lg">마스터 완료 ✨</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-4xl font-bold text-purple-600 mb-2">
              {stats.masteredItemsCount}
            </div>
            <p className="text-sm text-gray-600">
              학습을 완료한 항목 수
            </p>
          </CardContent>
        </Card>

        {/* 정답률 */}
        <Card>
          <CardHeader>
            <CardTitle className="text-lg">정답률 📈</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-4xl font-bold text-blue-600 mb-2">
              {stats.accuracyRate}%
            </div>
            <p className="text-sm text-gray-600">
              전체 정답률
            </p>
          </CardContent>
        </Card>
      </div>

      {/* 최근 활동 */}
      <div className="mt-8">
        <Card>
          <CardHeader>
            <CardTitle>최근 활동</CardTitle>
            <CardDescription>
              최근 30일간의 학습 기록입니다
            </CardDescription>
          </CardHeader>
          <CardContent>
            <ActivityHeatmap days={recentActivity} daysToShow={30} />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
