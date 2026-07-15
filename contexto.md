# Contexto: Gestor de Contraseñas Encriptado

## Propósito

Aplicación web autónoma para guardar y gestionar contraseñas personales con encriptación de nivel militar (AES-256). Diseñada para ser:

- **Portátil**: Un archivo HTML + datos JSON. Funciona en cualquier navegador moderno.
- **Privado**: Sin servidores, sin tracking, sin cuentas. Todo local.
- **Auditable**: Código visible, sin dependencias, criptografía estándar NIST.
- **Distribuible**: Versionar en GitHub privado, sincronizable entre dispositivos.

## Casos de uso

1. **Gestor personal de credenciales**: Todas las contraseñas en un solo lugar, encriptado.
2. **Respaldo portátil**: Descargue su `data.json` y llévelo en USB o la nube.
3. **Multi-dispositivo**: Sincronice manualmente usando el mismo `data.json` en varias máquinas.
4. **Auditoría personal**: Vea qué contraseñas tiene, cuándo fueron creadas, dónde son usadas.

## Arquitectura

### Tecnología

- **Frontend**: HTML5 + CSS3 + Vanilla JavaScript (0 dependencias)
- **Criptografía**: Web Crypto API (SubtleCrypto)
- **Almacenamiento**: localStorage + data.json en el repo
- **Formato de datos**: JSON con payload encriptado en hexadecimal

### Flujo de encriptación

```
Contraseña maestra (texto)
        ↓
PBKDF2 (100,000 iteraciones)
        ↓
Clave AES-256
        ↓
AES-256-GCM (encriptar cada array de contraseñas)
        ↓
IV (12 bytes) + Ciphertext + Auth tag (16 bytes)
        ↓
Convertir a hexadecimal
        ↓
Guardar en data.json
```

### Archivos del proyecto

```
gestor-contraseñas/
├── index.html          # App monolítica (HTML + CSS + JS)
├── data.json          # Datos encriptados (versionado en git)
├── README.md          # Instrucciones de uso
├── contexto.md        # Este archivo
├── .gitignore         # Ignorar archivos temporales
└── .git/              # Historial de versiones
```

## Decisiones de diseño

### ✅ Una sola aplicación (monolítica)

**Por qué**: Facilita compartir, desplegar y usar. Abre en cualquier navegador sin build.

**Trade-off**: Código menos modular, archivo HTML más grande (~2000 líneas).

### ✅ Sin framework

**Por qué**: Cero dependencias = cero superficie de ataque. Código auditible.

**Trade-off**: Más código manual, menos reutilización.

### ✅ Datos versionados en git

**Por qué**: Historial de cambios, recuperación de versiones anteriores, respaldo distribuido.

**Trade-off**: Cada cambio queda registrado (pero encriptado). No hay anonimato de cuándo cambió qué.

### ✅ Almacenamiento dual (localStorage + data.json)

**Por qué**: localStorage es respaldo local rápido; data.json es la fuente de verdad remota.

**Trade-off**: Puede haber inconsistencias si no se sincroniza.

## Limitaciones

### Seguridad

1. **La contraseña maestra está en RAM mientras la app esté abierta**. Esto es universal en todos los gestores (1Password, Bitwarden, etc.). Solución: cierre el navegador cuando no esté usando.

2. **No hay sincronización automática entre dispositivos**. Debe exportar/importar manualmente. Esto es por diseño (máxima privacidad).

3. **Si olvida su contraseña maestra, los datos son irrecuperables**. No hay "recuperación de contraseña" ni "preguntas de seguridad". Esto es intencional.

4. **El historial de git expone cuándo cambió cada contraseña** (aunque encriptada). Solución: use un repositorio privado.

5. **No hay validación de fortaleza de contraseña integrada**. Usted es responsable de usar contraseñas fuertes.

### Funcionalidad

1. **No hay sincronización con dispositivos móviles**. El navegador debe estar en una máquina de escritorio.

2. **No hay autenticación 2FA**. Funciona con contraseña maestra solamente.

3. **No hay búsqueda de contraseñas comprometidas** (como Have I Been Pwned). Usted debe verificar manualmente.

4. **No hay generador de contraseñas integrado**. Debe generar contraseñas en otro lugar.

## Comparación con alternativas

