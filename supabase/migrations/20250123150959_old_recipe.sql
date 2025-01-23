/*
  # Esquema inicial del sistema de gestión integral

  1. Nuevas Tablas
    - `users` - Usuarios del sistema
    - `documents` - Documentos del sistema
    - `changes` - Control de cambios
    - `non_conformities` - No conformidades
    - `audits` - Auditorías
    - `settings` - Configuración del sistema

  2. Seguridad
    - RLS habilitado en todas las tablas
    - Políticas de acceso basadas en roles
*/

-- Tabla de usuarios (extendiendo la tabla auth.users)
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  full_name text,
  role text NOT NULL DEFAULT 'user',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own data"
  ON users FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own data"
  ON users FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- Tabla de documentos
CREATE TABLE IF NOT EXISTS documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text NOT NULL UNIQUE,
  name text NOT NULL,
  type text NOT NULL,
  content text,
  status text NOT NULL DEFAULT 'draft',
  version integer DEFAULT 1,
  created_by uuid REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read documents"
  ON documents FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create documents"
  ON documents FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = created_by);

-- Tabla de control de cambios
CREATE TABLE IF NOT EXISTS changes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  impact_level text NOT NULL,
  requested_by uuid REFERENCES users(id),
  approved_by uuid REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE changes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read changes"
  ON changes FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create changes"
  ON changes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = requested_by);

-- Tabla de no conformidades
CREATE TABLE IF NOT EXISTS non_conformities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text NOT NULL UNIQUE,
  description text NOT NULL,
  type text NOT NULL,
  status text NOT NULL DEFAULT 'open',
  severity text NOT NULL,
  reported_by uuid REFERENCES users(id),
  assigned_to uuid REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE non_conformities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read non conformities"
  ON non_conformities FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create non conformities"
  ON non_conformities FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = reported_by);

-- Tabla de auditorías
CREATE TABLE IF NOT EXISTS audits (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  scope text NOT NULL,
  type text NOT NULL,
  status text NOT NULL DEFAULT 'planned',
  start_date date NOT NULL,
  end_date date NOT NULL,
  auditor_id uuid REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE audits ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read audits"
  ON audits FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create audits"
  ON audits FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = auditor_id);

-- Tabla de configuración
CREATE TABLE IF NOT EXISTS settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text NOT NULL UNIQUE,
  value jsonb NOT NULL,
  description text,
  updated_by uuid REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read settings"
  ON settings FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Only admins can modify settings"
  ON settings FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM users
    WHERE users.id = auth.uid()
    AND users.role = 'admin'
  ));