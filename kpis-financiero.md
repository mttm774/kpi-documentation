# Documentación de KPIs — RideCode
## Pestaña: Financiero

---

## Estructura de cada KPI

Cada KPI se documenta con dos secciones:

- **[Usuario]** — Información orientada al usuario final: qué muestra el KPI, cuándo se calcula la información, cómo se consulta, qué filtros aplican y notas visibles en el frontend.
- **[Técnico]** — Información orientada al equipo de desarrollo: fuente de datos, programa de agrupación, procedimientos, tabla de hechos, operaciones internas y textos de interfaz (tooltip y subtítulo en español e inglés).

> **Nota sobre la Descripción:** El campo *Descripción* de cada KPI es el texto que se muestra como **tooltip** en la página de KPIs y en el dashboard.

---

---

## KPI: Tiquete Promedio

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el promedio de la tarifa de los tiquetes para los servicios prestados en el rango de fechas seleccionado.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros que el usuario haya definido: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta del promedio de la tarifa de los tiquetes para los servicios prestados en el rango de fechas.

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

---

### [Técnico]

**Fuente de datos**

| Campo   | Valor      |
|---------|------------|
| Fuente  | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                  |
|---------------------------|--------------------------------------------------------|
| Operación                 | Promedio del campo `passengerFare` de `summaryService` |
| Tabla de hechos           | —                                                      |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_AVERAGE_TICKET`                  |

---

**Observación técnica**

Para empresas de **transporte** y **zona franca**, los datos se obtienen directamente de `summaryService`. Para empresas **cliente**, se requiere hacer un `JOIN` con `clientcompanyservice` para obtener la información correspondiente.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta del promedio de la tarifa de los tiquetes para los servicios prestados en el rango de fechas. | Query of the average ticket fare for services provided within the selected date range. |
| Subtítulo  | — | — |

---

---

## KPI: Flujo Cobro Clientes

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra las facturas emitidas agrupadas por estado: **pagadas** o **pendientes**. Las facturas pendientes pueden derivar en **morosidad** si el tiempo de vencimiento configurado en el módulo de clientes se ha cumplido.

- Si el usuario pertenece a una empresa de **transporte**, este KPI no retorna datos.

> **Nota de fecha:** El subtítulo del KPI debe indicar: _"La fecha utilizada es la fecha fin"_. El filtro se aplica contra la Fecha fin para determinar el estado actual de las facturas.

---

**¿Cuándo se calcula la información?**

La información de este KPI se actualiza automáticamente en los siguientes momentos:

- Cuando se **crea o cambia el estado de una factura** en el sistema.
- De forma **automática todos los días a las 00:00** (hora de la zona franca según su zona horaria), independientemente de la actividad del usuario.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema consulta los datos ya calculados y almacenados. El usuario debe seleccionar la **Fecha fin** para definir el corte temporal; el sistema evaluará el estado de las facturas en esa fecha, incluyendo si han entrado en morosidad según el tiempo de vencimiento configurado.

---

**Filtros disponibles**

| Filtro       | Aplica |
|--------------|--------|
| Turno        | NO     |
| Ramal        | NO     |
| Tipo de ruta | NO     |
| Fecha inicio | NO     |
| Fecha fin    | **SÍ** |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta de las facturas emitidas, agrupadas por estado: pagadas o pendientes. Las pendientes pueden resultar en morosidad si el tiempo de vencimiento se ha cumplido. El tiempo de vencimiento está configurado en el módulo de clientes.

| Filtro       | Aplica |
|--------------|--------|
| Turno        | NO     |
| Ramal        | NO     |
| Tipo de ruta | NO     |
| Fecha inicio | NO     |
| Fecha fin    | **SÍ** |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor                                                                    |
|-------------------------------------|--------------------------------------------------------------------------|
| Programa de agrupación              | SÍ                                                                       |
| Evento disparador                   | Creación o cambio de estado de una factura · Ejecución diaria a las 00:00 (hora de la zona franca según su zona horaria) |
| Tópico en la cola                   | `invoice-updates`                                                        |
| Procedimiento de agrupación         | `PRC_RIDECODE_KPI_AGGREGATION_COLLECTION_BALANCES`                       |
| Parámetros procedimiento agrupación | —                                                                        |

> El evento puede ser disparado por una acción sobre una factura (creación o cambio de estado), lo que guarda un mensaje en la cola con su payload. El worker escucha la cola `invoice-updates` y ejecuta la agrupación. Adicionalmente, la agrupación se ejecuta de forma programada todos los días a las 00:00 (hora de la zona franca según su zona horaria).
>
> El programa de agrupación garantiza que múltiples eventos sobre la misma factura no generen registros duplicados, sino que actualicen un único registro agrupado en la tabla de hechos.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                                   |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------|
| Operación                 | Sumatoria de facturas emitidas por estado (pagada, pendiente) y determinación de morosidad según fecha de vencimiento configurada en el módulo de clientes |
| Tabla de hechos           | `CLIENT_COLLECTION_BALANCES`                                                                                            |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_COLLECTION_FLOW_PAGINATED`                                                                        |

---

**Observación técnica**

Los datos se obtienen de la tabla `invoice`, evaluando el estado de cada factura. Si el usuario pertenece a una empresa de **transporte**, no se retornan datos. El tiempo de vencimiento que determina la morosidad está configurado en el módulo de clientes.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta de las facturas emitidas, agrupadas por estado: pagadas o pendientes. Las pendientes pueden resultar en morosidad si el tiempo de vencimiento se ha cumplido. El tiempo de vencimiento está configurado en el módulo de clientes. | Query of issued invoices, grouped by status: paid or pending. Pending invoices may result in delinquency if the due date has passed. The due date is configured in the clients module. |
| Subtítulo  | La fecha utilizada es la fecha fin. | The date used is the end date. |

