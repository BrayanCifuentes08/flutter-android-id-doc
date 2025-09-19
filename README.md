# flutter-android-id-doc
Ejemplo en Flutter que muestra cómo obtener el Android ID de un dispositivo utilizando el paquete device_info_plus . Incluye un ChangeNotifier para gestionar el estado y facilitar la integración con Provider u otros manejadores de estado.

# 📱 Flutter Android ID Example

Este repositorio contiene un ejemplo práctico en **Flutter** para obtener el **Android ID** de un dispositivo utilizando el paquete [`device_info_plus`](https://pub.dev/packages/device_info_plus).  
El código implementa un `ChangeNotifier` para manejar el estado y un `Consumer` para mostrar el identificador en la UI, permitiendo copiarlo al portapapeles de forma sencilla.

---

## 🚀 Instalación

1. Agrega la dependencia al archivo `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  device_info_plus: ^12.1.0   # Asegúrate de usar la última versión
  provider: ^6.0.0            # Para manejar el estado con ChangeNotifier
```

2. Instala los paquetes:

```bash
3. flutter pub get
```

## 📂 Código principal

### 📌 Clase AndroidIdNotifier

Esta clase es la encargada de obtener y exponer el Android ID.
Se implementa como ChangeNotifier para que los widgets que lo consumen se actualicen automáticamente.

```dart
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AndroidIdNotifier extends ChangeNotifier {
  String? _androidId;

  String? get androidId => _androidId;

  Future<void> obtenerAndroidId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      _androidId = androidInfo.androidId; //  Captura del Android ID
    } catch (e) {
      _androidId = "No disponible";
    }
    notifyListeners();
  }
}
```

### 🖥️ Uso en la interfaz (UI)

En este ejemplo se muestra un AlertDialog que incluye:
- Versión y empresa (simulado con UtilitiesService).
- El Device ID con un ícono y la posibilidad de copiarlo al portapapeles con un SnackBar de confirmación.
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Acerca de'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Versión: ${UtilitiesService.version}\n${UtilitiesService.nombreEmpresa}',
        ),
        SizedBox(height: 16),
        // --- Android ID con icono e interacción ---
        Consumer<AndroidIdNotifier>(
          builder: (context, deviceNotifier, child) {
            final deviceId = deviceNotifier.androidId ?? "Cargando...";
            return GestureDetector(
              onTap: () {
                if (deviceNotifier.androidId != null) {
                  Clipboard.setData(
                    ClipboardData(text: deviceNotifier.androidId!),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Device ID copiado al portapapeles")),
                  );
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.phone_iphone,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      deviceId,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
    actions: [
      TextButton(
        child: Text('Cerrar'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  ),
);
```

### ⚙️ Configuración del Provider

Para que el AndroidIdNotifier funcione correctamente, se debe inicializar en el árbol de widgets principal:

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AndroidIdNotifier()..obtenerAndroidId(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
```

### 📖 Explicación paso a paso

1. Dependencia: Se usa device_info_plus para acceder a la información del dispositivo.
2. Notifier: AndroidIdNotifier gestiona el estado y notifica a los listeners cuando el ID cambia.
3. UI dinámica: Con Consumer<AndroidIdNotifier>, la vista se actualiza automáticamente cuando se obtiene el Android ID.
4. Interacción: El ID se puede copiar al portapapeles haciendo tap, mostrando un SnackBar como confirmación.

## 🔬 Pruebas recomendadas

El comportamiento del Android ID puede variar según lo que hagas con la aplicación o el dispositivo.
Pasos de prueba sugeridos:

1. Instalar la app por primera vez
    - El Android ID será generado y mostrado en la sección Acerca de.

2. Cerrar y volver a abrir la app
    - El Android ID no cambia (permanece igual).

3. Desinstalar la app y volverla a instalar o cuando se borran datos de la app.
    - El Android ID se mantiene igual.

4. Actualizar la app (instalar un APK más nuevo sin desinstalar)
    - El Android ID no cambia.

5. Reiniciar el dispositivo
    - El Android ID no cambia.

6. Restablecer el dispositivo a valores de fábrica
    - El Android ID sí cambia, porque el sistema genera uno nuevo.


## ✅ Conclusión
Este ejemplo es útil para:
- Mostrar información del dispositivo en una sección “Acerca de” de la app.
- Usar el Android ID como identificador interno en pruebas o registros.
- Ten en cuenta que el Android ID no es 100% persistente y puede variar en un restablecimientos de fábrica.






