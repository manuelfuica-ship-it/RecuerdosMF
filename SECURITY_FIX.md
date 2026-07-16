# 🔒 Corrección de Seguridad Crítica: Encriptación End-to-End

## Problema Identificado
La versión anterior guardaba **contraseñas en texto plano** en Supabase. Esto anulaba completamente el objetivo de seguridad del gestor.

### Antes (❌ Inseguro)
```
Usuario ingresa: "miContraseña123"
→ Se guardaba en Supabase sin encriptar
→ Acceso remoto podría leer todas las contraseñas
```

## Solución Implementada (✅ Seguro)

### Arquitectura de Encriptación End-to-End

```
1. Usuario ingresa contraseña maestra (email + password en Supabase)
                    ↓
2. App deriva clave AES-256 usando PBKDF2
   - 100,000 iteraciones
   - Salt generado por sesión
                    ↓
3. Cada contraseña se encripta individualmente
   - AES-256-GCM (NIST)
   - IV único (12 bytes) por encriptación
   - Auth tag 128-bit para integridad
                    ↓
4. Solo la contraseña encriptada se guarda en Supabase
   - Hexadecimal: contraseña_encriptada
   - Hexadecimal: contraseña_iv (necesario para desencriptar)
                    ↓
5. App desencripta solo en memoria del cliente
   - Nunca se envía desencriptada a Supabase
   - Nunca se guarda en localStorage desencriptada
```

## Cambios Realizados

### 1. Funciones de Encriptación
- **`encrypt(data, key)`**: Ahora maneja strings (contraseñas) y objetos (datos)
- **`decrypt(encrypted, key)`**: Devuelve string para contraseñas, objeto para datos complejos

### 2. Guardado de Contraseñas
- `savePassword()`: Encripta antes de guardar en Supabase
- `updatePassword()`: Encripta antes de actualizar
- Guarda: `contraseña_encriptada` + `contraseña_iv`

### 3. Carga de Contraseñas
- `authenticate()`: Desencripta cada contraseña al cargar
- `loadAndRefresh()`: Desencripta en tiempo real al sincronizar
- Las contraseñas se desencriptan solo en memoria (variable `state.passwords`)

### 4. Logout Seguro
- `logout()`: Ahora llama `supabaseClient.auth.signOut()`
- Limpia `state.userId` y `state.encryptionKey`

## Cambios en Base de Datos

Ejecutar en Supabase SQL Editor:

```sql
ALTER TABLE passwords
ADD COLUMN IF NOT EXISTS contraseña_iv TEXT;
```

**Archivo**: `migration_add_encryption.sql`

## Pruebas Recomendadas

1. **Nuevo usuario**:
   - Crear cuenta
   - Agregar contraseña
   - Verificar en Supabase que `contraseña_encriptada` es hexadecimal (encriptado)

2. **Múltiples dispositivos**:
   - Abrir en browser 1, agregar contraseña
   - Abrir en browser 2, verificar que aparece desencriptada
   - Editar en browser 1, verificar cambio en browser 2

3. **Seguridad**:
   - Acceder directamente a Supabase
   - Verificar que `contraseña_encriptada` es ilegible sin la clave
   - Cambiar contraseña maestra debe fallar en desencriptación

## Notas de Seguridad

- ⚠️ La contraseña maestra está en RAM mientras la app esté abierta (normal en todos los gestores)
- ✅ Sin la contraseña maestra, los datos en Supabase son ilegibles
- ✅ El IV único por encriptación evita patrones
- ✅ El auth tag detecta datos manipulados

## Próximos Pasos

1. Ejecutar migración SQL
2. Hacer push del código actualizado
3. Probar con usuario existente
4. Si hay contraseñas antiguas (sin IV), migrar o pedir que las re-agregue
