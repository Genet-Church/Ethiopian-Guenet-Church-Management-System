import { createClient } from '@supabase/supabase-js'

const supabaseUrl = "https://ugcpcfjgppuynntsskjv.supabase.co";
const supabaseAnonKey = "sb_publishable__I5hK0arHHUdhIXasEgL7A_hUJeY63e";
const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function test() {
  const { data, error } = await supabase.from('profiles').select('id, department_id').limit(1)
  console.log('Profiles Query Error:', error)
}
test()
