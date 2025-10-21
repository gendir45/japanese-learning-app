import Link from 'next/link'
import { getUser } from '@/lib/auth/actions'
import { redirect } from 'next/navigation'

export default async function Home() {
  const user = await getUser()

  // 이미 로그인된 사용자는 대시보드로 리디렉션
  if (user) {
    redirect('/dashboard')
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-blue-950 dark:to-indigo-950">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h1 className="text-5xl font-bold text-gray-900 dark:text-white mb-6">
          일본어 학습 앱
        </h1>
        <p className="text-xl text-gray-700 dark:text-gray-200 mb-8">
          JLPT 합격과 일본 여행 회화를 위한 체계적인 학습 시스템
        </p>

        <div className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
          <Link
            href="/signup"
            className="px-8 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 dark:bg-blue-600 dark:hover:bg-blue-700 transition-colors shadow-md"
          >
            시작하기
          </Link>
          <Link
            href="/login"
            className="px-8 py-3 bg-white text-blue-600 rounded-lg font-medium border-2 border-blue-600 hover:bg-blue-50 dark:bg-blue-900/30 dark:text-blue-300 dark:border-blue-500 dark:hover:bg-blue-900/50 transition-colors shadow-md"
          >
            로그인
          </Link>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-16">
          <div className="bg-white dark:bg-blue-900/20 backdrop-blur-sm p-6 rounded-lg shadow-lg border border-blue-100 dark:border-blue-800">
            <div className="text-4xl mb-4">📚</div>
            <h3 className="text-lg font-semibold mb-2 text-gray-900 dark:text-blue-100">체계적 커리큘럼</h3>
            <p className="text-gray-600 dark:text-blue-200 text-sm">
              히라가나부터 JLPT N1까지 단계별 학습
            </p>
          </div>

          <div className="bg-white dark:bg-indigo-900/20 backdrop-blur-sm p-6 rounded-lg shadow-lg border border-indigo-100 dark:border-indigo-800">
            <div className="text-4xl mb-4">🧠</div>
            <h3 className="text-lg font-semibold mb-2 text-gray-900 dark:text-indigo-100">SRS 복습 시스템</h3>
            <p className="text-gray-600 dark:text-indigo-200 text-sm">
              과학적인 복습 간격으로 효율적인 암기
            </p>
          </div>

          <div className="bg-white dark:bg-purple-900/20 backdrop-blur-sm p-6 rounded-lg shadow-lg border border-purple-100 dark:border-purple-800">
            <div className="text-4xl mb-4">🎮</div>
            <h3 className="text-lg font-semibold mb-2 text-gray-900 dark:text-purple-100">게임화 요소</h3>
            <p className="text-gray-600 dark:text-purple-200 text-sm">
              레벨, 배지, 스트릭으로 동기부여 유지
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
