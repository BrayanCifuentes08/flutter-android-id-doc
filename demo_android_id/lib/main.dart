import 'package:demo_android_id/android_id.dart'; // Importa el notifier encargado de obtener y manejar el Android ID
import 'package:flutter/material.dart'; // Importa los widgets base de Flutter (Material Design)
import 'package:flutter/services.dart'; // Importa utilidades del sistema, en este caso para copiar texto al portapapeles
import 'package:provider/provider.dart'; // Importa Provider para manejo de estado

// Punto de entrada principal de la aplicación
void main() {
  // Se inicializa la aplicación envolviéndola en un ChangeNotifierProvider
  // para que el AndroidIdNotifier esté disponible en todo el árbol de widgets
  runApp(
    ChangeNotifierProvider(
      // Se crea la instancia del notifier y se ejecuta inmediatamente
      // la obtención del Android ID
      create: (_) => AndroidIdNotifier()..obtenerAndroidId(),
      child: const MyApp(),
    ),
  );
}

// Widget raíz de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configura la aplicación base
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DEMO ANDROID ID")),
      body: Center(
        // Botón que dispara la apertura del diálogo
        child: ElevatedButton(
          child: const Text('Acerca De'), // Texto del botón
          onPressed: () {
            _mostrarDialogo(context); // Evento al presionar el botón
          },
        ),
      ),
    );
  }

  // Método encargado de mostrar el AlertDialog
  void _mostrarDialogo(BuildContext context) {
    showDialog(
      // Contexto necesario para mostrar el diálogo
      context: context,
      // Construcción del diálogo
      builder: (context) => AlertDialog(
        title: Text('Acerca de'), // Título del diálogo
        // Contenido principal del diálogo
        content: Column(
          // Ajusta el tamaño del diálogo al contenido
          mainAxisSize: MainAxisSize.min,
          // Alinea el contenido al inicio horizontal
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información general de la aplicación, traer versión y nombre de empresa
            Text('Versión: 1.0.0\nEmpresa Demo'),
            SizedBox(height: 16), // Espaciado vertical
            // Sección que muestra el Android ID usando Provider
            Consumer<AndroidIdNotifier>(
              // Se reconstruye automáticamente cuando cambia el estado
              builder: (context, deviceNotifier, child) {
                final deviceId = deviceNotifier.androidId ?? "Cargando...";
                // Permite interacción al tocar el Android ID
                return GestureDetector(
                  // Evento al tocar el ID
                  onTap: () {
                    // Verifica que el Android ID ya esté disponible
                    if (deviceNotifier.androidId != null) {
                      // Copia el Android ID al portapapeles
                      Clipboard.setData(
                        ClipboardData(text: deviceNotifier.androidId!),
                      );
                      // Muestra un mensaje de confirmación
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Device ID copiado al portapapeles"),
                        ),
                      );
                    }
                  },
                  // Contenedor visual del Android ID
                  child: Row(
                    children: [
                      // Icono representativo del dispositivo
                      Icon(
                        Icons.phone_iphone,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      // Espacio entre icono y texto
                      SizedBox(width: 8),
                      // Texto del Android ID
                      Expanded(
                        child: Text(
                          deviceId,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        // Acciones del diálogo
        actions: [
          // Botón para cerrar el diálogo
          TextButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
