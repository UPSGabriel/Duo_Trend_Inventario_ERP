# ADR 0003: Sesión segura y configuración externa

- Estado: aceptada para la base; OAuth se completa en Fase 1.
- Fecha: 2026-08-02.

## Contexto

Supabase Flutter persiste sesiones por defecto en preferencias. Duo Trend requiere almacenamiento seguro en Android y Windows y no debe empacar secretos como assets.

## Decisión

- Inyectar configuración pública con `--dart-define`/`--dart-define-from-file`.
- Implementar el contrato `LocalStorage` de Supabase mediante `flutter_secure_storage`.
- No incluir `service_role`, Google Client Secret ni correos reales.
- Mostrar un estado seguro cuando falte configuración.

## Consecuencias

- Android mínimo compatible con el plugin de almacenamiento seguro.
- Windows necesita toolchain nativa y validar Credential Manager.
- Los valores compilados siguen siendo públicos; la seguridad depende de RLS.
- El login no puede declararse funcional hasta completar y probar OAuth/allowlist.
