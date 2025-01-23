<template>
  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h1 class="m-0">No Conformidades</h1>
        </div>
      </div>
    </div>
  </div>

  <div class="content">
    <div class="container-fluid">
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Registro de No Conformidades</h3>
          <div class="card-tools">
            <button class="btn btn-primary" @click="showNewNonConformityModal">
              <i class="fas fa-plus"></i> Nueva No Conformidad
            </button>
          </div>
        </div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>Código</th>
                  <th>Descripción</th>
                  <th>Tipo</th>
                  <th>Severidad</th>
                  <th>Estado</th>
                  <th>Responsable</th>
                  <th>Fecha</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="nc in nonConformities" :key="nc.id">
                  <td>{{ nc.code }}</td>
                  <td>{{ nc.description }}</td>
                  <td>{{ nc.type }}</td>
                  <td>
                    <span :class="getSeverityBadgeClass(nc.severity)">
                      {{ nc.severity }}
                    </span>
                  </td>
                  <td>
                    <span :class="getStatusBadgeClass(nc.status)">
                      {{ nc.status }}
                    </span>
                  </td>
                  <td>{{ nc.assigned_to_name }}</td>
                  <td>{{ formatDate(nc.created_at) }}</td>
                  <td>
                    <button class="btn btn-sm btn-info mr-1" @click="viewNonConformity(nc)">
                      <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn btn-sm btn-primary mr-1" @click="editNonConformity(nc)">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-danger" @click="deleteNonConformity(nc)">
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

const nonConformities = ref([]);

const getSeverityBadgeClass = (severity) => {
  const classes = {
    'critical': 'badge badge-danger',
    'major': 'badge badge-warning',
    'minor': 'badge badge-info'
  };
  return classes[severity] || 'badge badge-secondary';
};

const getStatusBadgeClass = (status) => {
  const classes = {
    'open': 'badge badge-danger',
    'in_progress': 'badge badge-warning',
    'resolved': 'badge badge-success',
    'closed': 'badge badge-secondary'
  };
  return classes[status] || 'badge badge-secondary';
};

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('es-ES');
};

const loadNonConformities = async () => {
  try {
    const { data, error } = await supabase
      .from('non_conformities')
      .select(`
        *,
        assigned_to:users(full_name)
      `)
      .order('created_at', { ascending: false });

    if (error) throw error;

    nonConformities.value = data.map(nc => ({
      ...nc,
      assigned_to_name: nc.assigned_to?.full_name
    }));
  } catch (error) {
    console.error('Error al cargar las no conformidades:', error);
  }
};

const showNewNonConformityModal = () => {
  // Implementar lógica para mostrar modal
};

const viewNonConformity = (nc) => {
  // Implementar lógica para ver no conformidad
};

const editNonConformity = (nc) => {
  // Implementar lógica para editar no conformidad
};

const deleteNonConformity = async (nc) => {
  try {
    const { error } = await supabase
      .from('non_conformities')
      .delete()
      .eq('id', nc.id);

    if (error) throw error;
    await loadNonConformities();
  } catch (error) {
    console.error('Error al eliminar la no conformidad:', error);
  }
};

onMounted(() => {
  loadNonConformities();
});
</script>