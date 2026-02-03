import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modelo de reembolso guardado
class ReembolsoGuardado {
  final String id;
  final String numeroReembolso;
  final String fecha;
  final String beneficiario;
  final String nit;
  final String concepto;
  final double valor;
  final String formaPago;
  final String? cuentaBancaria;
  final String? documentoReferencia;
  final String? observaciones;
  final DateTime fechaCreacion;

  ReembolsoGuardado({
    required this.id,
    required this.numeroReembolso,
    required this.fecha,
    required this.beneficiario,
    required this.nit,
    required this.concepto,
    required this.valor,
    required this.formaPago,
    this.cuentaBancaria,
    this.documentoReferencia,
    this.observaciones,
    required this.fechaCreacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numeroReembolso': numeroReembolso,
      'fecha': fecha,
      'beneficiario': beneficiario,
      'nit': nit,
      'concepto': concepto,
      'valor': valor,
      'formaPago': formaPago,
      'cuentaBancaria': cuentaBancaria,
      'documentoReferencia': documentoReferencia,
      'observaciones': observaciones,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  factory ReembolsoGuardado.fromMap(Map<String, dynamic> map) {
    return ReembolsoGuardado(
      id: map['id'] as String,
      numeroReembolso: map['numeroReembolso'] as String,
      fecha: map['fecha'] as String,
      beneficiario: map['beneficiario'] as String,
      nit: map['nit'] as String,
      concepto: map['concepto'] as String,
      valor: (map['valor'] as num).toDouble(),
      formaPago: map['formaPago'] as String,
      cuentaBancaria: map['cuentaBancaria'] as String?,
      documentoReferencia: map['documentoReferencia'] as String?,
      observaciones: map['observaciones'] as String?,
      fechaCreacion: DateTime.parse(map['fechaCreacion'] as String),
    );
  }
}

/// Notifier para gestionar reembolsos guardados
class ReembolsoListNotifier extends Notifier<List<ReembolsoGuardado>> {
  @override
  List<ReembolsoGuardado> build() {
    return [];
  }

  Future<void> agregarReembolso(ReembolsoGuardado reembolso) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    state = [reembolso, ...state];
  }

  List<ReembolsoGuardado> obtenerReembolsos() => state;

  ReembolsoGuardado? obtenerPorId(String id) {
    try {
      return state.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> eliminarReembolso(String id) async {
    state = state.where((r) => r.id != id).toList();
  }
}

final reembolsoListNotifierProvider =
    NotifierProvider<ReembolsoListNotifier, List<ReembolsoGuardado>>(
  ReembolsoListNotifier.new,
);
