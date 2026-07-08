# Renuevo — app de fe, metas y diario con widget diario

Esta carpeta contiene el **código fuente Swift/SwiftUI** de la app y su widget de iOS.
No es un proyecto `.xcodeproj` ya armado: en esta máquina solo hay Command Line Tools
(no Xcode.app completo), así que no pude crear ni compilar el proyecto por ti. Sigue
estos pasos en tu Mac con Xcode instalado (Xcode 15+ recomendado, iOS 16+ como mínimo):

## 1. Crear el proyecto

1. Xcode → **File → New → Project → iOS → App**.
2. Nombre: `Renuevo` (o el que prefieras). Interface: **SwiftUI**. Language: **Swift**.
3. Guarda el proyecto en cualquier carpeta (por ejemplo, reemplazando esta misma carpeta
   `~/Developer/Renuevo` una vez hayas copiado el contenido a otro lado, o al lado de ella).

## 2. Copiar los archivos de la app

Arrastra dentro del navegador de proyecto de Xcode, **al target de la app** (`Renuevo`):

- Todo el contenido de `RenuevoApp/` (Models, Data, Notifications, Views, `RenuevoApp.swift`)
- Todo el contenido de `Shared/` (`Quote.swift`, `QuoteLibrary.swift`, `Theme.swift`)

Borra el `ContentView.swift` y el `RenuevoApp.swift` (o `App.swift`) que Xcode generó
automáticamente por defecto — los reemplazan los tuyos.

## 3. Agregar el Widget Extension

1. **File → New → Target → Widget Extension**.
2. Nombre: `RenuevoWidget`. **Desmarca** "Include Configuration Intent" (no lo necesitamos).
3. Xcode crea una carpeta `RenuevoWidget/` con archivos de ejemplo — bórralos.
4. Arrastra `RenuevoWidget/RenuevoWidget.swift` y `RenuevoWidget/RenuevoWidgetBundle.swift`
   de esta carpeta al nuevo target `RenuevoWidget`.
5. **Importante:** los 3 archivos de `Shared/` (`Quote.swift`, `QuoteLibrary.swift`,
   `Theme.swift`) deben pertenecer a **ambos targets**. Selecciona cada archivo en Xcode,
   abre el inspector de archivos (⌥⌘1) y marca la casilla de "Target Membership" tanto
   para `Renuevo` como para `RenuevoWidget`.

No hace falta App Group ni entitlements especiales: el widget calcula el mensaje del día
de forma determinística a partir de la fecha, igual que la app, sin compartir datos.

## 4. Ejecutar

- Elige el esquema `Renuevo` y corre en un simulador o tu iPhone.
- La primera vez pedirá permiso de notificaciones — acéptalo.
- Para ver el widget: mantén presionada la pantalla de inicio → **+** → busca "Renuevo" →
  agrégalo (viene en tamaño pequeño y mediano).
- Las notificaciones diarias se reprograman automáticamente cada vez que abres la app
  (ventana móvil de 60 días), y puedes cambiar la hora desde el ícono ⚙️ en la pestaña "Hoy".

## Qué incluye

- **Pestaña Hoy**: mensaje diario (fe, superación, crecimiento, gratitud), compartible,
  con pregunta de reflexión que enlaza al diario.
- **Pestaña Metas**: crear, editar, marcar como completadas y borrar metas personales,
  con notas y fecha objetivo opcional.
- **Pestaña Diario**: entradas con estado de ánimo y texto libre, ligadas al mensaje del día.
- **Widget de iOS** (pantalla de inicio): mismo mensaje del día, se actualiza solo a medianoche.
- **Notificación local diaria**: no requiere servidor ni cuenta — se programa en el propio
  dispositivo.
- **Todo el almacenamiento es local** (UserDefaults + JSON) — nada sale del teléfono.

## 5. Para "computador" (Mac Catalyst)

Con Catalyst, el mismo código de `Renuevo` corre como app nativa de macOS (icono en el
Dock, ventana redimensionable, notificaciones del sistema) sin escribir una sola línea
de código extra. El código de este proyecto ya es compatible (no usa nada UIKit-only sin
protegerlo, y `Shared/Theme.swift` ya tiene modo oscuro adaptativo vía UIKit dinámico).

**Pasos en Xcode:**

1. Selecciona el proyecto en el navegador → target `Renuevo` → pestaña **General**.
2. En **Supported Destinations**, pulsa **+** y agrega **Mac (Mac Catalyst)**.
3. Xcode pedirá un **Bundle Identifier** válido (algo tipo `com.tunombre.renuevo`) y un
   equipo de firma (**Signing & Capabilities** → tu Apple ID, aunque sea cuenta gratuita
   funciona para correr localmente).
4. En el selector de esquema/dispositivo arriba de Xcode, cambia el destino a **My Mac
   (Mac Catalyst)** y corre (⌘R). Se abrirá como app de escritorio, con las 3 pestañas
   (Hoy / Metas / Diario) funcionando igual, y las notificaciones locales llegarán como
   notificaciones normales de macOS.

**Sobre el widget en Mac:** desde macOS 14 (Sonoma), los widgets de apps con soporte
Catalyst también pueden agregarse al escritorio o al Centro de Notificaciones del Mac.
Para habilitarlo, repite el paso 2 pero en el target `RenuevoWidget` (agrega también
**Mac (Mac Catalyst)** como destino soportado). Si ese target no muestra la opción de
Catalyst en tu versión de Xcode, la alternativa es dejar el widget solo en iPhone y usar
igualmente la app de escritorio para metas/diario — ambas comparten el mismo dato local
en cada dispositivo (recuerda: todo es local, no se sincroniza entre iPhone y Mac).

## Personalizar

- Frases: edita `Shared/QuoteLibrary.swift` — agrega, quita o traduce mensajes.
- Colores: `Shared/Theme.swift`.
- Hora por defecto del recordatorio: `RenuevoApp/Notifications/NotificationManager.swift`
  (por defecto 8:00 a. m.).

## Limitación importante

No pude compilar ni correr este proyecto en esta sesión porque esta máquina solo tiene
las Command Line Tools de Xcode, no Xcode.app. El código sigue las APIs estándar de
SwiftUI/WidgetKit/UserNotifications para iOS 16+, pero revisa los primeros errores de
compilación en tu Xcode por si tu versión de SDK difiere ligeramente.
