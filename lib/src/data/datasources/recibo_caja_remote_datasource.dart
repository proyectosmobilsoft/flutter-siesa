import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../core/errors/server_exception.dart';

/// Modelo para la respuesta del próximo consecutivo
class ProximoConsecutivoResponse {
  ProximoConsecutivoResponse({
    required this.f022ConsProximo,
    required this.f022Prefijo,
    required this.f022ConsInicial,
    required this.f022ConsFinal,
    required this.f022IndAutomatico,
  });

  factory ProximoConsecutivoResponse.fromJson(Map<String, dynamic> json) {
    final proximoConsecutivo = json['proximoConsecutivo'];

    // Validar que proximoConsecutivo sea un Map
    if (proximoConsecutivo is! Map<String, dynamic>) {
      throw FormatException(
        'El campo "proximoConsecutivo" debe ser un objeto, pero se recibió: ${proximoConsecutivo.runtimeType}',
      );
    }

    final data = proximoConsecutivo;

    return ProximoConsecutivoResponse(
      f022ConsProximo: (data['f022_cons_proximo'] as num?)?.toInt() ?? 0,
      f022Prefijo: (data['f022_prefijo'] as String?)?.trim() ?? '',
      f022ConsInicial: (data['f022_cons_inicial'] as num?)?.toInt() ?? 0,
      f022ConsFinal: (data['f022_cons_final'] as num?)?.toInt() ?? 0,
      f022IndAutomatico: (data['f022_ind_automatico'] as num?)?.toInt() ?? 0,
    );
  }
  final int f022ConsProximo;
  final String f022Prefijo;
  final int f022ConsInicial;
  final int f022ConsFinal;
  final int f022IndAutomatico;
}

/// Fuente de datos remota para procesar recibos de caja
abstract class IReciboCajaRemoteDataSource {
  /// Procesa un recibo de caja
  Future<Map<String, dynamic>> procesarReciboCaja(
    Map<String, dynamic> reciboData,
  );

  /// Obtiene el próximo consecutivo para un recibo de caja
  Future<ProximoConsecutivoResponse> obtenerProximoConsecutivo({
    required int idCia,
    String idTipoDocto = 'RCC',
    String idCo = '001',
    int pBloquear = 0,
    int pLeerMandatoTipo = 0,
  });
}

/// Implementación de la fuente de datos remota para recibos de caja
class ReciboCajaRemoteDataSource implements IReciboCajaRemoteDataSource {
  ReciboCajaRemoteDataSource({http.Client? client})
    : client = client ?? http.Client();
  final http.Client client;

  @override
  Future<Map<String, dynamic>> procesarReciboCaja(
    Map<String, dynamic> reciboData,
  ) async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/api/recibo-caja/procesar');

      print('🔗 Procesando recibo de caja en: $uri');
      print('📦 Datos enviados: ${jsonEncode(reciboData)}');

      final response = await client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(reciboData),
          )
          .timeout(
            const Duration(seconds: AppConfig.httpTimeout),
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
              'Formato de respuesta inesperado de la API. Se esperaba un objeto JSON',
            );
          }
        } catch (e) {
          if (e is ServerException) rethrow;
          throw ServerException(
            'Error al parsear la respuesta JSON: ${e.toString()}',
          );
        }
      } else {
        // Intentar parsear el error del servidor
        String errorMessage = 'Error del servidor (${response.statusCode})';
        try {
          final errorBody = json.decode(response.body);
          if (errorBody is Map<String, dynamic>) {
            errorMessage =
                errorBody['message'] as String? ??
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

  @override
  Future<ProximoConsecutivoResponse> obtenerProximoConsecutivo({
    required int idCia,
    String idTipoDocto = 'RCC',
    String idCo = '001',
    int pBloquear = 0,
    int pLeerMandatoTipo = 0,
  }) async {
    try {
      final uri =
          Uri.parse(
            '${AppConfig.baseUrl}/api/recibo-caja/proximo-consecutivo',
          ).replace(
            queryParameters: {
              'id_cia': idCia.toString(),
              'id_tipo_docto': idTipoDocto,
              'id_co': idCo,
              'p_bloquear': pBloquear.toString(),
              'p_leer_mandato_tipo': pLeerMandatoTipo.toString(),
            },
          );

      print('🔗 Obteniendo próximo consecutivo en: $uri');

      final response = await client
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(
            const Duration(seconds: AppConfig.httpTimeout),
            onTimeout: () {
              throw ServerException(
                'Tiempo de espera agotado. Verifica que la API esté corriendo en ${AppConfig.baseUrl}',
              );
            },
          );

      print('📡 Respuesta recibida: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('❌ Error en respuesta: ${response.body}');
      }

      if (response.statusCode == 200) {
        try {
          final dynamic decodedBody = json.decode(response.body);
          if (decodedBody is Map<String, dynamic>) {
            if (decodedBody['success'] == true) {
              print('✅ Próximo consecutivo obtenido exitosamente');
              return ProximoConsecutivoResponse.fromJson(decodedBody);
            } else {
              throw ServerException(
                'Error al obtener próximo consecutivo: ${decodedBody['message'] ?? 'Error desconocido'}',
              );
            }
          } else {
            throw ServerException(
              'Formato de respuesta inesperado de la API. Se esperaba un objeto JSON',
            );
          }
        } catch (e) {
          if (e is ServerException) rethrow;
          throw ServerException(
            'Error al parsear la respuesta JSON: ${e.toString()}',
          );
        }
      } else {
        String errorMessage = 'Error del servidor (${response.statusCode})';

        // Mensaje específico para 404
        if (response.statusCode == 404) {
          errorMessage =
              'Endpoint no encontrado (404). Verifica que la ruta sea correcta: /api/recibo-caja/proximo-consecutivo';
        }

        try {
          final errorBody = json.decode(response.body);
          if (errorBody is Map<String, dynamic>) {
            final serverMessage =
                errorBody['message'] as String? ??
                errorBody['error'] as String?;
            if (serverMessage != null && serverMessage.isNotEmpty) {
              errorMessage = serverMessage;
            }
          }
        } catch (_) {
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
