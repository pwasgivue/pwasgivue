<template>
  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h1 class="m-0">Dashboard</h1>
        </div>
      </div>
    </div>
  </div>

  <div class="content">
    <div class="container-fluid">
      <div class="row">
        <!-- Tarjetas de módulos -->
        <div v-for="(module, index) in modules" :key="index" class="col-lg-3 col-6">
          <router-link :to="module.route" class="small-box" :class="module.color">
            <div class="inner">
              <h3>{{ module.title }}</h3>
              <p>{{ module.description }}</p>
            </div>
            <div class="icon">
              <i :class="module.icon"></i>
            </div>
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const modules = ref([
  {
    title: 'Gestión Documental',
    description: 'Administrar documentos',
    route: '/documentos',
    icon: 'fas fa-file',
    color: 'bg-info'
  },
  {
    title: 'Control de Cambios',
    description: 'Gestionar cambios',
    route: '/cambios',
    icon: 'fas fa-exchange-alt',
    color: 'bg-success'
  },
  {
    title: 'No Conformidades',
    description: 'Registro y seguimiento',
    route: '/no-conformidades',
    icon: 'fas fa-exclamation-triangle',
    color: 'bg-warning'
  },
  {
    title: 'Auditorías',
    description: 'Planificación y ejecución',
    route: '/auditorias',
    icon: 'fas fa-clipboard-check',
    color: 'bg-danger'
  }
]);
</script>