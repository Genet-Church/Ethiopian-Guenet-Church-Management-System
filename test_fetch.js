import { createClient } from '@supabase/supabase-js'

const supabaseUrl = "https://ugcpcfjgppuynntsskjv.supabase.co";
const supabaseAnonKey = "sb_publishable__I5hK0arHHUdhIXasEgL7A_hUJeY63e";
const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function test() {
  const { data, error } = await supabase.from('members').select('*, departments(name), churches(name)').limit(1)
  console.log('Query 1 Error:', error)
  console.log('Query 1 Data:', data)
  
  const { data: d2, error: e2 } = await supabase.from('members').select('*').limit(1)
  console.log('Query 2 Error:', e2)
  console.log('Query 2 Data:', d2)
}
test()
