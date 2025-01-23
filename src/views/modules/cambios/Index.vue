<template>
  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h1 class="m-0">Control de Cambios</h1>
        </div>
      </div>
    </div>
  </div>

  <div class="content">
    <div class="container-fluid">
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Solicitudes de Cambio</h3>
          <div class="card-tools">
            <button class="btn btn-primary" @click="showNewChangeModal">
              <i class="fas fa-plus"></i> Nueva Solicitud
            </button>
          </div>
        </div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>Título</th>
                  <th>Descripción</th>
                  <th>Nivel de Impacto</th>
                  <th>Estado</th>
                  <th>Solicitante</th>
                  <th>Fecha</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="change in changes" :key="change.id">
                  <td>{{ change.title }}</td>
                  <td>{{ change.description }}</td>
                  <td>
                    <span :class="getImpactBadgeClass(change.impact_level)">
                      {{ change.impact_level }}
                    </span>
                  </td>
                  <td>
                    <span :class="getStatusBadgeClass(change.status)">
                      {{ change.status }}
                    </span>
                  </td>
                  <td>{{ change.requested_by_name }}</td>
                  <td>{{ formatDate(change.created_at) }}</td>
                  <td>
                    <button class="btn btn-sm btn-info mr-1" @click="viewChange(change)">
                      <i class="fas fa-eye"></i>
                    </button>
                    <button 
                      v-if="change.status === 'pending'"
                      class="btn btn-sm btn-success mr-1" 
                      @click="approveChange(change)"
                    >
                      <i class="fas fa-check"></i>
                    </button>
                    <button class="btn btn-sm btn-danger" @click="deleteChange(change)">
                      <i class="fas fa-trash"></i>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { supabase } from '@/supabase/client';
import { useAuthStore } from '@/store/auth';

const changes = ref([]);
const authStore = useAuthStore();

const getImpactBadgeClass = (impact) => {
  const classes = {
    'high': 'badge badge-danger',
    'medium': 'badge badge-warning',
    'low': 'badge badge-info'
  };
  return classes[impact] || 'badge badge-secondary';
};

const getStatusBadgeClass = (status) => {
  const classes = {
    'pending': 'badge badge-warning',
    'approved': 'badge badge-success',
    'rejected': 'badge badge-danger',
    'completed': 'badge badge-info'
  };
  return classes[status] || 'badge badge-secondary';
};

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('es-ES');
};

const loadChanges = async () => {
  try {
    const { data, error } = await supabase
      .from('changes')
      .select(`
        *,
        requested_by:users(full_name)
      `)
      .order('created_at', { ascending: false });

    if (error) throw error;

    changes.value = data.map(change => ({
      ...change,
      requested_by_name: change.requested_by?.full_name
    }));
  } catch (error) {
    console.error('Error al cargar los cambios:', error);
  }
};

const showNewChangeModal = () => {
  // Implementar lógica para mostrar modal
};

const viewChange = (change) => {
  // Implementar lógica para ver cambio
};

const approveChange = async (change) => {
  try {
    const { error } = await supabase
      .from('changes')
      .update({ 
        status: 'approved',
        approved_by: authStore.user.id,
        updated_at: new Date()
      })
      .eq('id', change.id);

    if (error) throw error;
    await loadChanges();
  } catch (error) {
    console.error('Error al aprobar el cambio:', error);
  }
};

const deleteChange = async (change) => {
  try {
    const { error } = await supabase
      .from('changes')
      .delete()
      .eq('id', change.id);

    if (error) throw error;
    await loadChanges();
  } catch (error) {
    console.error('Error al eliminar el cambio:', error);
  }
};

onMounted(() => {
  loadChanges();
});
</script>