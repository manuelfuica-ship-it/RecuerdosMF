-- Migración para agregar cifrado end-to-end
-- Ejecutar en Supabase SQL Editor

-- Agregar columna contraseña_iv si no existe
ALTER TABLE passwords
ADD COLUMN IF NOT EXISTS contraseña_iv TEXT;

-- Crear índice para mejorar búsquedas
CREATE INDEX IF NOT EXISTS idx_passwords_user_created
ON passwords(user_id, created_at DESC);
