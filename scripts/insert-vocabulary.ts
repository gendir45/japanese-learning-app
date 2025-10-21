import { createClient } from '@supabase/supabase-js'
import * as fs from 'fs'
import * as path from 'path'
import * as dotenv from 'dotenv'

// .env.local 파일 로드
dotenv.config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Supabase 환경 변수가 설정되지 않았습니다.')
  console.error('NEXT_PUBLIC_SUPABASE_URL:', supabaseUrl ? '✓' : '✗')
  console.error('SUPABASE_SERVICE_ROLE_KEY or ANON_KEY:', supabaseServiceKey ? '✓' : '✗')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseServiceKey)

async function executeSqlFile(filePath: string) {
  console.log(`\n📂 파일 읽기: ${filePath}`)

  const sql = fs.readFileSync(filePath, 'utf-8')

  console.log(`📤 SQL 실행 중...`)

  try {
    const { data, error } = await supabase.rpc('exec_sql', { sql_string: sql })

    if (error) {
      // RPC 함수가 없을 수 있으므로, 직접 SQL 파싱하여 데이터 삽입
      console.log('⚠️  RPC 함수 없음. 데이터를 직접 파싱하여 삽입합니다...')
      return await insertDataDirectly(sql)
    }

    console.log('✅ SQL 실행 완료')
    return data
  } catch (err) {
    console.error('❌ SQL 실행 실패:', err)
    throw err
  }
}

// SQL에서 VALUES 구문을 파싱하여 직접 데이터 삽입
async function insertDataDirectly(sql: string): Promise<void> {
  // VALUES 이후의 데이터를 추출
  const valuesMatch = sql.match(/VALUES\s+([\s\S]+?)(?:ON CONFLICT|;|\$\$)/i)

  if (!valuesMatch) {
    console.error('❌ VALUES 구문을 찾을 수 없습니다.')
    return
  }

  const valuesString = valuesMatch[1]

  // 각 행을 파싱 (간단한 구현)
  const rows: any[] = []
  const rowMatches = valuesString.matchAll(/\(([^)]+)\)/g)

  for (const match of rowMatches) {
    const values = match[1].split(',').map(v => {
      v = v.trim()
      // 작은따옴표로 감싸진 문자열 추출
      if (v.startsWith("'")) {
        return v.slice(1, -1).replace(/''/g, "'")
      }
      // 숫자
      return parseInt(v) || v
    })

    if (values.length >= 11) {
      rows.push({
        type: values[0],
        jlpt_level: values[1],
        content: values[2],
        reading: values[3],
        meaning: values[4],
        category: values[5],
        subcategory: values[6],
        example_sentence: values[7],
        example_reading: values[8],
        example_translation: values[9],
        order_index: values[10],
        difficulty_level: values[11]
      })
    }
  }

  console.log(`📊 총 ${rows.length}개의 행을 삽입합니다...`)

  // 배치로 삽입 (100개씩)
  const batchSize = 100
  for (let i = 0; i < rows.length; i += batchSize) {
    const batch = rows.slice(i, i + batchSize)

    const { error } = await supabase
      .from('learning_items')
      .upsert(batch, { onConflict: 'order_index' })

    if (error) {
      console.error(`❌ 배치 ${i / batchSize + 1} 삽입 실패:`, error)
      throw error
    }

    console.log(`✅ 배치 ${i / batchSize + 1}/${Math.ceil(rows.length / batchSize)} 완료 (${batch.length}개 행)`)
  }

  console.log(`✅ 총 ${rows.length}개 행 삽입 완료`)
}

async function main() {
  console.log('🚀 N5 Vocabulary 배치 삽입 시작\n')
  console.log('=' .repeat(60))

  const migrationFiles = [
    'supabase/migrations/18_insert_n5_vocabulary_batch1.sql',
    'supabase/migrations/19_insert_n5_vocabulary_batch2.sql',
    'supabase/migrations/20_insert_n5_vocabulary_batch_301_400.sql'
  ]

  for (const file of migrationFiles) {
    const filePath = path.resolve(process.cwd(), file)

    if (!fs.existsSync(filePath)) {
      console.log(`⚠️  파일이 존재하지 않습니다: ${file}`)
      continue
    }

    try {
      await executeSqlFile(filePath)
    } catch (error) {
      console.error(`❌ 파일 실행 실패: ${file}`)
      console.error(error)
    }
  }

  console.log('\n' + '='.repeat(60))
  console.log('🎉 모든 배치 삽입 완료!')

  // 검증
  console.log('\n📊 데이터 검증 중...')

  const { count: totalCount } = await supabase
    .from('learning_items')
    .select('*', { count: 'exact', head: true })
    .eq('type', 'vocabulary')
    .eq('jlpt_level', 'N5')

  console.log(`총 N5 단어 수: ${totalCount}개`)

  // 각 배치별 확인
  const ranges = [
    { name: 'Batch 1', start: 1, end: 100 },
    { name: 'Batch 2', start: 101, end: 200 },
    { name: 'Batch 3', start: 301, end: 400 },
    { name: 'Batch 4', start: 401, end: 500 },
    { name: 'Batch 5', start: 501, end: 600 },
    { name: 'Batch 6', start: 601, end: 700 },
    { name: 'Batch 7', start: 701, end: 800 }
  ]

  console.log('\n배치별 단어 수:')
  for (const range of ranges) {
    const { count } = await supabase
      .from('learning_items')
      .select('*', { count: 'exact', head: true })
      .gte('order_index', range.start)
      .lte('order_index', range.end)

    const status = count === 100 ? '✅' : count === 0 ? '❌' : '⚠️ '
    console.log(`${status} ${range.name} (${range.start}-${range.end}): ${count}개`)
  }
}

main().catch(console.error)
