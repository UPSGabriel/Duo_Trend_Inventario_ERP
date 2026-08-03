# Arquitectura

## Decisiones rectoras

- Flutter estable y Material 3 para una sola base Android/Windows.
- Feature-first con dependencias hacia el dominio, no hacia widgets.
- Riverpod para estado e inyección; `go_router` para navegación.
- Supabase/PostgreSQL como backend y autoridad.
- RLS para aislamiento; RPC transaccionales para cambios críticos futuros.
- Caché futura para lectura, nunca como autoridad de inventario.
- Edge Functions solo cuando PostgreSQL/Auth/Storage no resuelvan el caso de forma segura.

## Contexto general

```mermaid
flowchart LR
    A["Flutter Android / Windows"] --> B["Presentación y Riverpod"]
    B --> C["Casos de uso de dominio"]
    C --> D["Repositorios"]
    D --> E["Caché local de lectura"]
    D --> F["Supabase Flutter"]
    F --> G["Auth"]
    F --> H["PostgREST / RPC"]
    F --> I["Storage privado"]
    H --> J["PostgreSQL + RLS"]
```

## Capas Flutter

```text
lib/
├── app/                  arranque, aplicación y observers
├── core/
│   ├── config/           dart-define y validación
│   ├── errors/           errores de dominio
│   ├── routing/          rutas y shell responsive
│   ├── security/         sesión segura y límites del cliente
│   ├── theme/            tokens y ThemeData
│   └── widgets/          componentes reutilizables
└── features/
    ├── auth/
    ├── dashboard/
    ├── balance/
    ├── debts/
    ├── inventory/
    └── settings/
```

No se crean repositorios o casos de uso ficticios para pantallas sin datos. Las capas `domain` y `data` aparecen dentro de una feature cuando se implemente una regla real.

## Navegación responsive

- Menos de 840 px: `NavigationBar` con Inicio, Balance, Deudas e Inventario.
- Desde 840 px: `NavigationRail` persistente con los mismos destinos y Configuración.
- Configuración se abre desde el encabezado en móvil.
- Acciones de fases futuras aparecen deshabilitadas y etiquetadas; nunca ejecutan una operación simulada.
- La vista previa de depuración no equivale a autenticación.

## Flujo de autenticación previsto

La Fase 0 solo prepara este diseño.

```mermaid
sequenceDiagram
    actor U as Usuario
    participant F as Flutter
    participant B as Navegador
    participant S as Supabase Auth
    participant G as Google
    participant P as PostgreSQL/RLS
    U->>F: Iniciar con Google
    F->>B: OAuth + PKCE
    B->>G: Consentimiento
    G->>S: Callback autorizado
    S-->>F: Deep link + sesión
    F->>P: Consultar membresía activa
    alt invitación/membresía válida
        P-->>F: organización, rol y unidad
        F-->>U: Inicio autorizado
    else cuenta no autorizada
        P-->>F: sin membresía
        F-->>U: Cuenta no autorizada + cerrar sesión
    end
```

## Flujo futuro de venta

```mermaid
flowchart TD
    A["Carrito local no confirmado"] --> B["Confirmar con idempotency_key"]
    B --> C["RPC PostgreSQL"]
    C --> D{"Permiso, precios y stock válidos"}
    D -- No --> E["Rollback + error de dominio"]
    D -- Sí --> F["Crear venta y snapshots"]
    F --> G["Registrar pagos / deuda"]
    G --> H["Registrar movimiento de stock"]
    H --> I["Actualizar niveles y auditoría"]
    I --> J["Commit único"]
```

## Flujo futuro de compra

```mermaid
flowchart TD
    A["Orden borrador"] --> B["Orden confirmada"]
    B --> C["Recepción parcial o total"]
    C --> D["RPC de recepción"]
    D --> E["Movimiento PURCHASE_RECEIPT"]
    E --> F["Aumentar stock"]
    F --> G["Recalcular costo promedio"]
    G --> H["Pago o cuenta por pagar"]
    H --> I["Auditoría + commit"]
```

## Flujo futuro de deuda

```mermaid
flowchart LR
    A["Venta o compra a crédito"] --> B["Cuenta pendiente"]
    B --> C["Pago parcial/total"]
    C --> D{"Pago <= saldo"}
    D -- No --> E["Rechazar sin cambios"]
    D -- Sí --> F["Registrar pago"]
    F --> G["Recalcular saldo/estado"]
    G --> H["Registrar caja y auditoría"]
```

## Reporte mensual futuro

```mermaid
flowchart TD
    A["Fin de periodo UTC"] --> B["Clave única organización/unidad/año/mes"]
    B --> C{"¿Reporte existente?"}
    C -- Sí --> D["Devolver reporte existente"]
    C -- No --> E["Calcular desde snapshots y movimientos"]
    E --> F["Guardar report_data"]
    F --> G["Generar PDF"]
    G --> H["Notificación interna"]
    H --> I["Correo opcional si está configurado"]
```

## Flujo de despliegue

```mermaid
flowchart LR
    A["Rama de fase"] --> B["Format / Analyze / Test"]
    B --> C["Supabase reset / lint / pgTAP"]
    C --> D["Build Android"]
    C --> E["Build Windows"]
    D --> F["PR en borrador"]
    E --> F
    F --> G["Revisión humana"]
```

## Manejo de configuración

`AppConfig` lee únicamente constantes públicas de compilación. Si faltan URL o publishable key, la app muestra un estado de configuración pendiente sin imprimir los valores. Los correos e identificadores de propietarios no forman parte de `AppConfig`, assets ni `dart-define`: sus identidades se administran exclusivamente en Supabase mediante invitaciones, membresías o procedimientos seguros del lado servidor. `service_role`, secretos OAuth y llaves de firma quedan fuera del cliente en todos los ambientes.

## Observabilidad

La Fase 0 no integra servicios externos. Los errores se transforman en mensajes de dominio. Una fase posterior añadirá logging estructurado con redacción de datos; nunca se enviarán tokens, SQL o PII innecesaria.

## Decisiones diferidas

- Motor de caché local.
- Biblioteca decimal Dart para reglas monetarias.
- Generación PDF/CSV.
- Escáner Android.
- Proveedor opcional de correo.
- Empaquetado e instalador Windows.

Cada decisión debe evaluar mantenimiento, licencia, soporte Android/Windows y ausencia de suscripción obligatoria.
