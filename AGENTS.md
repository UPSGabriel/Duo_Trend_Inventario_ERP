# AGENTS.md

Estas reglas aplican a todo el repositorio Duo Trend ERP.

## Contexto

- Flutter Material 3 para Android y Windows.
- Riverpod para estado e inyección; `go_router` para navegación.
- Supabase Auth, PostgreSQL, Storage y RLS.
- Arquitectura feature-first con separación presentación/dominio/datos.
- Locale inicial `es_EC`, moneda USD, visualización `America/Guayaquil` y almacenamiento UTC.

Lee antes de modificar: `docs/PRD.md`, `docs/ARCHITECTURE.md`, `docs/DATABASE.md`, `docs/SECURITY.md` y `docs/ROADMAP.md`.

## Flujo de trabajo

- Nunca desarrolles directamente sobre `main`.
- Usa una rama descriptiva y un PR independiente por fase o cambio coherente.
- No mezcles una fase posterior con la actual.
- Inspecciona `git status -sb` y el diff antes de preparar un commit.
- No reescribas cambios ajenos ni uses comandos Git destructivos.
- Mantén el PR en borrador mientras fallen validaciones obligatorias.

## Flutter

- Coloca la app en `apps/duo_trend_app`.
- Evita archivos gigantes y capas vacías.
- Los widgets compartidos pertenecen a `lib/core/widgets`; los widgets específicos permanecen en su feature.
- Los errores visibles son claros y en español. Nunca muestres SQL, tokens, stack traces o IDs internos innecesarios.
- Android y Windows son obligatorios; cada dependencia debe declarar soporte en ambas plataformas.
- No agregues paquetes abandonados, servicios de pago obligatorios o dependencias sin una necesidad documentada.
- Usa tamaños táctiles accesibles, semántica, contraste, foco visible y navegación por teclado.

## Dinero, fechas e inventario

- PostgreSQL usa `numeric` para dinero y cantidades; nunca `real`, `double precision` o `float`.
- Dart no debe usar `double` para reglas monetarias críticas. Usa enteros de unidad mínima o un tipo decimal aprobado en la fase correspondiente.
- Guarda `timestamptz` en UTC y convierte a `America/Guayaquil` únicamente para mostrar.
- Los impuestos son configurables y pueden estar desactivados; no fijes una tasa en código.
- PostgreSQL es la fuente oficial de stock.
- No permitas stock negativo.
- No confirmes ventas, compras, ajustes o pagos críticos offline.
- Toda operación transaccional futura necesita idempotencia, bloqueo/concurrencia y auditoría.
- No elimines historial financiero ni de inventario; usa anulación compensatoria o borrado lógico cuando corresponda.

## Base de datos

- Toda migración aplicada es inmutable. Los cambios posteriores se hacen con una migración nueva.
- Habilita RLS en toda tabla expuesta antes de conceder acceso.
- Toda tabla de negocio incluye `organization_id` cuando corresponda; las entidades operativas incluyen `business_unit_id` cuando corresponda.
- Valida pertenencia y rol en servidor. Ocultar botones no es autorización.
- Usa `SECURITY DEFINER` solo cuando sea necesario, con `SET search_path = ''`, nombres calificados y permisos mínimos.
- No construyas SQL concatenando entrada del usuario.
- Prueba acceso anónimo, membresía ajena, roles y aislamiento entre organizaciones.

## Secretos y datos

- Nunca confirmes `.env` reales, `app_config.local.json`, service role keys, client secrets, tokens, contraseñas, keystores o certificados.
- Flutter solo puede recibir `SUPABASE_URL`, la publishable key y valores públicos mediante `--dart-define`.
- `EMAIL_SOFIA` y `EMAIL_GABRIEL` siempre son placeholders externos hasta que el administrador los configure.
- No registres secretos, sesiones ni datos personales innecesarios en logs o auditoría.
- Los datos demo deben estar marcados como demo y no ejecutarse automáticamente en producción.

## Calidad obligatoria

Antes de cerrar una fase ejecuta, desde `apps/duo_trend_app`:

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test --coverage
```

Para Supabase:

```powershell
supabase db reset
supabase db lint --local
supabase test db
```

Ejecuta además los builds Android y Windows disponibles. Si una herramienta falta, registra el comando, el error real y usa CI; no afirmes que una comprobación pasó sin evidencia.

No añadas `// ignore`, exclusiones de lints o skips de pruebas de forma indiscriminada.

## Identidad visual y propiedad intelectual

- Duo Trend usa identidad original.
- No copies recursos, textos, iconos, componentes o ilustraciones de Treinta ni de otra aplicación.
- Las referencias externas solo pueden orientar la facilidad de uso y la organización del flujo.
