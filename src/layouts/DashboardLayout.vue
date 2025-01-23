<template>
  <!-- Contenedor principal -->
  <div class="wrapper">
    <!-- Barra de navegación superior -->
    <nav class="main-header navbar navbar-expand navbar-white navbar-light">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" data-widget="pushmenu" href="#" role="button">
            <i class="fas fa-bars"></i>
          </a>
        </li>
      </ul>

      <!-- Menú derecho -->
      <ul class="navbar-nav ml-auto">
        <li class="nav-item dropdown">
          <a class="nav-link" data-toggle="dropdown" href="#">
            <i class="fas fa-user"></i>
          </a>
          <div class="dropdown-menu dropdown-menu-right">
            <a href="#" class="dropdown-item" @click="logout">
              <i class="fas fa-sign-out-alt mr-2"></i> Cerrar Sesión
            </a>
          </div>
        </li>
      </ul>
    </nav>

    <!-- Barra lateral -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
      <!-- Logo -->
      <router-link to="/dashboard" class="brand-link">
        <span class="brand-text font-weight-light">Sistema de Gestión</span>
      </router-link>

      <!-- Sidebar -->
      <div class="sidebar">
        <!-- Menú -->
        <nav class="mt-2">
          <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu">
            <li class="nav-item">
              <router-link to="/dashboard" class="nav-link">
                <i class="nav-icon fas fa-tachometer-alt"></i>
                <p>Dashboard</p>
              </router-link>
            </li>
            <li class="nav-item">
              <router-link to="/documentos" class="nav-link">
                <i class="nav-icon fas fa-file"></i>
                <p>Gestión Documental</p>
              </router-link>
            </li>
            <li class="nav-item">
              <router-link to="/cambios" class="nav-link">
                <i class="nav-icon fas fa-exchange-alt"></i>
                <p>Control de Cambios</p>
              </router-link>
            </li>
            <li class="nav-item">
              <router-link to="/no-conformidades" class="nav-link">
                <i class="nav-icon fas fa-exclamation-triangle"></i>
                <p>No Conformidades</p>
              </router-link>
            </li>
            <li class="nav-item">
              <router-link to="/auditorias" class="nav-link">
                <i class="nav-icon fas fa-clipboard-check"></i>
                <p>Auditorías</p>
              </router-link>
            </li>
            <li class="nav-item">
              <router-link to="/configuracion" class="nav-link">
                <i class="nav-icon fas fa-cog"></i>
                <p>Configuración</p>
              </router-link>
            </li>
          </ul>
        </nav>
      </div>
    </aside>

    <!-- Contenido principal -->
    <div class="content-wrapper">
      <router-view></router-view>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { useAuthStore } from '../store/auth';

const router = useRouter();
const authStore = useAuthStore();

const logout = async () => {
  try {
    await authStore.logout();
    router.push('/login');
  } catch (error) {
    console.error('Error al cerrar sesión:', error);
  }
};
</script>

<style>
/* Estilos adicionales si son necesarios */
</style>