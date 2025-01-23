// Store de autenticación usando Pinia
import { defineStore } from 'pinia'
import { supabase } from '../supabase/client'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    loading: false,
    error: null
  }),

  actions: {
    // Iniciar sesión
    async login(email, password) {
      try {
        this.loading = true
        const { data, error } = await supabase.auth.signInWithPassword({
          email,
          password
        })
        if (error) throw error
        this.user = data.user
        return data
      } catch (error) {
        this.error = error.message
        throw error
      } finally {
        this.loading = false
      }
    },

    // Cerrar sesión
    async logout() {
      try {
        const { error } = await supabase.auth.signOut()
        if (error) throw error
        this.user = null
      } catch (error) {
        this.error = error.message
        throw error
      }
    }
  }
})