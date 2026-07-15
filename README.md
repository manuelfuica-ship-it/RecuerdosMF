# Gestor de Contraseñas Seguro

Aplicación web para guardar y gestionar contraseñas de forma segura con encriptación AES-256 de nivel militar.

## Características

- **Encriptación AES-256-GCM**: Estándar NIST, usado por gobiernos y militares
- **Derivación de clave PBKDF2**: 100,000 iteraciones SHA-256 para resistir ataques de fuerza bruta
- **Almacenamiento encriptado**: Todas las contraseñas se guardan cifradas en `data.json`
- **Sin dependencias externas**: Usa Web Crypto API nativa del navegador
- **Interfaz intuitiva**: Agregar, editar, buscar y copiar contraseñas
- **Sincronización**: Carga y guarda automáticamente `data.json`
- **Exportación segura**: Descargue sus datos encriptados en cualquier momento

## Instalación y uso local

```bash
# Clonar o descargar el repositorio
git clone https://github.com/tu-usuario/gestor-contraseñas.git
cd gestor-contraseñas

# Ejecutar servidor local
python3 -m http.server 8000
# o si tienes Node.js
npx http-server

# Abrir en navegador
# http://localhost:8000
```

## Cómo funciona

### Primera ejecución
1. Abra `index.html` en su navegador
2. Ingrese una **contraseña maestra** (mínimo 12 caracteres recomendado)
3. Esta contraseña derivará la clave de encriptación AES-256
4. El salt se genera automáticamente y se guarda en `data.json`

### Uso normal
1. Ingrese su contraseña maestra
2. Haga clic en "Acceder"
3. Agregue, edite o elimine contraseñas
4. Los cambios se guardan automáticamente en `data.json` (encriptados)

### Campos de una contraseña
- **Nombre**: Aplicación o servicio (Gmail, GitHub, etc.)
- **Usuario/Email**: Identificador de acceso
- **Contraseña**: Se muestra oculta por defecto; haga clic en "Ver" para mostrar
- **URL**: Enlace al sitio (opcional)
- **Notas**: Información adicional (opcional)

## Seguridad

### Criptografía usada

| Aspecto | Especificación |
|--------|----------------|
| Encriptación | AES-256-GCM (NIST) |
| Derivación de clave | PBKDF2 + SHA-256, 100,000 iteraciones |
| IV (Vector de inicialización) | 96 bits aleatorio por encriptación |
| Salt | 128 bits aleatorio, guardado en `data.json` |
| Autenticación | GCM 128-bit authentication tag |

### Archivo `data.json`

```json
{
  "version": 1,
  "salt": "hexadecimal...",
  "encryptedData": {
    "iv": "hexadecimal...",
    "data": "hexadecimal..."
  },
  "lastSync": "2025-01-15T10:30:00Z"
}
```

**El campo `data` es ilegible sin la contraseña maestra.**

### Ventajas de esta arquitectura

✅ **End-to-end encriptado**: El navegador encripta antes de guardar  
✅ **Sin servidor de confianza requerido**: Funciona 100% localmente  
✅ **Datos versionados**: Si pierde su `data.json`, tiene el historial de git  
✅ **Auditoria**: El código fuente está a la vista, sin trucos  

### Limitaciones conocidas

⚠️ **IMPORTANTE**: Esta es una app de propósito especial, no un gestor de contraseñas profesional tipo 1Password o Bitwarden. Úsela consciente de estos riesgos:

1. **localStorage como respaldo**: Si cierra el navegador sin sincronizar, los cambios locales pueden perderse
2. **Contraseña maestra en memoria**: Mientras la app está abierta, la contraseña maestra está en RAM (común a todos los gestores)
3. **Sincronización manual**: No hay sincronización automática entre dispositivos (por diseño, para máxima privacidad)
4. **Historial de git**: Los datos encriptados históricos quedan en el repositorio
5. **No hay recuperación de contraseña maestra**: Si olvida su contraseña maestra, los datos son irrecuperables

## Despliegue

### GitHub Pages

```bash
# Haga push a GitHub
git push origin main

# Habilite Pages en Settings → Pages
# Branch: main / Folder: /
# Su app estará en: https://tu-usuario.github.io/gestor-contraseñas
```

### Netlify

```bash
# Conecte su repositorio en Netlify
# No requiere configuración adicional
```

### Servidor propio

Copie los archivos a su servidor web (nginx, Apache, Node.js, etc.).

## Uso en producción

Para máxima seguridad:

1. **Use HTTPS siempre**: El navegador debe servir la app por HTTPS
2. **Contraseña maestra fuerte**: Mínimo 16 caracteres, mixto (mayúsculas, minúsculas, números, símbolos)
3. **Respalde `data.json`**: Guarde copias encriptadas de su archivo
4. **No comparta su `data.json`**: Si alguien accede a este archivo, aún necesita su contraseña maestra
5. **Actualice el navegador**: Los parches de seguridad son críticos

## Exportar y importar

### Exportar
1. Haga clic en "Exportar"
2. Se descargará un archivo `contraseñas-AAAA-MM-DD.json` encriptado
3. Guárdelo en lugar seguro

### Importar
Para importar en otra máquina, reemplace el `data.json` existente con su copia encriptada y use su contraseña maestra.

## Desarrollo

### Estructura del código

- `index.html`: Aplicación monolítica (~2000 líneas)
  - HTML: Interfaz y estructura
  - CSS: Estilos (gradientes, modales, responsive)
  - JavaScript: Lógica de encriptación, autenticación y gestión

### Sin dependencias externas

No usa ninguna librería. Solo:
- Web Crypto API (navegador)
- localStorage (navegador)
- Fetch API (navegador)

### Estándares usados

- **NIST SP 800-38D**: AES-GCM
- **NIST SP 800-132**: PBKDF2
- **RFC 5869**: HKDF (potencial mejora futura)

## Mejoras futuras

- [ ] Sincronización con Supabase (end-to-end encriptado)
- [ ] Autenticación 2FA con código TOTP
- [ ] Generador de contraseñas seguras integrado
- [ ] Análisis de fortaleza de contraseña
- [ ] Exportación a otros gestores (1Password, Bitwarden)
- [ ] Soporte para hardware keys (FIDO2)
- [ ] Modo oscuro
- [ ] Sincronización entre dispositivos

## Licencia

Código público. Úselo, copie, modifique como desee.

## Riesgos y disclaimer

Esta aplicación se proporciona **tal cual**. El autor no se responsabiliza por pérdida de contraseñas, acceso no autorizado u otros daños. Usted es responsable de:

- Mantener su contraseña maestra segura
- Respaldar su `data.json`
- Usar HTTPS en producción
- Mantener su navegador actualizado
- No compartir su dispositivo con usuarios no confiables

## Contacto

Para reportar vulnerabilidades de seguridad, no abra un issue público. Contacte directamente al mantenedor.

---

**Versión**: 1.0  
**Última actualización**: 2025-01-15  
**Estado**: Production-ready (con riesgos conocidos documentados)
