# Windows

## Configuración base

- Nombre visible: Duo Trend ERP.
- Ejecutable base: `duo_trend_app.exe` durante desarrollo.
- Arquitectura estándar Flutter para Windows.
- Visual Studio 2022 con Desktop development with C++.

## Desarrollo

```powershell
flutter doctor -v
flutter devices
Set-Location apps/duo_trend_app
flutter pub get
flutter run -d windows --dart-define-from-file=config/app_config.local.json
```

## Build de verificación

```powershell
flutter build windows --release --dart-define-from-file=config/app_config.local.json
```

Distribuye siempre el directorio completo bajo `build/windows/.../runner/Release`; un `.exe` aislado no contiene Flutter, DLL, plugins ni assets.

## OAuth pendiente

La Fase 1 registrará `com.duotrend.erp` como protocolo mediante el instalador o paquete. El build de Fase 0 no prueba un retorno OAuth real.

Casos obligatorios:

- App cerrada y retorno desde navegador.
- App abierta y retorno a la instancia correcta.
- Cancelación, timeout y URL manipulada.
- Sesión persistida/cerrada en Windows Credential Manager mediante almacenamiento seguro.

## Instalador futuro

La Fase 5 evaluará Inno Setup o una alternativa gratuita y mantenida. El instalador debe:

- Incluir el directorio release completo.
- Registrar/desregistrar el protocolo OAuth.
- Crear accesos directos opcionales.
- Conservar datos de usuario durante actualización.
- Soportar desinstalación limpia.
- Incluir versión, editor e icono originales.

## Checklist

- [ ] `flutter doctor -v` sin problemas Windows.
- [ ] Build release en CI y equipo objetivo.
- [ ] Navegación con teclado y foco visible.
- [ ] Escalado de pantalla probado.
- [ ] OAuth instalado probado.
- [ ] Instalador probado en máquina limpia.
- [ ] DLL y recursos incluidos.
- [ ] Firma de código evaluada sin credenciales en Git.
