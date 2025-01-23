<template>
  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h1 class="m-0">Configuración</h1>
        </div>
      </div>
    </div>
  </div>

  <div class="content">
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-6">
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Configuración General</h3>
            </div>
            <div class="card-body">
              <form @submit.prevent="saveGeneralSettings">
                <div class="form-group">
                  <label>Nombre de la Organización</label>
                  <input
                    v-model="settings.organizationName"
                    type="text"
                    class="form-control"
                    required
                  >
                </div>
                <div class="form-group">
                  <label>Correo de Contacto</label>
                  <input
                    v-model="settings.contactEmail"
                    type="email"
                    class="form-control"
                    required
                  >
                </div>
                <div class="form-group">
                  <label>Zona Horaria</label>
                  <select v-model="settings.timezone" class="form-control">
                    <option value="America/Mexico_City">Ciudad de México</option>
                    <option value="America/Bogota">Bogotá</option>
                    <option value="America/Lima">Lima</option>
                    <option value="America/Santiago">Santiago</option>
                  </select>
                </div>
                <button type="submit" class="btn btn-primary">
                  Guardar Cambios
                </button>
              </form>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Notificaciones</h3>
            </div>
            <div class="card-body">
              <form @submit.prevent="saveNotificationSettings">
                <div class="form-group">
                  <div class="custom-control custom-switch">
                    <input
                      type="checkbox"
                      class="custom-control-input"
                      id="emailNotifications"
                      v-model="settings.emailNotifications"
                    >
                    <label class="custom-control-label" for="emailNotifications">
                      Notificaciones por Correo
                    </label>
                  </div>
                </div>
                <div class="form-group">
                  <div class="custom-control custom-switch">
                    <input
                      type="checkbox"
                      class="custom-control-input"
                      id="documentAlerts"
                      v-model="settings.documentAlerts"
                    >
                    <label class="custom-control-label" for="documentAlerts">
                      Alertas de Documentos
                    </label>
                  </div>
                </div>
                <div class="form-group">
                  <div class="custom-control custom-switch">
                    <input
                      type="checkbox"
                      class="custom-control-input"
                      id="auditReminders"
                      v-model="settings.auditReminders"
                    >
                    <label class="custom-control-label" for="auditReminders">
                      Recordatorios de Auditorías
                    </label>
                  </div>
                </div>
                <button type="submit" class="btn btn-primary">
                  Guardar Preferencias
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { supabase } from '@/supabase/client';

const settings = ref({
  organizationName: '',
  contactEmail: '',
  timezone: 'America/Mexico_City',
  emailNotifications: true,
  documentAlerts: true,
  auditReminders: true
});

const loadSettings = async () => {
  try {
    const { data, error } = await supabase
      .from('settings')
      .select('*');

    if (error) throw error;

    if (data && data.length > 0) {
      data.forEach(setting => {
        if (setting.key in settings.value) {
          settings.value[setting.key] = setting.value;
        }
      });
    }
  } catch (error) {
    console.error('Error al cargar la configuración:', error);
  }
};

const saveGeneralSettings = async () => {
  try {
    const { error } = await supabase
      .from('settings')
      .upsert([
        {
          key: 'organizationName',
          value: settings.value.organizationName,
          description: 'Nombre de la organización'
        },
        {
          key: 'contactEmail',
          value: settings.value.contactEmail,
          description: 'Correo de contacto principal'
        },
        {
          key: 'timezone',
          value: settings.value.timezone,
          description: 'Zona horaria del sistema'
        }
      ]);

    if (error) throw error;
    alert('Configuración guardada exitosamente');
  } catch (error) {
    console.error('Error al guardar la configuración:', error);
    alert('Error al guardar la configuración');
  }
};

const saveNotificationSettings = async () => {
  try {
    const { error } = await supabase
      .from('settings')
      .upsert([
        {
          key: 'notifications',
          value: {
            email: settings.value.emailNotifications,
            documents: settings.value.documentAlerts,
            audits: settings.value.auditReminders
          },
          description: 'Configuración de notificaciones'
        }
      ]);

    if (error) throw error;
    alert('Preferencias de notificación guardadas exitosamente');
  } catch (error) {
    console.error('Error al guardar las preferencias:', error);
    alert('Error al guardar las preferencias');
  }
};

onMounted(() => {
  loadSettings();
});
</script>