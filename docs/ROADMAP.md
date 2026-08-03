# Roadmap

Cada fase termina en un pull request independiente. Una fase no comienza automáticamente al cerrar la anterior.

## Fase 0 — Planificación y base

Estado: en implementación en `feat/fase-0-foundation`.

Entregables:

- Documentación de producto, arquitectura, datos y seguridad.
- Flutter Android/Windows con tema y navegación responsive.
- Pantallas base sin operaciones reales.
- Configuración externa de Supabase.
- Identidad multiempresa inicial y RLS.
- Pruebas mínimas y CI.

Puerta de salida:

- Format, analyze, test, migraciones y pgTAP exitosos.
- Builds Android y Windows exitosos en CI.
- Revisión explícita de pasos manuales y limitaciones.

## Fase 1 — Autenticación, organización y catálogo

- Google OAuth con PKCE y retorno Android/Windows.
- Invitaciones y membresías de Sofía y Gabriel administradas exclusivamente en Supabase.
- Perfiles, membresías, organización y cambio de unidad.
- Categorías, marcas, productos, variantes e imágenes.
- Stock inicial transaccional, búsqueda y alertas básicas.

Decisiones previas:

- Probar el retorno OAuth en instaladores reales de Windows.
- Aprobar flujo administrativo de invitación y tratamiento de correos.
- Elegir caché local mantenida y compatible con Windows.

## Fase 2 — Ventas, inventario y balance

- Carrito y venta transaccional idempotente.
- Pagos, cambio en efectivo y crédito.
- Movimiento automático de inventario y anulación compensatoria.
- Gastos, flujo de caja y balance diario.
- Comprobante base.

Puerta de salida: concurrencia, doble confirmación, stock insuficiente y atomicidad cubiertos por pruebas.

## Fase 3 — Compras, terceros y deudas

- Proveedores, órdenes y recepciones parciales.
- Costo promedio ponderado.
- Clientes, cuentas por cobrar y por pagar.
- Pagos parciales y estados de deuda.

Puerta de salida: ningún pago excede saldo y toda recepción concilia inventario/costo.

## Fase 4 — Reportes y control

- Dashboard con datos reales.
- Reportes filtrables, PDF y CSV.
- Reporte mensual idempotente.
- Notificaciones internas sin duplicados.
- Consulta de auditoría para OWNER.

Puerta de salida: cifras reconciliadas contra movimientos fuente y comparación mensual reproducible.

## Fase 5 — Robustecimiento y distribución

- Caché local y estrategia offline controlada.
- Exportaciones y respaldos.
- Suite completa de integración, accesibilidad y rendimiento.
- APK/AAB firmado, instalador Windows y manual de usuario.
- Checklist de producción, recuperación y monitoreo.

No se implementará restauración destructiva sin validación, vista previa, respaldo previo, confirmación y auditoría.
