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

Autenticarse no autoriza a entrar al negocio. Sofía y Gabriel son nombres
funcionales de los copropietarios, no datos de configuración del cliente. Sus
correos o identificadores nunca se envían mediante `dart-define`, no se incluyen
como assets y no quedan dentro del APK o del ejecutable Windows.

La Fase 1 implementará en Supabase una invitación normalizada y de uso único, o
un procedimiento administrativo equivalente ejecutado desde un backend seguro.
Después de verificar la identidad, ese proceso creará o activará la fila de
`organization_members` con el rol aprobado. Flutter solo consultará el resultado
de la membresía mediante RLS; nunca decidirá quién es propietario.

Si Google autentica otro correo:

- No se crea `organization_members`.
- Se muestra “Esta cuenta no tiene acceso a Duo Trend”.
- Solo se permite cerrar sesión.
- El intento se registra sin conservar tokens ni información innecesaria.

No se implementará un trigger que conceda rol OWNER basándose únicamente en metadata controlada por el cliente.

La carga inicial, revocación o corrección de una membresía de propietario debe
realizarse desde Supabase Dashboard, una migración administrativa aprobada o un
servicio seguro con credenciales de servidor. El procedimiento debe validar la
cuenta de Auth, registrar la aprobación y mantener cualquier correo fuera de Git,
logs del cliente y artefactos compilados.

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
