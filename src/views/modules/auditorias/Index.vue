<template>
  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h1 class="m-0">Auditorías</h1>
        </div>
      </div>
    </div>
  </div>

  <div class="content">
    <div class="container-fluid">
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Programa de Auditorías</h3>
          <div class="card-tools">
            <button class="btn btn-primary" @click="showNewAuditModal">
              <i class="fas fa-plus"></i> Nueva Auditoría
            </button>
          </div>
        </div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>Título</th>
                  <th>Alcance</th>
                  <th>Tipo</th>
                  <th>Estado</th>
                  <th>Fecha Inicio</th>
                  <th>Fecha Fin</th>
                  <th>Auditor</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="audit in audits" :key="audit.id">
                  <td>{{ audit.title }}</td>
                  <td>{{ audit.scope }}</td>
                  <td>{{ audit.type }}</td>
                  <td>
                    <span :class="getStatusBadgeClass(audit.status)">
                      {{ audit.status }}
                    </span>
                  </td>
                  <td>{{ formatDate(audit.start_date) }}</td>
                  <td>{{ formatDate(audit.end_date) }}</td>
                  <td>{{ audit.auditor_name }}</td>
                  <td>
                    <button class="btn btn-sm btn-info mr-1" @click="viewAudit(audit)">
                      <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn btn-sm btn-primary mr-1" @click="editAudit(audit)">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-danger" @click="deleteAudit(audit)">
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

const audits = ref([]);

const getStatusBadgeClass = (status) => {
  const classes = {
    'planned': 'badge badge-info',
    'in_progress': 'badge badge-warning',
    'completed': 'badge badge-success',
    'cancelled': 'badge badge-danger'
  };
  return classes[status] || 'badge badge-secondary';
};

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('es-ES');
};

const loadAudits = async () => {
  try {
    const { data, error } = await supabase
      .from('audits')
      .select(`
        *,
        auditor:users(full_name)
      `)
      .order('start_date', { ascending: true });

    if (error) throw error;

    audits.value = data.map(audit => ({
      ...audit,
      auditor_name: audit.auditor?.full_name
    }));
  } catch (error) {
    console.error('Error al cargar las auditorías:', error);
  }
};

const showNewAuditModal = () => {
  // Implementar lógica para mostrar modal
};

const viewAudit = (audit) => {
  // Implementar lógica para ver auditoría
};

const editAudit = (audit) => {
  // Implementar lógica para editar auditoría
};

const deleteAudit = async (audit) => {
  try {
    const { error } = await supabase
      .from('audits')
      .delete()
      .eq('id', audit.id);

    if (error) throw error;
    await loadAudits();
  } catch (error) {
    console.error('Error al eliminar la auditoría:', error);
  }
};

onMounted(() => {
  loadAudits();
});
</script>