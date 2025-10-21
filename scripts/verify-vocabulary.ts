/**
 * N5 Vocabulary 데이터 검증 스크립트
 *
 * Supabase에 추가된 N5 단어가 제대로 들어갔는지 확인합니다.
 */

import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';
import * as path from 'path';

// .env.local 파일 로드
dotenv.config({ path: path.resolve(process.cwd(), '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

const supabase = createClient(supabaseUrl, supabaseKey);

async function verifyVocabulary() {
  console.log('🔍 N5 Vocabulary 데이터 검증 시작...\n');

  // 1. 전체 단어 개수 확인
  const { count: totalCount, error: countError } = await supabase
    .from('learning_items')
    .select('*', { count: 'exact', head: true })
    .eq('type', 'vocabulary')
    .eq('jlpt_level', 'N5');

  if (countError) {
    console.error('❌ 개수 조회 실패:', countError);
    return;
  }

  console.log(`📊 전체 N5 단어 개수: ${totalCount}개`);
  console.log(`   목표: 800개`);
  console.log(`   ${totalCount === 800 ? '✅ 목표 달성!' : '⚠️  목표 미달성'}\n`);

  // 2. order_index 범위별 개수 확인
  const ranges = [
    { name: 'Batch 1 (1-100)', min: 1, max: 100 },
    { name: 'Batch 2 (101-200)', min: 101, max: 200 },
    { name: 'Batch 3 (201-300)', min: 201, max: 300 },
    { name: 'Batch 4 (301-400)', min: 301, max: 400 },
    { name: 'Batch 4 (401-500)', min: 401, max: 500 },
    { name: 'Batch 5 (501-600)', min: 501, max: 600 },
    { name: 'Batch 6 (601-700)', min: 601, max: 700 },
    { name: 'Batch 7 (701-800)', min: 701, max: 800 },
  ];

  console.log('📦 배치별 단어 개수:');
  for (const range of ranges) {
    const { count, error } = await supabase
      .from('learning_items')
      .select('*', { count: 'exact', head: true })
      .eq('type', 'vocabulary')
      .eq('jlpt_level', 'N5')
      .gte('order_index', range.min)
      .lte('order_index', range.max);

    if (error) {
      console.error(`   ❌ ${range.name}: 조회 실패`, error);
    } else {
      console.log(`   ${count === 100 ? '✅' : '⚠️ '} ${range.name}: ${count}개`);
    }
  }

  // 3. 최근 추가된 단어 샘플 확인 (Batch 4-7에서 각 5개씩)
  console.log('\n📝 최근 추가된 단어 샘플:');

  const sampleRanges = [
    { name: 'Batch 4', min: 401, max: 405 },
    { name: 'Batch 5', min: 501, max: 505 },
    { name: 'Batch 6', min: 601, max: 605 },
    { name: 'Batch 7', min: 701, max: 705 },
  ];

  for (const range of sampleRanges) {
    const { data, error } = await supabase
      .from('learning_items')
      .select('order_index, content, reading, meaning, category')
      .eq('type', 'vocabulary')
      .eq('jlpt_level', 'N5')
      .gte('order_index', range.min)
      .lte('order_index', range.max)
      .order('order_index');

    if (error) {
      console.error(`   ❌ ${range.name}: 조회 실패`, error);
    } else {
      console.log(`\n   ${range.name} (${range.min}-${range.max}):`);
      data?.forEach((item) => {
        console.log(`   ${item.order_index}. ${item.content} (${item.reading}) - ${item.meaning} [${item.category}]`);
      });
    }
  }

  // 4. 특정 단어 검증 (Batch 7의 "言葉" - 이전에 오타가 있었던 단어)
  console.log('\n🔍 오타 수정 검증:');
  const { data: kotoba, error: kotobaError } = await supabase
    .from('learning_items')
    .select('content, reading, meaning')
    .eq('content', '言葉')
    .eq('jlpt_level', 'N5')
    .single();

  if (kotobaError) {
    console.error('   ❌ "言葉" 조회 실패:', kotobaError);
  } else {
    const isCorrect = kotoba.reading === 'ことば';
    console.log(`   ${isCorrect ? '✅' : '❌'} 言葉: ${kotoba.reading} (expected: ことば)`);
  }

  console.log('\n✅ 검증 완료!');
}

verifyVocabulary().catch(console.error);
