# Configuración de Supabase

## Estado

La Fase 0 proporciona configuración local, migración y pruebas. No crea ni enlaza automáticamente un proyecto remoto.

## Requisitos

- Docker Desktop en ejecución.
- Supabase CLI `2.111.0`, versión fijada en CI para esta fase.
- Acceso administrativo al proyecto de Duo Trend para el despliegue remoto.

## Entorno local

Desde la raíz:

```powershell
supabase start
supabase db reset
supabase db lint --local
supabase test db
```

`db reset` destruye solo la base local administrada por Supabase CLI. Confirma siempre el directorio y nunca ejecutes una restauración destructiva contra producción.

Obtén la URL y publishable/anon key locales con:

```powershell
supabase status
```

Copia esos valores a `apps/duo_trend_app/config/app_config.local.json`, que está ignorado por Git. No copies la service role key.

## Proyecto remoto

1. Crea o selecciona el proyecto Supabase en la región adecuada.
2. Revisa que las APIs expuestas incluyan `public` y no incluyan `private`.
3. Enlaza de forma interactiva:

```powershell
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase db push --dry-run
```

4. Revisa el SQL del dry run y aplica solo después de aprobación:

```powershell
supabase db push
```

5. Confirma RLS y ejecuta pruebas contra un entorno no productivo antes de crear membresías reales.

## Datos iniciales

La migración crea Duo Trend y sus unidades, pero no usuarios. `seed.sql` es solo para desarrollo local. Sofía y Gabriel se describen funcionalmente como copropietarios; sus identidades y correos no forman parte de la configuración Flutter. Los propietarios se asignarán en Fase 1 mediante un proceso seguro en Supabase.

## Variables

- `SUPABASE_URL`: URL pública del proyecto.
- `SUPABASE_PUBLISHABLE_KEY`: clave pública compatible con RLS.
- `ORGANIZATION_NAME`: nombre visible; por defecto Duo Trend.

No añadas correos o identificadores de propietarios, `SUPABASE_SERVICE_ROLE_KEY`
ni otras credenciales administrativas al archivo de la app, a GitHub Actions de
build cliente ni a un artefacto.

## Autorización administrativa de propietarios

La autorización de Sofía y Gabriel se realizará exclusivamente en Supabase. La
app Flutter no recibe sus correos y no puede crear una membresía por sí sola.

El procedimiento aprobado para Fase 1 deberá:

1. Verificar la identidad fuera del cliente y crear o invitar la cuenta en Supabase Auth desde un entorno administrativo seguro.
2. Resolver el `auth.users.id` en el servidor sin confiar en metadata enviada por Flutter.
3. Crear o activar `organization_members` para Duo Trend con el rol y la unidad aprobados.
4. Registrar la aprobación administrativa con minimización de datos.
5. Permitir revocar la membresía sin modificar ni redistribuir el APK o el ejecutable Windows.

Hasta que exista ese flujo verificado, no se debe crear una RPC pública de
bootstrap ni conceder `OWNER` automáticamente por correo, nombre o metadata.

## Verificación posterior

- Tablas en `public` con RLS activado.
- Esquema `private` no expuesto por PostgREST.
- `anon` no puede leer filas.
- Usuario autenticado sin membresía no puede leer organizaciones.
- Constraints e índices presentes.
- Ningún correo real en migraciones o seed.

## Recuperación

La estrategia de backup/restore productiva se implementará en Fase 5. Hasta entonces, usa las herramientas administradas de Supabase y prueba cualquier restauración en un proyecto separado. Nunca ejecutes SQL destructivo sin backup, vista previa y confirmación.
