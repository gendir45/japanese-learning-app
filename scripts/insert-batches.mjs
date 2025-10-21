#!/usr/bin/env node
import { createClient } from '@supabase/supabase-js'
import fs from 'fs'
import dotenv from 'dotenv'

// .env.local 로드
dotenv.config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Supabase 환경 변수가 없습니다.')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseKey)

console.log('🚀 N5 Vocabulary 배치 삽입 시작\n')
console.log('=' .repeat(60))

// SQL 파일 읽고 실행
async function executeSqlFile(filePath, batchName) {
  console.log(`\n📂 ${batchName} 처리 중...`)
  console.log(`   파일: ${filePath}`)

  if (!fs.existsSync(filePath)) {
    console.log(`⚠️  파일이 없습니다: ${filePath}`)
    return false
  }

  const sql = fs.readFileSync(filePath, 'utf-8')

  try {
    // SQL을 그대로 실행 (RPC 호출)
    const { data, error } = await supabase.rpc('exec_sql', { sql_query: sql })

    if (error) {
      console.log(`⚠️  RPC 함수가 없습니다. 대안 방법 사용...`)
      return false
    }

    console.log(`✅ ${batchName} 완료`)
    return true
  } catch (err) {
    console.log(`⚠️  ${batchName} 실행 실패:`, err.message)
    return false
  }
}

async function main() {
  const batches = [
    {
      file: 'supabase/migrations/18_insert_n5_vocabulary_batch1.sql',
      name: 'Batch 1 (1-100)',
      range: [1, 100]
    },
    {
      file: 'supabase/migrations/19_insert_n5_vocabulary_batch2.sql',
      name: 'Batch 2 (101-200)',
      range: [101, 200]
    },
    {
      file: 'supabase/migrations/20_insert_n5_vocabulary_batch_301_400.sql',
      name: 'Batch 3 (301-400)',
      range: [301, 400]
    }
  ]

  let successCount = 0

  for (const batch of batches) {
    const success = await executeSqlFile(batch.file, batch.name)
    if (success) successCount++
  }

  console.log('\n' + '='.repeat(60))

  if (successCount === 0) {
    console.log('\n⚠️  직접 SQL 실행이 불가능합니다.')
    console.log('\n📋 대안: Supabase Dashboard 사용')
    console.log('   1. https://supabase.com/dashboard 접속')
    console.log('   2. SQL Editor 열기')
    console.log('   3. 각 배치 파일 내용을 복사하여 실행')
    console.log('\n   자세한 내용: claudedocs/NEXT_STEPS.md 참고')
  } else {
    console.log(`\n🎉 ${successCount}개 배치 삽입 완료!`)

    // 검증
    console.log('\n📊 데이터 검증 중...\n')

    for (const batch of batches) {
      const { count, error } = await supabase
        .from('learning_items')
        .select('*', { count: 'exact', head: true })
        .gte('order_index', batch.range[0])
        .lte('order_index', batch.range[1])

      if (error) {
        console.log(`❌ ${batch.name} 검증 실패:`, error.message)
      } else {
        const status = count === 100 ? '✅' : count === 0 ? '❌' : '⚠️ '
        console.log(`${status} ${batch.name}: ${count}개`)
      }
    }

    // 전체 개수 확인
    const { count: totalCount } = await supabase
      .from('learning_items')
      .select('*', { count: 'exact', head: true })
      .eq('type', 'vocabulary')
      .eq('jlpt_level', 'N5')

    console.log(`\n📈 총 N5 단어 수: ${totalCount}개`)
  }
}

main().catch(console.error)
