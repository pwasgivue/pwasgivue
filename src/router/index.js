// Configuración del router
import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../store/auth';

// Layouts
import DashboardLayout from '../layouts/DashboardLayout.vue';

// Vistas
import Login from '../views/auth/Login.vue';
import Dashboard from '../views/Dashboard.vue';

// Módulos
const DocumentosView = () => import('../views/modules/documentos/Index.vue');
const CambiosView = () => import('../views/modules/cambios/Index.vue');
const NoConformidadesView = () => import('../views/modules/no-conformidades/Index.vue');
const AuditoriasView = () => import('../views/modules/auditorias/Index.vue');
const ConfiguracionView = () => import('../views/modules/configuracion/Index.vue');

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'login',
    component: Login,
    meta: { requiresAuth: false }
  },
  {
    path: '/',
    component: DashboardLayout,
    meta: { requiresAuth: true },
    children: [
      {
        path: 'dashboard',
        name: 'dashboard',
        component: Dashboard
      },
      {
        path: 'documentos',
        name: 'documentos',
        component: DocumentosView
      },
      {
        path: 'cambios',
        name: 'cambios',
        component: CambiosView
      },
      {
        path: 'no-conformidades',
        name: 'no-conformidades',
        component: NoConformidadesView
      },
      {
        path: 'auditorias',
        name: 'auditorias',
        component: AuditoriasView
      },
      {
        path: 'configuracion',
        name: 'configuracion',
        component: ConfiguracionView
      }
    ]
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

// Guardia de navegación
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);

  if (requiresAuth && !authStore.user) {
    next('/login');
  } else if (!requiresAuth && authStore.user) {
    next('/dashboard');
  } else {
    next();
  }
});

export default router;