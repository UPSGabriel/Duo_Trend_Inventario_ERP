# Duo Trend ERP

Duo Trend ERP es la base de un mini ERP multiplataforma para el negocio Duo Trend. La aplicaciÃ³n estÃ¡ orientada a Android y Windows, usa Flutter para la interfaz y Supabase/PostgreSQL como fuente oficial de verdad.

> Estado: **Fase 0 â€” base tÃ©cnica**. Esta rama contiene documentaciÃ³n, navegaciÃ³n responsive, tema, pantallas base, configuraciÃ³n externa y el primer esquema con RLS. Google OAuth, ventas, compras, deudas e inventario transaccional todavÃ­a no estÃ¡n implementados.

## Principios

- Una organizaciÃ³n: `Duo Trend`.
- Dos unidades iniciales: `TECNOLOGIA_ACCESORIOS` y `BELLEZA_MODA`.
- Locale `es_EC`, moneda USD y visualizaciÃ³n en `America/Guayaquil`.
- Timestamps almacenados en UTC.
- PostgreSQL y sus polÃ­ticas RLS son la autoridad de seguridad.
- Ninguna operaciÃ³n que altere stock se confirmarÃ¡ sin conexiÃ³n.
- Dinero y cantidades contables nunca usan punto flotante en PostgreSQL.
- No se almacenan secretos, credenciales, correos reales ni llaves privadas en Git.

## Estructura

```text
.
â”œâ”€â”€ apps/duo_trend_app/       AplicaciÃ³n Flutter Android y Windows
â”œâ”€â”€ docs/                     Producto, arquitectura, seguridad y operaciÃ³n
â”œâ”€â”€ supabase/                 ConfiguraciÃ³n, migraciones y pruebas SQL
â”œâ”€â”€ .github/workflows/        Calidad y builds reproducibles
â”œâ”€â”€ AGENTS.md                 Reglas obligatorias para colaboradores
â””â”€â”€ .env.example              Contrato de configuraciÃ³n, sin valores reales
```

La aplicaciÃ³n sigue una estructura feature-first. Cada feature separa presentaciÃ³n, dominio y datos cuando existe lÃ³gica suficiente para justificar esas capas; la Fase 0 evita abstracciones vacÃ­as.

## Requisitos

- Flutter estable compatible con Dart `>=3.10.0 <4.0.0`.
- Android Studio, Android SDK y licencias aceptadas.
- Visual Studio 2022 con **Desktop development with C++** para Windows.
- Docker Desktop y Supabase CLI para validar la base de datos local.
- Git.

Comprueba el entorno:

```powershell
flutter doctor -v
docker version
supabase --version
```

## ConfiguraciÃ³n de la aplicaciÃ³n

La configuraciÃ³n se inyecta en compilaciÃ³n con `--dart-define-from-file`. No se carga un `.env` como asset porque cualquier valor empaquetado en Flutter puede extraerse del binario.

1. Copia el contrato de ejemplo fuera del control de versiones:

```powershell
Copy-Item apps/duo_trend_app/config/app_config.example.json apps/duo_trend_app/config/app_config.local.json
```

2. Completa solo valores pÃºblicos o identificadores de configuraciÃ³n:

```json
{
  "SUPABASE_URL": "https://project-ref.supabase.co",
  "SUPABASE_PUBLISHABLE_KEY": "sb_publishable_...",
  "GOOGLE_OAUTH_CLIENT_ID": "",
  "AUTH_REDIRECT_URL": "com.duotrend.erp://login-callback/",
  "EMAIL_SOFIA": "",
  "EMAIL_GABRIEL": "",
  "ORGANIZATION_NAME": "Duo Trend"
}
```

`EMAIL_SOFIA` y `EMAIL_GABRIEL` son placeholders administrativos. No deben convertirse en constantes Dart ni registrarse en logs.

## Ejecutar Flutter

```powershell
Set-Location apps/duo_trend_app
flutter pub get
flutter gen-l10n
flutter run -d windows --dart-define-from-file=config/app_config.local.json
```

