# ADR 0001: Flutter feature-first y Supabase como autoridad

- Estado: aceptada.
- Fecha: 2026-08-02.

## Contexto

Duo Trend necesita Android y Windows, una interfaz sencilla y reglas fuertes de inventario/finanzas. Dos clientes separados aumentarían costo y riesgo de divergencia.

## Decisión

Usar Flutter Material 3 con estructura feature-first. Riverpod compone estado/dependencias y `go_router` gestiona navegación. Supabase proporciona Auth, PostgreSQL y Storage. PostgreSQL con RLS y RPC es la autoridad de permisos y operaciones críticas.

## Consecuencias

- Una base de UI para dos plataformas.
- Las diferencias se concentran en shell, layout, entrada y empaquetado.
- Flutter no puede confirmar reglas críticas por sí solo.
- El esquema y las pruebas SQL forman parte del producto.
- Se necesita validar cada plugin en Android y Windows.
