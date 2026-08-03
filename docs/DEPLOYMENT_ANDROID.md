# Android

## Configuración base

- Application ID: `com.duotrend.erp`.
- Nombre visible: Duo Trend ERP.
- Plataformas generadas con Flutter estable.
- Permiso de Internet únicamente para acceder a Supabase/OAuth.
- Mínimo efectivo sujeto a dependencias; `flutter_secure_storage` requiere al menos API 23.

## Desarrollo

```powershell
flutter doctor -v
flutter devices
Set-Location apps/duo_trend_app
flutter pub get
flutter run -d DEVICE_ID --dart-define-from-file=config/app_config.local.json
```

## Build de verificación

```powershell
flutter build apk --release --dart-define-from-file=config/app_config.local.json
```

El build de CI usa configuración vacía/no secreta. Verifica compilación, no conectividad con un proyecto real ni OAuth.

## Firma futura

La Fase 0 usa la configuración estándar de verificación. Antes de distribución:

1. Generar keystore fuera del repositorio.
2. Guardar contraseñas en un gestor de secretos.
3. Configurar `key.properties` local o secretos CI.
4. Verificar fingerprints y conservar una copia segura.
5. Construir APK/AAB firmado y probar instalación limpia/actualización.

Nunca confirmar keystore, `key.properties`, certificados o contraseñas.

## OAuth pendiente

El manifest de Fase 0 reserva el esquema `com.duotrend.erp`, pero la autenticación no se considera operativa hasta probar Google/Supabase, retorno, cancelación y allowlist en Fase 1.

## Checklist de release futuro

- [ ] Icono y splash originales aprobados.
- [ ] Permisos mínimos revisados.
- [ ] OAuth real probado.
- [ ] RLS probado en staging.
- [ ] Firma y actualización probadas.
- [ ] Política de privacidad y respaldo definidas.
- [ ] APK/AAB analizado y artefacto identificado por versión.