| Característica | Gestor local | 1Password | Bitwarden | Nuestro |
|---|---|---|---|---|
| Costo | Gratis | $36/año | $10/año | Gratis |
| Sincronización automática | ❌ | ✅ | ✅ | ❌ (manual) |
| App móvil | ❌ | ✅ | ✅ | ❌ |
| Auditoría de código | ✅ | ❌ | ✅ (open source) | ✅ |
| Sin servidores | ✅ | ❌ | ❌ | ✅ |
| Encriptación local | ✅ | ✅ | ✅ | ✅ |
| 2FA | ❌ | ✅ | ✅ | ❌ |
| Generador de contraseñas | ❌ | ✅ | ✅ | ❌ |

**Conclusión**: Es un gestor minimalista, recomendado para:
- Usuarios que entienden criptografía y quieren máximo control
- Teams pequeños que comparten un repositorio privado
- Casos de uso específicos donde no se necesita sincronización automática

## Roadmap

### MVP (actual)
- [x] Encriptación AES-256-GCM
- [x] PBKDF2 con 100,000 iteraciones
- [x] Interfaz CRUD (crear, leer, actualizar, eliminar)
- [x] Búsqueda y filtrado
- [x] Exportación encriptada
- [x] localStorage como respaldo

### Phase 2
- [ ] Sincronización con Supabase (end-to-end encriptado)
- [ ] Soporte para múltiples usuarios en el mismo repo
- [ ] RLS (Row Level Security) en Supabase

### Phase 3
- [ ] Generador de contraseñas integrado
- [ ] Validación de fortaleza con ZXCVBN
- [ ] Integración con Have I Been Pwned
- [ ] Análisis de contraseñas duplicadas

### Phase 4
- [ ] App móvil (React Native / Flutter)
- [ ] Autenticación FIDO2/WebAuthn
- [ ] Modo offline-first con sincronización automática

## Riesgos conocidos

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|--------|-----------|
| Olvida contraseña maestra | Alta | Catastrófico (datos perdidos) | Documentación clara |
| Repositorio comprometido | Media | Medio (datos encriptados quedan expuestos, pero sin clave) | Usar repo privado, 2FA en GitHub |
| Navegador vulnerado | Baja | Alto (toda la app comprometida) | Mantener navegador actualizado |
| Malware en máquina | Baja | Alto (keylogger captura contraseña maestra) | Antivirus, máquina limpia |
| Política de GitHub cambia | Baja | Bajo (migrarse a otro repo) | Tener plan de respaldo |

## Instrucciones de despliegue

### Opción 1: GitHub Pages (recomendado)
1. Cree repo privado en GitHub
2. Push del código
3. Settings → Pages → Main branch
4. Acceda en `https://usuario.github.io/gestor-contraseñas`

### Opción 2: Netlify
1. Conecte repo a Netlify
2. Deploy automático en cada push
3. Dominio personalizado opcional

### Opción 3: Uso local
1. Clonar repo
2. `python3 -m http.server 8000`
3. Abrir `http://localhost:8000`

## Mantenimiento

### Backups
- Descargue `data.json` regularmente
- Guarde copias encriptadas en lugar seguro (USB, Google Drive privado, etc.)
- El git history es un respaldo de versiones anteriores

### Actualizaciones
- Revise cambios en el código antes de pull
- Los cambios en `data.json` son automáticos (app los guarda)

### Seguridad
- Revise regularmente el código para cambios no autorizados
- Verifique los commits usando verificación GPG
- Actualice el navegador tan pronto como haya parches

## FAQ

**¿Puedo usar esto en una máquina compartida?**  
No recomendado. Cierre sesión siempre después de usar. Alguien con acceso físico puede leer localStorage.

**¿Mi contraseña maestra está segura?**  
Sí, se usa solo para derivar la clave AES-256. Nunca se guarda en disco.

**¿Qué pasa si GitHub borra mi repositorio?**  
Sus datos siguen encriptados en cualquier respaldo que haya descargado. El código está abierto, puede recrear el repo.

**¿Puedo usar esto en múltiples dispositivos?**  
Sí, pero debe exportar/importar manualmente el `data.json`. No hay sincronización automática.

**¿Qué tan seguro es realmente?**  
Tan seguro como su contraseña maestra + navegador actualizado + máquina limpia. La criptografía es sólida (NIST). El riesgo está en lo humano.

---

**Versión**: 1.0  
**Última actualización**: 2025-01-15
