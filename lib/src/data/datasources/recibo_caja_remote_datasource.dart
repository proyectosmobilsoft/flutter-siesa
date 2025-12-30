import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/errors/server_exception.dart';

/// Fuente de datos remota para procesar recibos de caja
abstract class IReciboCajaRemoteDataSource {
  /// Procesa un recibo de caja
  Future<Map<String, dynamic>> procesarReciboCaja(Map<String, dynamic> reciboData);
}

/// Implementación de la fuente de datos remota para recibos de caja
class ReciboCajaRemoteDataSource implements IReciboCajaRemoteDataSource {
  final http.Client client;

  ReciboCajaRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<Map<String, dynamic>> procesarReciboCaja(
      Map<String, dynamic> reciboData) async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/api/recibo-caja/procesar');

      print('🔗 Procesando recibo de caja en: $uri');
      print('📦 Datos enviados: ${jsonEncode(reciboData)}');

      final response = await client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(reciboData),
          )
          .timeout(
            Duration(seconds: AppConfig.httpTimeout),
            onTimeout: () {
              throw ServerException(
                'Tiempo de espera agotado. Verifica que la API esté corriendo en ${AppConfig.baseUrl}',
              );
            },
          );

      print('📡 Respuesta recibida: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final dynamic decodedBody = json.decode(response.body);
          if (decodedBody is Map<String, dynamic>) {
            print('✅ Recibo procesado exitosamente');
            return decodedBody;
          } else {
            throw ServerException(
                'Formato de respuesta inesperado de la API. Se esperaba un objeto JSON');
          }
        } catch (e) {
          if (e is ServerException) rethrow;
          throw ServerException(
              'Error al parsear la respuesta JSON: ${e.toString()}');
        }
      } else {
        // Intentar parsear el error del servidor
        String errorMessage = 'Error del servidor (${response.statusCode})';
        try {
          final errorBody = json.decode(response.body);
          if (errorBody is Map<String, dynamic>) {
            errorMessage = errorBody['message'] as String? ??
                errorBody['error'] as String? ??
                errorMessage;
          }
        } catch (_) {
          // Si no se puede parsear, usar el body completo si está disponible
          if (response.body.isNotEmpty) {
            final bodyPreview = response.body.length > 200
                ? '${response.body.substring(0, 200)}...'
                : response.body;
            errorMessage = '$errorMessage: $bodyPreview';
          }
        }
        throw ServerException(errorMessage, response.statusCode);
      }
    } on ServerException {
      rethrow;
    } on http.ClientException catch (e) {
      print('❌ Error de conexión: ${e.message}');
      throw ServerException(
        'No se pudo conectar al servidor. Verifica:\n'
        '1. Que la API esté corriendo en ${AppConfig.baseUrl}\n'
        '2. Que tu dispositivo/emulador tenga acceso a la red\n'
        '3. Que la IP configurada sea correcta\n'
        'Error: ${e.message}',
      );
    } on FormatException catch (e) {
      throw ServerException('Error al procesar la respuesta: ${e.message}');
    } catch (e) {
      print('❌ Error inesperado: $e');
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }
}

