import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkData() {
  console.log('🔍 데이터베이스 확인 중...\n');

  // 1. learning_items 테이블 확인
  const { data: items, error: itemsError } = await supabase
    .from('learning_items')
    .select('*')
    .limit(10);

  if (itemsError) {
    console.error('❌ learning_items 조회 실패:', itemsError);
    return;
  }

  console.log(`📚 learning_items: ${items?.length || 0}개`);
  if (items && items.length > 0) {
    console.log('  첫 3개 항목:');
    items.slice(0, 3).forEach((item, i) => {
      console.log(`    ${i + 1}. [${item.type}] ${item.content} - ${item.meaning}`);
    });
  }

  // 2. user_stats 테이블 확인
  const { data: stats, error: statsError } = await supabase
    .from('user_stats')
    .select('*')
    .limit(5);

  if (statsError) {
    console.error('❌ user_stats 조회 실패:', statsError);
  } else {
    console.log(`\n👤 user_stats: ${stats?.length || 0}개 사용자`);
  }

  // 3. study_sessions 테이블 확인
  const { data: sessions, error: sessionsError } = await supabase
    .from('study_sessions')
    .select('*')
    .limit(5);

  if (sessionsError) {
    console.error('❌ study_sessions 조회 실패:', sessionsError);
  } else {
    console.log(`📊 study_sessions: ${sessions?.length || 0}개 세션`);
  }

  console.log('\n✅ 데이터베이스 확인 완료');
}

checkData().catch(console.error);
