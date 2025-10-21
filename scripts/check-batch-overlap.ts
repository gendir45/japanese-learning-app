/**
 * Batch 중복 확인 스크립트
 */

import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config({ path: path.resolve(process.cwd(), '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkBatchOverlap() {
  console.log('🔍 Batch 301-400 상세 조회...\n');

  const { data, error } = await supabase
    .from('learning_items')
    .select('order_index, content, reading, meaning, category')
    .gte('order_index', 301)
    .lte('order_index', 400)
    .order('order_index');

  if (error) {
    console.error('❌ 조회 실패:', error);
    return;
  }

  console.log(`📊 총 ${data.length}개 발견\n`);

  // order_index별 개수 세기
  const countByIndex: { [key: number]: number } = {};
  data.forEach(item => {
    countByIndex[item.order_index] = (countByIndex[item.order_index] || 0) + 1;
  });

  // 중복 찾기
  const duplicates = Object.entries(countByIndex).filter(([_, count]) => count > 1);

  if (duplicates.length > 0) {
    console.log('⚠️  중복된 order_index 발견:');
    duplicates.forEach(([index, count]) => {
      console.log(`   ${index}: ${count}개`);
    });
  } else {
    console.log('✅ 중복 없음');
  }

  console.log('\n📝 처음 10개 샘플:');
  data.slice(0, 10).forEach(item => {
    console.log(`   ${item.order_index}. ${item.content} (${item.reading}) - ${item.meaning}`);
  });

  console.log('\n📝 마지막 10개 샘플:');
  data.slice(-10).forEach(item => {
    console.log(`   ${item.order_index}. ${item.content} (${item.reading}) - ${item.meaning}`);
  });
}

checkBatchOverlap().catch(console.error);
