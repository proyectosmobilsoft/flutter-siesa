/// Configuración de la aplicación
/// Maneja los diferentes ambientes (local y producción)
class AppConfig {
  /// Ambiente actual de la aplicación
  static const Environment _environment = Environment.local;

  /// IP local de la máquina para desarrollo
  /// IMPORTANTE: Cambiar por la IP de tu máquina (ej: '192.168.1.100')
  /// Para encontrar tu IP en Windows: ipconfig
  /// Para encontrar tu IP en Mac/Linux: ifconfig o ip addr
  ///
  /// NOTA: No uses 'localhost' en dispositivos móviles/emuladores porque
  /// se refiere al dispositivo mismo, no a tu máquina de desarrollo.
  /// Usa la IP real de tu máquina o '10.0.2.2' para emulador Android.
  // static const String localIp = '10.0.2.2'; // Para emulador Android
  // static const String localIp = 'localhost'; // Solo funciona en navegador web
  static const String localIp =
      '179.33.214.87'; // IP de la máquina (o usa tu IP local)

  /// URL base de la API según el ambiente
  static String get baseUrl {
    switch (_environment) {
      case Environment.local:
        // Usar IP en lugar de localhost para dispositivos móviles
        return 'http://$localIp:3010';
      case Environment.production:
        return 'https://api.produccion.com'; // TODO: Reemplazar con URL real
    }
  }

  /// Timeout para las peticiones HTTP (en segundos)
  static const int httpTimeout = 15;
}

/// Enum para los diferentes ambientes
enum Environment { local, production }
