<template>
  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h1 class="m-0">Gestión Documental</h1>
        </div>
      </div>
    </div>
  </div>

  <div class="content">
    <div class="container-fluid">
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Documentos</h3>
          <div class="card-tools">
            <button class="btn btn-primary" @click="showNewDocumentModal">
              <i class="fas fa-plus"></i> Nuevo Documento
            </button>
          </div>
        </div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered">
              <thead>
                <tr>
                  <th>Código</th>
                  <th>Nombre</th>
                  <th>Tipo</th>
                  <th>Fecha</th>
                  <th>Estado</th>
                  <th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="doc in documents" :key="doc.id">
                  <td>{{ doc.code }}</td>
                  <td>{{ doc.name }}</td>
                  <td>{{ doc.type }}</td>
                  <td>{{ doc.date }}</td>
                  <td>
                    <span :class="getStatusBadgeClass(doc.status)">
                      {{ doc.status }}
                    </span>
                  </td>
                  <td>
                    <button class="btn btn-sm btn-info mr-1" @click="viewDocument(doc)">
                      <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn btn-sm btn-primary mr-1" @click="editDocument(doc)">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-danger" @click="deleteDocument(doc)">
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
import { ref } from 'vue';

// Datos de ejemplo
const documents = ref([
  {
    id: 1,
    code: 'DOC-001',
    name: 'Procedimiento de Calidad',
    type: 'Procedimiento',
    date: '2024-01-20',
    status: 'Activo'
  }
]);

const getStatusBadgeClass = (status) => {
  const classes = {
    'Activo': 'badge badge-success',
    'Pendiente': 'badge badge-warning',
    'Archivado': 'badge badge-secondary'
  };
  return classes[status] || 'badge badge-primary';
};

const showNewDocumentModal = () => {
  // Implementar lógica para mostrar modal
};

const viewDocument = (doc) => {
  // Implementar lógica para ver documento
};

const editDocument = (doc) => {
  // Implementar lógica para editar documento
};

const deleteDocument = (doc) => {
  // Implementar lógica para eliminar documento
};
</script>