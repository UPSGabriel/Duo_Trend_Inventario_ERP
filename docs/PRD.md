# PRD — Duo Trend ERP

## 1. Resumen

Duo Trend ERP será un mini ERP para administrar inventario, ventas, compras, gastos, cuentas por cobrar y pagar, reportes y respaldos de un pequeño negocio ecuatoriano. Debe servir a Gabriel y Sofía como copropietarios y preparar roles de empleados sin sacrificar exactitud contable ni aislamiento de datos.

## 2. Problema

El negocio maneja dos líneas distintas de productos y necesita una única fuente de verdad. Los registros separados o manuales dificultan conocer stock, caja, rentabilidad, deudas y desempeño consolidado. Una confirmación duplicada o una validación solo en el cliente puede alterar inventario o saldos reales.

## 3. Organización inicial

- Organización: `Duo Trend`.
- `TECNOLOGIA_ACCESORIOS`: unidad predeterminada de Sofía.
- `BELLEZA_MODA`: unidad predeterminada de Gabriel.
- Ambos serán `OWNER` después de un proceso seguro de invitación.
- Los correos se suministrarán externamente como `EMAIL_SOFIA` y `EMAIL_GABRIEL`.

## 4. Usuarios

### Propietario

Necesita revisar el negocio completo, cambiar de unidad, gestionar operación y consultar auditoría. No debe depender de conocimientos contables o técnicos para registrar una operación cotidiana.

### Futuro administrador o vendedor

Necesita una interfaz limitada a sus responsabilidades. Los permisos efectivos deben estar en PostgreSQL, incluso si manipula el cliente.

## 5. Objetivos del producto

- Mantener inventario consistente y trazable.
- Separar flujo de caja de utilidad contable.
- Permitir operación por unidad y consolidada.
- Registrar historial y snapshots que no cambien retroactivamente.
- Funcionar correctamente en Android y Windows.
- Proteger datos mediante membresía, roles y RLS.
- Producir reportes y exportaciones recuperables.

## 6. Experiencia objetivo

La interfaz usa español de Ecuador, USD, fechas `dd/MM/yyyy` y hora de 24 horas. En móvil prioriza cuatro destinos: Inicio, Balance, Deudas e Inventario. En escritorio usa navegación lateral y aprovecha tablas y paneles más amplios.

El selector de alcance permitirá, cuando existan sesiones y membresías:

- Mi unidad.
- Tecnología y accesorios.
- Belleza, moda y cosmética.
- Todo Duo Trend.

La identidad usa Material 3 con amarillo cálido, azul grisáceo oscuro, verde y rojo semánticos. No replica recursos propietarios de otras aplicaciones.

## 7. Alcance de Fase 0

- Repositorio, documentación y reglas de colaboración.
- Proyecto Flutter para Android y Windows.
- Tema original, localización inicial y shell responsive.
- Pantallas base de Login, Inicio, Balance, Deudas, Inventario y Configuración.
- Contrato de configuración externo para Supabase y OAuth.
- Tablas `organizations`, `profiles`, `business_units` y `organization_members`.
- Helpers seguros, índices, constraints, RLS y pruebas SQL iniciales.
- Pruebas unitarias y de widgets.
- CI de calidad, base de datos, Android y Windows.

## 8. Fuera de alcance de Fase 0

- Inicio de sesión Google funcional y allowlist productiva.
- Productos persistidos, variantes, imágenes o escaneo.
- Ventas, compras, gastos, deudas y pagos reales.
- Movimientos o niveles reales de inventario.
- PDFs, CSV, reportes mensuales y notificaciones.
- Escrituras offline, sincronización y resolución de conflictos.
- Firma de release, publicación en tiendas o instalador final.
- Restauración de respaldos.

Las pantallas de Fase 0 son una base navegable; muestran estados vacíos y no generan datos simulados que aparenten una operación real.

## 9. Requisitos funcionales futuros

### Catálogo e inventario

Productos, variantes, SKU y códigos de barras únicos por organización, ubicaciones, stock mínimo y libro de movimientos inmutable. Todo ajuste masivo tendrá vista previa, confirmación y auditoría.

### Ventas

Carrito, descuentos autorizados, pago combinado, crédito, comprobante e idempotencia. La confirmación recalculará precios, permisos, totales y stock en PostgreSQL dentro de una transacción.

### Compras

Órdenes, recepciones parciales, aumento de stock al recibir, costo promedio y deuda con proveedor.

### Finanzas y deudas

Gastos, cobros y pagos parciales sin exceder saldos. Flujo de caja y utilidad aparecerán separados.

### Reportes y respaldos

Filtros por periodo/unidad, PDF/CSV, cierre mensual idempotente y respaldo manual estructurado. Una restauración futura requerirá validación, vista previa, copia previa y auditoría.

## 10. Requisitos no funcionales

- Integridad: claves, checks, índices, transacciones e idempotencia.
- Seguridad: RLS, mínimo privilegio, Storage privado y secretos fuera del cliente.
- Accesibilidad: contraste, semántica, foco y navegación por teclado.
- Rendimiento: paginación, debounce, índices, caché y ausencia de N+1.
- Mantenibilidad: feature-first, migraciones inmutables, CI y documentación viva.
- Disponibilidad: lectura reciente mediante caché futura; ninguna escritura crítica offline en el MVP.

## 11. Métricas de éxito

- Cero stock negativo producido por operaciones confirmadas.
- Cero acceso entre organizaciones en pruebas RLS.
- Cero doble procesamiento con la misma clave idempotente.
- Reconciliación exacta entre pagos, saldos y totales.
- Todas las verificaciones obligatorias en verde antes de fusionar.
- Tiempo de registro de una venta cotidiana adecuado para operación en mostrador, medido en una fase posterior.

## 12. Criterios de aceptación de Fase 0

- El proyecto resuelve dependencias, analiza y prueba sin errores.
- Android y Windows generan builds mediante CI.
- Las seis pantallas son navegables y se adaptan a móvil/escritorio.
- La app no presenta OAuth como funcional.
- La configuración real queda fuera de Git.
- Las migraciones se reproducen desde cero y RLS bloquea acceso no autorizado.
- La documentación identifica pasos manuales y límites reales.
