import 'package:flutter/foundation.dart';

import '../../domain/entities/factura.dart';

/// Modelo de datos que representa una factura desde la API
class FacturaModel extends Factura {
  FacturaModel({
    required super.sucursal,
    required super.tipo,
    required super.factura,
    required super.fecha,
    required super.vence,
    required super.valor,
    required super.abonos,
    required super.saldo,
    super.valRecibo,
    super.ok,
    super.idCia,
    super.rowid,
    super.idCo,
    super.idTipoDocto,
    super.consecDocto,
    super.prefijo,
    super.idPeriodo,
    super.rowidTercero,
    super.idSucursal,
    super.totalDb,
    super.totalCr,
    super.idClaseDocto,
    super.indEstado,
    super.indTransmit,
    super.fechaTsCreacion,
    super.fechaTsActualizacion,
    super.fechaTsAprobacion,
    super.fechaTsAnulacion,
    super.usuarioCreacion,
    super.usuarioActualizacion,
    super.usuarioAprobacion,
    super.usuarioAnulacion,
    super.totalBaseGravable,
    super.indImpresion,
    super.nroImpresiones,
    super.fechaTsHabilitaImp,
    super.usuarioHabilitaImp,
    super.notas,
    super.rowidDoctoBase,
    super.referencia,
    super.idMandato,
    super.rowidMovtoEntidad,
    super.idMotivoOtros,
    super.idMonedaDocto,
    super.idMonedaConv,
    super.indFormaConv,
    super.tasaConv,
    super.idMonedaLocal,
    super.indFormaLocal,
    super.tasaLocal,
    super.idTipoCambio,
    super.indCfd,
    super.usuarioImpresion,
    super.fechaTsImpresion,
    super.rowidTePlantilla,
    super.totalDb2,
    super.totalCr2,
    super.totalDb3,
    super.totalCr3,
    super.indImptoAsumido,
    super.rowidSesion,
    super.indTipoOrigen,
    super.rowidDoctoRp,
    super.idProyecto,
    super.indDifCambioForma,
    super.indClaseOrigen,
    super.indEnvioCorreo,
    super.usuarioEnvioCorreo,
    super.fechaTsEnvioCorreo,
  });

