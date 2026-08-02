# Configuración de Supabase

## Estado

La Fase 0 proporciona configuración local, migración y pruebas. No crea ni enlaza automáticamente un proyecto remoto.

## Requisitos

- Docker Desktop en ejecución.
- Supabase CLI estable.
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

La migración crea Duo Trend y sus unidades, pero no usuarios. `seed.sql` es solo para desarrollo local. Los propietarios se asignarán en Fase 1 después de configurar invitaciones.

## Variables

- `SUPABASE_URL`: URL pública del proyecto.
- `SUPABASE_PUBLISHABLE_KEY`: clave pública compatible con RLS.
- `ORGANIZATION_NAME`: nombre visible; por defecto Duo Trend.
- `EMAIL_SOFIA`, `EMAIL_GABRIEL`: entradas externas para el proceso administrativo futuro.

No añadas `SUPABASE_SERVICE_ROLE_KEY` al archivo de la app, a GitHub Actions de build cliente ni a un artefacto.

## Verificación posterior

- Tablas en `public` con RLS activado.
- Esquema `private` no expuesto por PostgREST.
- `anon` no puede leer filas.
- Usuario autenticado sin membresía no puede leer organizaciones.
- Constraints e índices presentes.
- Ningún correo real en migraciones o seed.

## Recuperación

La estrategia de backup/restore productiva se implementará en Fase 5. Hasta entonces, usa las herramientas administradas de Supabase y prueba cualquier restauración en un proyecto separado. Nunca ejecutes SQL destructivo sin backup, vista previa y confirmación.
