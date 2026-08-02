# Duo Trend ERP

Duo Trend ERP es la base de un mini ERP multiplataforma para el negocio Duo Trend. La aplicación está orientada a Android y Windows, usa Flutter para la interfaz y Supabase/PostgreSQL como fuente oficial de verdad.

> Estado: **Fase 0 — base técnica**. Esta rama contiene documentación, navegación responsive, tema, pantallas base, configuración externa y el primer esquema con RLS. Google OAuth, ventas, compras, deudas e inventario transaccional todavía no están implementados.

## Principios

- Una organización: `Duo Trend`.
- Dos unidades iniciales: `TECNOLOGIA_ACCESORIOS` y `BELLEZA_MODA`.
- Locale `es_EC`, moneda USD y visualización en `America/Guayaquil`.
- Timestamps almacenados en UTC.
- PostgreSQL y sus políticas RLS son la autoridad de seguridad.
- Ninguna operación que altere stock se confirmará sin conexión.
- Dinero y cantidades contables nunca usan punto flotante en PostgreSQL.
- No se almacenan secretos, credenciales, correos reales ni llaves privadas en Git.

## Estructura

```text
.
├── apps/duo_trend_app/       Aplicación Flutter Android y Windows
├── docs/                     Producto, arquitectura, seguridad y operación
├── supabase/                 Configuración, migraciones y pruebas SQL
├── .github/workflows/        Calidad y builds reproducibles
├── AGENTS.md                 Reglas obligatorias para colaboradores
└── .env.example              Contrato de configuración, sin valores reales
```

La aplicación sigue una estructura feature-first. Cada feature separa presentación, dominio y datos cuando existe lógica suficiente para justificar esas capas; la Fase 0 evita abstracciones vacías.

## Requisitos

- Flutter 3.44.7, con Dart compatible con `>=3.10.0 <4.0.0`.
- Android Studio, Android SDK y licencias aceptadas.
- Visual Studio 2022 con **Desktop development with C++** para Windows.
- Docker Desktop y Supabase CLI para validar la base de datos local.
- Git.

El archivo `pubspec.lock` está versionado para reproducir las dependencias
verificadas por CI en Android, Windows y las pruebas de Flutter.

Comprueba el entorno:

```powershell
flutter doctor -v
docker version
supabase --version
```

## Configuración de la aplicación

La configuración se inyecta en compilación con `--dart-define-from-file`. No se carga un `.env` como asset porque cualquier valor empaquetado en Flutter puede extraerse del binario.

1. Copia el contrato de ejemplo fuera del control de versiones:

```powershell
Copy-Item apps/duo_trend_app/config/app_config.example.json apps/duo_trend_app/config/app_config.local.json
```

2. Completa solo valores públicos o identificadores de configuración:

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

La pantalla de login indica explícitamente que Google OAuth está pendiente. En compilaciones de depuración existe una entrada a la vista previa de navegación; no crea sesión, membresía ni datos.

## Supabase local

```powershell
supabase start
supabase db reset
supabase db lint --local
supabase test db
```

La migración crea únicamente la base de identidad multiempresa: organizaciones, perfiles, unidades y membresías. Los datos demo de `seed.sql` se ejecutan solo en desarrollo local y no contienen personas reales.

Consulta [Configuración de Supabase](docs/SETUP_SUPABASE.md) y [modelo de datos](docs/DATABASE.md).

## Calidad

Desde `apps/duo_trend_app`:

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test --coverage
```

Los workflows también verifican:

- Formato, generación de localizaciones, análisis y pruebas.
- Migraciones y pruebas pgTAP contra Supabase local.
- Build Android release sin secretos.
- Build Windows release y artefacto completo con DLL y recursos.

## Builds

```powershell
Set-Location apps/duo_trend_app
flutter build apk --release --dart-define-from-file=config/app_config.local.json
flutter build windows --release --dart-define-from-file=config/app_config.local.json
```

La firma Android de producción y el instalador Windows pertenecen a una fase posterior. El keystore y cualquier certificado deben permanecer fuera del repositorio.

## Seguridad

- Se usa solamente la publishable key en Flutter; nunca `service_role`.
- RLS está activado en todas las tablas expuestas.
- Los helpers `SECURITY DEFINER` usan `search_path` vacío y viven en un esquema no expuesto.
- La sesión se persistirá mediante almacenamiento seguro de plataforma.
- La interfaz no sustituye las validaciones de PostgreSQL.

Consulta [SECURITY.md](docs/SECURITY.md). Si encuentras una vulnerabilidad, no publiques secretos ni datos del negocio en un issue público.

## OAuth pendiente

La Fase 0 prepara las URLs y el contrato de configuración, pero **no declara Google OAuth funcional**. Todavía deben configurarse Google Cloud, el proveedor Google de Supabase, la allowlist/invitaciones y el retorno por plataforma. Los pasos están en [GOOGLE_AUTH.md](docs/GOOGLE_AUTH.md).

## Documentación

- [PRD](docs/PRD.md)
- [Arquitectura](docs/ARCHITECTURE.md)
- [Base de datos](docs/DATABASE.md)
- [Seguridad](docs/SECURITY.md)
- [Roadmap](docs/ROADMAP.md)
- [Android](docs/DEPLOYMENT_ANDROID.md)
- [Windows](docs/DEPLOYMENT_WINDOWS.md)

## Solución de problemas

- **La app muestra “Configuración pendiente”:** falta `SUPABASE_URL` o `SUPABASE_PUBLISHABLE_KEY`.
- **Windows no aparece en `flutter devices`:** instala Visual Studio con C++ y ejecuta `flutter doctor -v`.
- **Android no compila:** revisa SDK, licencias y Java con `flutter doctor -v`.
- **Supabase no inicia:** confirma que Docker Desktop está ejecutándose y que su contexto es accesible.
- **OAuth vuelve al navegador:** registra exactamente la misma redirect URL en Google, Supabase y las plataformas nativas.

## Licencia y recursos

La identidad visual y el código de Duo Trend deben ser originales. Las referencias de productos de terceros pueden orientar flujos, pero no se copiarán logotipos, ilustraciones, textos ni componentes propietarios.