  /// Helper para parsear números con comas como separador decimal
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      // Reemplazar comas por puntos para parsear números
      final cleaned = value.replaceAll(',', '.').trim();
      if (cleaned.isEmpty || cleaned == 'NULL') return null;
      return double.tryParse(cleaned);
    }
    return null;
  }

  /// Helper para parsear enteros
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) {
      final cleaned = value.trim();
      if (cleaned.isEmpty || cleaned == 'NULL') return null;
      return int.tryParse(cleaned);
    }
    return null;
  }

  /// Helper para parsear strings
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || trimmed == 'NULL') return null;
      return trimmed;
    }
    // Si es un número, convertirlo a string
    if (value is num) {
      return value.toString();
    }
    return value.toString().trim();
  }

  /// Helper para parsear números con coma como separador decimal (formato: "500000000,00")
  static double? _parseDoubleWithComma(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      // El formato viene como "500000000,00" (coma como separador decimal)
      // Reemplazar coma por punto para parsear
      final cleaned = value.trim().replaceAll(',', '.');
      if (cleaned.isEmpty || cleaned == 'NULL') return null;
      return double.tryParse(cleaned);
    }
    return null;
  }

  /// Helper para parsear fecha en formato "2025-07-08 00:00:00.000"
  static String _parseFecha(String? fechaValue) {
    if (fechaValue == null || fechaValue.isEmpty) return '';
    // Extraer solo la fecha (antes del espacio)
    return fechaValue.split(' ')[0];
  }

  /// Crea un FacturaModel desde un JSON
  factory FacturaModel.fromJson(Map<String, dynamic> json) {
    // Mapear campos desde el nuevo formato del endpoint
    // Los nuevos campos son: rowidsa, idco, idun, doccruce, fecha, fecha_vcto_docto, vencimiento, etc.
    
    // rowidsa → rowid
    final rowid = _parseInt(json['rowidsa']) ?? _parseInt(json['rowid']);
    
    // idco → idCo
    final idCo = _parseString(json['idco']) ?? _parseString(json['idCo']) ?? '001';
    
    // idun → idUn (nuevo campo, no se mapea directamente pero se puede usar si es necesario)
    
    // doccruce → doccruce (usado para extraer número de factura)
    final doccruce = _parseString(json['doccruce']) ?? '';
    
    // fecha → fecha (formato: "2025-06-30 00:00:00.000")
    final fechaRaw = json['fecha'];
    final fecha = fechaRaw != null 
        ? _parseFecha(fechaRaw.toString())
        : '';
    
    // fecha_vcto_docto → fecha_vcto_docto (nuevo campo)
    final fechaVctoDoctoRaw = json['fecha_vcto_docto'];
    final fechaVctoDocto = fechaVctoDoctoRaw != null 
        ? _parseFecha(fechaVctoDoctoRaw.toString())
        : '';
    
    // vencimiento → vence (formato: "2025-07-08 00:00:00.000")
    final vencimientoRaw = json['vencimiento'];
    final vence = vencimientoRaw != null 
        ? _parseFecha(vencimientoRaw.toString())
        : (fechaVctoDocto.isNotEmpty ? fechaVctoDocto : '');
    
    // diasvencidos → diasvencidos (nuevo campo, no se mapea directamente)
    
    // saldo → saldo (formato: "247950000,00" con coma como separador decimal)
    final saldoRaw = json['saldo'];
    final saldo = saldoRaw != null
        ? _parseDoubleWithComma(saldoRaw.toString()) ?? 0.0
        : 0.0;
    
    // saldoalterno → saldoalterno (nuevo campo, no se mapea directamente)
    
    // chequesposfechados → chequesposfechados (nuevo campo, no se mapea directamente)
    
    // idtercero → rowidTercero
    final rowidTercero = _parseInt(json['idtercero']) ?? _parseInt(json['rowidTercero']);
    
    // nittercero → nittercero (nuevo campo, no se mapea directamente)
    
    // razontercero → razontercero (nuevo campo, no se mapea directamente)
    
    // idsucursal → idSucursal
    final idSucursalRaw = json['idsucursal'] ?? json['idSucursal'] ?? json['sucursal'];
    final idSucursal = idSucursalRaw != null 
        ? (idSucursalRaw is String ? idSucursalRaw.trim() : idSucursalRaw.toString().trim())
        : '001';
    
    // dessucursal → dessucursal (nuevo campo, no se mapea directamente)
    
    // idauxiliar → idauxiliar (nuevo campo, no se mapea directamente)
    
    // desauxiliar → desauxiliar (nuevo campo, no se mapea directamente)
    
    // idvendedor → idvendedor (nuevo campo, no se mapea directamente)
    
    // desvendedor → desvendedor (nuevo campo, no se mapea directamente)
    
    // fechaprontopago → fechaprontopago (nuevo campo, no se mapea directamente)
    
    // valordescuentopp → valordescuentopp (nuevo campo, no se mapea directamente)
    
    // notas → notas
    final notas = _parseString(json['notas']);
    
    // simbolomoneda → simbolomoneda (nuevo campo, no se mapea directamente)
    
    // formatototalmoneda → formatototalmoneda (nuevo campo, no se mapea directamente)
    
    // idmoneda → idMonedaDocto
    final idMonedaDocto = _parseString(json['idmoneda']) ?? _parseString(json['idMonedaDocto']);
    
    // decimalesmoneda → decimalesmoneda (nuevo campo, no se mapea directamente)
    
    // fecha_docto_cruce → fecha_docto_cruce (nuevo campo)
    final fechaDoctoCruceRaw = json['fecha_docto_cruce'];
    final fechaDoctoCruce = fechaDoctoCruceRaw != null
        ? _parseFecha(fechaDoctoCruceRaw.toString())
        : fecha;
    
    // prefijo → prefijo
    final prefijo = _parseString(json['prefijo']) ?? '';
    
    // Extraer número de factura desde doccruce si está disponible
    // Formato: "BQE-00026024-000" → extraer "00026024"
    String facturaFinal = '';
    if (doccruce.isNotEmpty) {
      final parts = doccruce.split('-');
      if (parts.length >= 2) {
        facturaFinal = parts[1]; // Tomar la parte del medio
      } else {
        facturaFinal = doccruce;
      }
    }
    
    // Si no hay factura desde doccruce, intentar otros campos
    if (facturaFinal.isEmpty) {
      facturaFinal = _parseString(json['factura']) ?? 
                     _parseString(json['consecDocto']) ?? 
                     _parseString(json['f350_consec_docto']) ?? '';
    }
    
    // Determinar tipo de documento desde prefijo o doccruce
    String tipoFinal = '';
    if (doccruce.isNotEmpty) {
      final parts = doccruce.split('-');
      if (parts.isNotEmpty) {
        tipoFinal = parts[0]; // Tomar el prefijo del doccruce (ej: "BQE")
      }
    }
    if (tipoFinal.isEmpty) {
      tipoFinal = prefijo.isNotEmpty 
          ? prefijo
          : (_parseString(json['tipo']) ?? 
             _parseString(json['idTipoDocto']) ?? 
             _parseString(json['f350_id_tipo_docto']) ?? '');
    }
    
    // Usar fecha_docto_cruce como fecha principal, o fecha si no existe
    final fechaFinal = fechaDoctoCruce.isNotEmpty ? fechaDoctoCruce : fecha;
    
    // Calcular valor y abonos desde saldo
    final valorFinal = saldo;
    final abonosFinal = 0.0; // Los abonos no vienen en el nuevo formato
    
    debugPrint('🔍 Factura parseada - Tipo: "$tipoFinal", Factura: "$facturaFinal", Vence: "$vence", Saldo: $saldo');
    
    final totalDb = _parseDouble(json['f350_total_db']) ?? valorFinal;
    final totalCr = _parseDouble(json['f350_total_cr']) ?? abonosFinal;

    return FacturaModel(
      // Campos principales mapeados desde el nuevo formato
      sucursal: idSucursal.isNotEmpty 
          ? idSucursal
          : (_parseString(json['sucursal']) ?? '001'),
      tipo: tipoFinal,
      factura: facturaFinal,
      fecha: fechaFinal,
      vence: vence,
      valor: valorFinal,
      abonos: abonosFinal,
      saldo: saldo,
      valRecibo: 0.0,
      ok: false,
      // Campos adicionales
      idCia: _parseInt(json['f350_id_cia']) ?? _parseInt(json['idCia']),
      rowid: rowid,
      idCo: idCo,
      idTipoDocto: tipoFinal,
      consecDocto: facturaFinal,
      prefijo: prefijo,
      idPeriodo: _parseString(json['f350_id_periodo']) ?? _parseString(json['idPeriodo']),
      rowidTercero: rowidTercero,
      idSucursal: idSucursal.isNotEmpty ? idSucursal : '001',
      totalDb: totalDb,
      totalCr: totalCr,
      idClaseDocto: _parseString(json['f350_id_clase_docto']),
      indEstado: _parseInt(json['f350_ind_estado']),
      indTransmit: _parseInt(json['f350_ind_transmit']),
      fechaTsCreacion: _parseString(json['f350_fecha_ts_creacion']),
      fechaTsActualizacion: _parseString(json['f350_fecha_ts_actualizacion']),
      fechaTsAprobacion: _parseString(json['f350_fecha_ts_aprobacion']),
      fechaTsAnulacion: _parseString(json['f350_fecha_ts_anulacion']),
      usuarioCreacion: _parseString(json['f350_usuario_creacion']),
      usuarioActualizacion: _parseString(json['f350_usuario_actualizacion']),
      usuarioAprobacion: _parseString(json['f350_usuario_aprobacion']),
      usuarioAnulacion: _parseString(json['f350_usuario_anulacion']),
      totalBaseGravable: _parseDouble(json['f350_total_base_gravable']),
      indImpresion: _parseInt(json['f350_ind_impresion']),
      nroImpresiones: _parseInt(json['f350_nro_impresiones']),
      fechaTsHabilitaImp: _parseString(json['f350_fecha_ts_habilita_imp']),
      usuarioHabilitaImp: _parseString(json['f350_usuario_habilita_imp']),
      notas: notas ?? _parseString(json['f350_notas']),
      rowidDoctoBase: _parseInt(json['f350_rowid_docto_base']),
      referencia: _parseString(json['f350_referencia']),
      idMandato: _parseString(json['f350_id_mandato']),
      rowidMovtoEntidad: _parseInt(json['f350_rowid_movto_entidad']),
      idMotivoOtros: _parseString(json['f350_id_motivo_otros']),
      idMonedaDocto: idMonedaDocto ?? _parseString(json['f350_id_moneda_docto']),
      idMonedaConv: _parseString(json['f350_id_moneda_conv']),
      indFormaConv: _parseInt(json['f350_ind_forma_conv']),
      tasaConv: _parseDouble(json['f350_tasa_conv']),
      idMonedaLocal: _parseString(json['f350_id_moneda_local']),
      indFormaLocal: _parseInt(json['f350_ind_forma_local']),
      tasaLocal: _parseDouble(json['f350_tasa_local']),
      idTipoCambio: _parseString(json['f350_id_tipo_cambio']),
      indCfd: _parseInt(json['f350_ind_cfd']),
      usuarioImpresion: _parseString(json['f350_usuario_impresion']),
      fechaTsImpresion: _parseString(json['f350_fecha_ts_impresion']),
      rowidTePlantilla: _parseInt(json['f350_rowid_te_plantilla']),
      totalDb2: _parseDouble(json['f350_total_db2']),
      totalCr2: _parseDouble(json['f350_total_cr2']),
      totalDb3: _parseDouble(json['f350_total_db3']),
      totalCr3: _parseDouble(json['f350_total_cr3']),
      indImptoAsumido: _parseInt(json['f350_ind_impto_asumido']),
      rowidSesion: _parseInt(json['f350_rowid_sesion']),
      indTipoOrigen: _parseInt(json['f350_ind_tipo_origen']),
      rowidDoctoRp: _parseInt(json['f350_rowid_docto_rp']),
      idProyecto: _parseString(json['f350_id_proyecto']),
      indDifCambioForma: _parseInt(json['f350_ind_dif_cambio_forma']),
      indClaseOrigen: _parseInt(json['f350_ind_clase_origen']),
      indEnvioCorreo: _parseInt(json['f350_ind_envio_correo']),
      usuarioEnvioCorreo: _parseString(json['f350_usuario_envio_correo']),
      fechaTsEnvioCorreo: _parseString(json['f350_fecha_ts_envio_correo']),
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'sucursal': sucursal,
      'tipo': tipo,
      'factura': factura,
      'fecha': fecha,
      'vence': vence,
      'valor': valor,
      'abonos': abonos,
      'saldo': saldo,
    };
  }

  /// Convierte el modelo a entidad de dominio
  Factura toEntity() {
    return Factura(
      sucursal: sucursal,
      tipo: tipo,
      factura: factura,
      fecha: fecha,
      vence: vence,
      valor: valor,
      abonos: abonos,
      saldo: saldo,
      valRecibo: valRecibo,
      ok: ok,
      idCia: idCia,
      rowid: rowid,
      idCo: idCo,
      idTipoDocto: idTipoDocto,
      consecDocto: consecDocto,
      prefijo: prefijo,
      idPeriodo: idPeriodo,
      rowidTercero: rowidTercero,
      idSucursal: idSucursal,
      totalDb: totalDb,
      totalCr: totalCr,
      idClaseDocto: idClaseDocto,
      indEstado: indEstado,
      indTransmit: indTransmit,
      fechaTsCreacion: fechaTsCreacion,
      fechaTsActualizacion: fechaTsActualizacion,
      fechaTsAprobacion: fechaTsAprobacion,
      fechaTsAnulacion: fechaTsAnulacion,
      usuarioCreacion: usuarioCreacion,
      usuarioActualizacion: usuarioActualizacion,
      usuarioAprobacion: usuarioAprobacion,
      usuarioAnulacion: usuarioAnulacion,
      totalBaseGravable: totalBaseGravable,
      indImpresion: indImpresion,
      nroImpresiones: nroImpresiones,
      fechaTsHabilitaImp: fechaTsHabilitaImp,
      usuarioHabilitaImp: usuarioHabilitaImp,
      notas: notas,
      rowidDoctoBase: rowidDoctoBase,
      referencia: referencia,
      idMandato: idMandato,
      rowidMovtoEntidad: rowidMovtoEntidad,
      idMotivoOtros: idMotivoOtros,
      idMonedaDocto: idMonedaDocto,
      idMonedaConv: idMonedaConv,
      indFormaConv: indFormaConv,
      tasaConv: tasaConv,
      idMonedaLocal: idMonedaLocal,
      indFormaLocal: indFormaLocal,
      tasaLocal: tasaLocal,
      idTipoCambio: idTipoCambio,
      indCfd: indCfd,
      usuarioImpresion: usuarioImpresion,
      fechaTsImpresion: fechaTsImpresion,
      rowidTePlantilla: rowidTePlantilla,
      totalDb2: totalDb2,
      totalCr2: totalCr2,
      totalDb3: totalDb3,
      totalCr3: totalCr3,
      indImptoAsumido: indImptoAsumido,
      rowidSesion: rowidSesion,
      indTipoOrigen: indTipoOrigen,
      rowidDoctoRp: rowidDoctoRp,
      idProyecto: idProyecto,
      indDifCambioForma: indDifCambioForma,
      indClaseOrigen: indClaseOrigen,
      indEnvioCorreo: indEnvioCorreo,
      usuarioEnvioCorreo: usuarioEnvioCorreo,
      fechaTsEnvioCorreo: fechaTsEnvioCorreo,
    );
  }
}

