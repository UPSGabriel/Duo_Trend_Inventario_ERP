# Google OAuth

## Estado

**No funcional en Fase 0.** La app incluye el contrato de configuración, almacenamiento seguro previsto y una pantalla que informa el estado. No llama a Google ni concede membresías.

## Diseño aprobado para Fase 1

- Supabase Auth como broker.
- Google como proveedor principal.
- Authorization Code + PKCE mediante navegador del sistema.
- Redirect base: `com.duotrend.erp://login-callback/`.
- Deep link Android y protocolo Windows probados en instalaciones reales.
- Sesión persistida con almacenamiento seguro.
- Membresía/invitación validada después de autenticar.

## Configuración manual futura

### Google Cloud

1. Configura la pantalla de consentimiento para el proyecto correcto.
2. Crea un OAuth Client ID de tipo Web Application para Supabase.
3. Añade el callback indicado por Supabase:

```text
https://PROJECT_REF.supabase.co/auth/v1/callback
```

4. Guarda el Client Secret únicamente en la configuración del proveedor de Supabase.

### Supabase

1. Authentication > Providers > Google.
2. Habilita Google e introduce Client ID/Secret.
3. Authentication > URL Configuration.
4. Añade exactamente:

```text
com.duotrend.erp://login-callback/
```

5. Restringe redirecciones adicionales a ambientes conocidos.

### Android

- Registrar intent-filter para el scheme y host exactos.
- Mantener `android:exported="true"` únicamente en la actividad que necesita recibir el enlace.
- Probar navegador externo, retorno, cancelación y app cerrada.

### Windows

- Registrar el protocolo `com.duotrend.erp` mediante el mecanismo del paquete/instalador.
- Probar instancia cerrada, abierta y múltiples intentos.
- Validar que parámetros malformados no creen sesión.

## Allowlist/invitaciones

Autenticarse no autoriza a entrar al negocio. La Fase 1 añadirá una invitación normalizada y de uso único para `EMAIL_SOFIA` y `EMAIL_GABRIEL`, configurados fuera de Git.

Si Google autentica otro correo:

- No se crea `organization_members`.
- Se muestra “Esta cuenta no tiene acceso a Duo Trend”.
- Solo se permite cerrar sesión.
- El intento se registra sin conservar tokens ni información innecesaria.

No se implementará un trigger que conceda rol OWNER basándose únicamente en metadata controlada por el cliente.

## Casos de prueba de Fase 1

- Propietario invitado, primera entrada y reentrada.
- Correo no autorizado.
- Invitación revocada/expirada/usada.
- Diferencias de mayúsculas en correo.
- Sesión expirada y refresh.
- Cancelación de Google y fallo de red.
- Deep link manipulado.
- Retorno Android con app cerrada/abierta.
- Retorno Windows instalado.
- Cierre de sesión elimina almacenamiento local.