---

---

## KPI: Flujo Pago Transportistas

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra la sumatoria del valor de ingreso de los transportistas por sus servicios prestados, agrupados por estado de pago: **pagados** o **pendientes**.

> **Nota de fecha:** El subtítulo del KPI debe indicar: _"La fecha utilizada es la fecha fin"_. El filtro se aplica contra la Fecha fin para determinar el estado de pago de los servicios.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real. El usuario debe seleccionar la **Fecha fin** para definir el corte temporal; el sistema devolverá el estado de pago de los servicios a los transportistas en esa fecha.

---

**Filtros disponibles**

| Filtro       | Aplica |
|--------------|--------|
| Turno        | NO     |
| Ramal        | NO     |
| Tipo de ruta | NO     |
| Fecha inicio | NO     |
| Fecha fin    | **SÍ** |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta de los servicios por pagar a los transportistas, se agrupan por estado: pagados o pendientes.

| Filtro       | Aplica |
|--------------|--------|
| Turno        | NO     |
| Ramal        | NO     |
| Tipo de ruta | NO     |
| Fecha inicio | NO     |
| Fecha fin    | **SÍ** |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                                                                    |
|---------------------------|----------------------------------------------------------------------------------------------------------|
| Operación                 | Sumatoria del valor de ingreso de transportista por servicio, agrupado por estado de pago (pagado / pendiente) |
| Tabla de hechos           | —                                                                                                        |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_PAYMENT_FLOW_CARRIER_PAGINATED`                                                    |

---

**Observación técnica**

Los datos se obtienen de la tabla `SUMMARY_SERVICE`. El campo `ServicePaidToTransport` (tipo `bit`) indica el estado de pago: `0` = no pagado (pendiente), `1` = pagado.

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta de los servicios por pagar a los transportistas, se agrupan por estado: pagados o pendientes. | Query of services to be paid to carriers, grouped by status: paid or pending. |
| Subtítulo  | La fecha utilizada es la fecha fin. | The date used is the end date. |

---

---

## KPI: Planes de Contingencia

---

### [Usuario]

**¿Qué muestra este KPI?**
Muestra el total de pasajeros que registraron su ingreso al autobús como contingencia. El resultado se agrupa de dos formas:

- **Pie** — agrupado por empresa de **transporte**.
- **Pareto** — agrupado por empresa **cliente**.

---

**¿Cuándo se calcula la información?**

Este KPI **no utiliza precálculo ni agrupación**. La información se obtiene directamente desde la fuente de datos en el momento en que el usuario consulta el KPI, aplicando los filtros seleccionados.

---

**¿Cómo se consulta la información?**

Al cargar el KPI, el sistema ejecuta la consulta en tiempo real con base en los filtros definidos por el usuario: turno, ramal, tipo de ruta, fecha inicio y fecha fin.

---

**Filtros disponibles**

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

---

**Descripción** _(se muestra como tooltip en la página de KPIs y en el dashboard)_

Consulta el total de pasajeros que hayan registrado su ingreso al autobús como contingencia y se agrupa el resultado por empresa de transporte (pie) y por empresa cliente (pareto).

| Filtro       | Aplica |
|--------------|--------|
| Turno        | **SÍ** |
| Ramal        | **SÍ** |
| Tipo de ruta | **SÍ** |
| Fecha inicio | **SÍ** |
| Fecha fin    | **SÍ** |

---

### [Técnico]

**Fuente de datos**

| Campo  | Valor      |
|--------|------------|
| Fuente | SQL Server |

---

**Programa de agrupación**

| Campo                               | Valor |
|-------------------------------------|-------|
| Programa de agrupación              | NO    |
| Evento disparador                   | —     |
| Tópico en la cola                   | —     |
| Procedimiento de agrupación         | —     |
| Parámetros procedimiento agrupación | —     |

> Este KPI no utiliza programa de agrupación. No se generan eventos en cola ni se persiste información en una tabla de hechos; la consulta se resuelve directamente en tiempo de ejecución.

---

**Operación y consulta**

| Campo                     | Valor                                                        |
|---------------------------|--------------------------------------------------------------|
| Operación                 | Conteo de lecturas con marca de contingencia (`ContingencyPassengers`) |
| Tabla de hechos           | —                                                            |
| Procedimiento de consulta | `PRC_RIDECODE_GET_KPI_CONTINGENCY_PLANS`                     |

---

**Observación técnica**

Los datos se obtienen de los `SUMMARY_SERVICE` que cumplan con `ComplianceTransportCompanyApproved = 1` y que tengan marcas de contingencia en los servicios por cliente (`client_company_services.ContingencyPassengers`).

> **Condición obligatoria:** Solo se deben considerar los registros donde `ComplianceTransportCompanyApproved = 1`.

El resultado se divide en dos vistas:
- **Pie** — agrupado por empresa de transportista.
- **Pareto** — agrupado por empresa cliente.

---

**Textos de interfaz**

| Elemento   | Español | Inglés |
|------------|---------|--------|
| Tooltip    | Consulta el total de pasajeros que hayan registrado su ingreso al autobús como contingencia, agrupado por empresa de transporte (pie) y por empresa cliente (pareto). | Queries the total number of passengers who registered their bus entry as contingency, grouped by transport company (pie) and by client company (pareto). |
| Subtítulo  | — | — |

---