/// Modelo para la respuesta paginada de facturas
class PaginatedFacturasResponse {
  final List<FacturaModel> facturas;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  const PaginatedFacturasResponse({
    required this.facturas,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  /// Crea un PaginatedFacturasResponse desde un JSON
  factory PaginatedFacturasResponse.fromJson(
    Map<String, dynamic> json,
    int currentPage,
    int currentPageSize,
  ) {
    List<dynamic> facturasList = [];
    
    // Intentar obtener la lista de facturas de diferentes formas
    if (json['data'] is List) {
      facturasList = json['data'] as List<dynamic>;
    } else if (json['facturas'] is List) {
      facturasList = json['facturas'] as List<dynamic>;
    }
    
    final facturas = facturasList
        .map((json) => FacturaModel.fromJson(json as Map<String, dynamic>))
        .toList();

    // Obtener información de paginación del objeto pagination si existe
    final pagination = json['pagination'] as Map<String, dynamic>?;
    final total = pagination?['total'] as int? ?? 
                  json['total'] as int? ?? 
                  json['count'] as int? ?? 
                  facturas.length;
    
    // Obtener totalPages del objeto pagination
    final totalPages = pagination?['totalPages'] as int?;
    final hasMore = totalPages != null 
        ? (currentPage < totalPages)
        : (json['hasMore'] as bool? ??
           json['has_more'] as bool? ??
           (facturas.length >= currentPageSize));

    return PaginatedFacturasResponse(
      facturas: facturas,
      total: total,
      page: currentPage,
      pageSize: currentPageSize,
      hasMore: hasMore,
    );
  }
}

