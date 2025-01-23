<template>
  <div class="login-page">
    <div class="login-box">
      <div class="card">
        <div class="card-header text-center">
          <h1 class="h1">Sistema de Gestión</h1>
        </div>
        <div class="card-body">
          <form @submit.prevent="handleLogin">
            <div class="input-group mb-3">
              <input
                type="email"
                class="form-control"
                placeholder="Correo electrónico"
                v-model="email"
                required
              >
            </div>
            <div class="input-group mb-3">
              <input
                type="password"
                class="form-control"
                placeholder="Contraseña"
                v-model="password"
                required
              >
            </div>
            <div class="row">
              <div class="col-12">
                <button
                  type="submit"
                  class="btn btn-primary btn-block"
                  :disabled="loading"
                >
                  {{ loading ? 'Iniciando sesión...' : 'Iniciar Sesión' }}
                </button>
              </div>
            </div>
          </form>
          <p v-if="error" class="text-danger mt-3">{{ error }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// Importaciones necesarias
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/store/auth'

// Referencias reactivas
const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

// Router y store
const router = useRouter()
const authStore = useAuthStore()

// Manejar el inicio de sesión
const handleLogin = async () => {
  try {
    loading.value = true
    await authStore.login(email.value, password.value)
    router.push('/dashboard')
  } catch (err) {
    error.value = 'Credenciales inválidas'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #f4f6f9;
}

.login-box {
  width: 360px;
}
</style>