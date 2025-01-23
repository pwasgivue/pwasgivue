// Configuración del cliente Supabase
import { createClient } from '@supabase/supabase-js'

// Constantes de conexión a Supabase
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_KEY

// Crear y exportar el cliente de Supabase
export const supabase = createClient(supabaseUrl, supabaseKey)

// Función para verificar la conexión
export const checkConnection = async () => {
  try {
    const { data, error } = await supabase.from('users').select('count').single()
    if (error) throw error
    console.log('Conexión a Supabase exitosa')
    return true
  } catch (error) {
    console.error('Error de conexión a Supabase:', error.message)
    return false
  }
}