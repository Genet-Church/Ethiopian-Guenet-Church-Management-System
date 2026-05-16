import { createClient } from '@supabase/supabase-js'

const supabaseUrl = "https://ugcpcfjgppuynntsskjv.supabase.co";
const supabaseAnonKey = "sb_publishable__I5hK0arHHUdhIXasEgL7A_hUJeY63e";
const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function test() {
  const { data, error } = await supabase.from('members').select('count', { count: 'exact' })
  console.log('Members count anonymous:', data, error)
}
test()