Para Android, reemplaza `windows` por el identificador mostrado por `flutter devices`.

La pantalla de login indica explÃ­citamente que Google OAuth estÃ¡ pendiente. En compilaciones de depuraciÃ³n existe una entrada a la vista previa de navegaciÃ³n; no crea sesiÃ³n, membresÃ­a ni datos.

## Supabase local

```powershell
supabase start
supabase db reset
supabase db lint --local
supabase test db
```

La migraciÃ³n crea Ãºnicamente la base de identidad multiempresa: organizaciones, perfiles, unidades y membresÃ­as. Los datos demo de `seed.sql` se ejecutan solo en desarrollo local y no contienen personas reales.

Consulta [ConfiguraciÃ³n de Supabase](docs/SETUP_SUPABASE.md) y [modelo de datos](docs/DATABASE.md).

## Calidad

Desde `apps/duo_trend_app`:

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test --coverage
```

Los workflows tambiÃ©n verifican:

- Formato, generaciÃ³n de localizaciones, anÃ¡lisis y pruebas.
- Migraciones y pruebas pgTAP contra Supabase local.
- Build Android release sin secretos.
- Build Windows release y artefacto completo con DLL y recursos.

## Builds

```powershell
Set-Location apps/duo_trend_app
flutter build apk --release --dart-define-from-file=config/app_config.local.json
flutter build windows --release --dart-define-from-file=config/app_config.local.json
```

La firma Android de producciÃ³n y el instalador Windows pertenecen a una fase posterior. El keystore y cualquier certificado deben permanecer fuera del repositorio.

## Seguridad

- Se usa solamente la publishable key en Flutter; nunca `service_role`.
- RLS estÃ¡ activado en todas las tablas expuestas.
- Los helpers `SECURITY DEFINER` usan `search_path` vacÃ­o y viven en un esquema no expuesto.
- La sesiÃ³n se persistirÃ¡ mediante almacenamiento seguro de plataforma.
- La interfaz no sustituye las validaciones de PostgreSQL.

Consulta [SECURITY.md](docs/SECURITY.md). Si encuentras una vulnerabilidad, no publiques secretos ni datos del negocio en un issue pÃºblico.

## OAuth pendiente

La Fase 0 prepara las URLs y el contrato de configuraciÃ³n, pero **no declara Google OAuth funcional**. TodavÃ­a deben configurarse Google Cloud, el proveedor Google de Supabase, la allowlist/invitaciones y el retorno por plataforma. Los pasos estÃ¡n en [GOOGLE_AUTH.md](docs/GOOGLE_AUTH.md).

## DocumentaciÃ³n

- [PRD](docs/PRD.md)
- [Arquitectura](docs/ARCHITECTURE.md)
- [Base de datos](docs/DATABASE.md)
- [Seguridad](docs/SECURITY.md)
- [Roadmap](docs/ROADMAP.md)
- [Android](docs/DEPLOYMENT_ANDROID.md)
- [Windows](docs/DEPLOYMENT_WINDOWS.md)

## SoluciÃ³n de problemas

- **La app muestra â€œConfiguraciÃ³n pendienteâ€:** falta `SUPABASE_URL` o `SUPABASE_PUBLISHABLE_KEY`.
- **Windows no aparece en `flutter devices`:** instala Visual Studio con C++ y ejecuta `flutter doctor -v`.
- **Android no compila:** revisa SDK, licencias y Java con `flutter doctor -v`.
- **Supabase no inicia:** confirma que Docker Desktop estÃ¡ ejecutÃ¡ndose y que su contexto es accesible.
- **OAuth vuelve al navegador:** registra exactamente la misma redirect URL en Google, Supabase y las plataformas nativas.

## Licencia y recursos

La identidad visual y el cÃ³digo de Duo Trend deben ser originales. Las referencias de productos de terceros pueden orientar flujos, pero no se copiarÃ¡n logotipos, ilustraciones, textos ni componentes propietarios.

