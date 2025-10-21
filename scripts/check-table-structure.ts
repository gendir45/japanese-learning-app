/**
 * learning_items 테이블 구조 확인 스크립트
 */

import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';
import * as path from 'path';

// .env.local 파일 로드
dotenv.config({ path: path.resolve(process.cwd(), '.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkTableStructure() {
  console.log('🔍 테이블 구조 확인 중...\n');

  // 1. 테이블에 데이터가 있는지 확인 (전체)
  const { data: allData, count: totalCount, error: allError } = await supabase
    .from('learning_items')
    .select('*', { count: 'exact', head: true });

  if (allError) {
    console.error('❌ 테이블 조회 실패:', allError);
    return;
  }

  console.log(`📊 learning_items 테이블 전체 데이터: ${totalCount}개\n`);

  // 2. 샘플 데이터 1개 가져오기 (컬럼 구조 확인용)
  const { data: sampleData, error: sampleError } = await supabase
    .from('learning_items')
    .select('*')
    .limit(1);

  if (sampleError) {
    console.error('❌ 샘플 데이터 조회 실패:', sampleError);
    return;
  }

  if (sampleData && sampleData.length > 0) {
    console.log('📋 테이블 컬럼 구조:');
    console.log(Object.keys(sampleData[0]).join(', '));
    console.log('\n📝 샘플 데이터:');
    console.log(JSON.stringify(sampleData[0], null, 2));
  } else {
    console.log('⚠️  테이블이 비어있어서 구조를 확인할 수 없습니다.');
    console.log('\n💡 간단한 테스트 데이터를 삽입해볼게요...\n');

    // 테스트 데이터 삽입
    const { data: insertData, error: insertError } = await supabase
      .from('learning_items')
      .insert({
        type: 'vocabulary',
        jlpt_level: 'N5',
        content: 'テスト',
        reading: 'てすと',
        meaning: '테스트',
        category: 'test',
        subcategory: 'test',
        example_sentence: 'これはテストです。',
        example_reading: 'これはてすとです。',
        example_translation: '이것은 테스트입니다.',
        order_index: 999,
        difficulty_level: 1
      })
      .select();

    if (insertError) {
      console.error('❌ 테스트 데이터 삽입 실패:', insertError);
      console.log('\n원인:');
      console.log('- 컬럼 이름이 틀렸거나');
      console.log('- 필수 컬럼이 누락되었거나');
      console.log('- 데이터 타입이 맞지 않습니다');
    } else {
      console.log('✅ 테스트 데이터 삽입 성공!');
      console.log('삽입된 데이터:', JSON.stringify(insertData, null, 2));

      // 테스트 데이터 삭제
      await supabase
        .from('learning_items')
        .delete()
        .eq('order_index', 999);
      console.log('\n🧹 테스트 데이터 삭제 완료');
    }
  }
}

checkTableStructure().catch(console.error);
