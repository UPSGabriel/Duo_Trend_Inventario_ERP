# Seguridad

## Estado de Fase 0

RLS y la base multiempresa están implementados. Google OAuth, invitaciones, Storage y operaciones transaccionales aún no están habilitados; la interfaz lo comunica y no crea sesiones simuladas.

## Límites de confianza

- Flutter es un cliente no confiable.
- La publishable key identifica el proyecto, no concede privilegios administrativos.
- JWT y `auth.uid()` identifican la sesión, pero la membresía/rol se valida en PostgreSQL.
- Solo backend seguro, migraciones administrativas o procesos explícitos pueden usar `service_role`.
- Archivos locales, deep links y parámetros de rutas son entrada no confiable.

## Modelo de amenazas inicial

| Amenaza | Mitigación |
|---|---|
| Consulta de otra organización | `organization_id`, RLS y pruebas cruzadas |
| Manipulación de rol en Flutter | Rol consultado/validado en PostgreSQL |
| Recursión o bypass de políticas | Helpers privados, `SECURITY DEFINER`, `search_path` vacío |
| Filtración de sesión | `flutter_secure_storage`, cierre de sesión y logs redactados |
| Secreto incluido en build | Contrato de configuración y revisión automatizada |
| Cuenta Google desconocida | No se concede membresía automática; invitación futura |
| Doble confirmación | RPC futura con idempotency key única |
| Stock o saldo manipulado | Revalidación y transacción futura en PostgreSQL |
| Archivo malicioso | Bucket privado, límites MIME/tamaño y nombres generados en fase correspondiente |
| Acción CI comprometida | Versiones explícitas y permisos mínimos del workflow |

## Secretos

Nunca se incluyen:

- `SUPABASE_SERVICE_ROLE_KEY`.
- Google Client Secret.
- Contraseñas, tokens o refresh tokens.
- Keystores, certificados o contraseñas de firma.
- Credenciales de correo.
- Correos reales de propietarios.

Las variables visibles en Flutter deben considerarse públicas. `SUPABASE_PUBLISHABLE_KEY` es aceptable solamente junto con RLS correcto. Los archivos locales de configuración están ignorados por Git.

## Funciones con privilegios

Toda función `SECURITY DEFINER` debe:

- Tener propietario controlado por migración.
- Usar `SET search_path = ''`.
- Calificar esquemas (`public.organization_members`, `auth.uid()`).
- Validar `auth.uid()` y retornar el mínimo dato necesario.
- Revocar ejecución de `PUBLIC` y concederla solo cuando la política lo necesite.
- Evitar SQL dinámico con texto de usuario.

Los helpers de políticas retornan booleanos y no exponen registros.

## Autenticación futura

- OAuth Authorization Code + PKCE en navegador del sistema.
- Redirect URL exacta y específica de Duo Trend.
- Proveedor Google configurado solo en Supabase.
- Registro público no equivale a acceso: un usuario de Auth sin invitación no obtiene membresía.
- Intentos no autorizados se registrarán con minimización de datos.
- Sesión expirada vuelve al login con mensaje claro.

## Storage futuro

- Buckets privados.
- Rutas con organización y entidad validadas.
- URLs firmadas de vida corta.
- Lista permitida de MIME/extensiones, tamaño máximo y compresión.
- Nombres generados; nunca confiar en el nombre suministrado.
- RLS de objetos alineado con membresías.

## Auditoría futura

`audit_logs` será append-only y no se podrá modificar desde Flutter. Registrará actor, organización, acción, entidad, instante y cambios necesarios; nunca sesiones, secretos o PII innecesaria.

## Respuesta a errores

Los errores técnicos se convierten en categorías de dominio. La UI no muestra SQL, stack traces, tokens ni detalles internos. CI puede conservar logs técnicos sin secretos y con retención controlada.

## Checklist de revisión

- [ ] Ningún secreto o correo real aparece en diff/historial.
- [ ] Toda tabla expuesta tiene RLS y políticas explícitas.
- [ ] Acceso anónimo y organización ajena están probados.
- [ ] Funciones privilegiadas fijan `search_path`.
- [ ] No se autoriza únicamente ocultando UI.
- [ ] Dependencias soportan Android y Windows.
- [ ] OAuth no se declara funcional sin prueba por plataforma.
- [ ] Workflows usan permisos mínimos y no imprimen configuración.
