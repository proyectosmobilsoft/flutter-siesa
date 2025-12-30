/// Modelo para el JSON del recibo de caja
class ReciboCajaModel {
  final int idCia;
  final String idCo;
  final String idTipoDocto;
  final int consecDocto;
  final String prefijo;
  final String fecha;
  final int periodo;
  final int rowidTercero;
  final String sucursal;
  final double totalDb;
  final double totalCr;
  final int indOrigen;
  final int indEstado;
  final int indTransmit;
  final String fechaCreacion;
  final String fechaActualiza;
  final String fechaAfectado;
  final String notas;
  final int pEstado;
  final String idUn;
  final int rowidAuxiliar;
  final int rowidCcosto;
  final int rowidFe;
  final String idCoMov;
  final double valorDb;
  final double valorCr;
  final String doctoBanco;
  final int nroDoctoBanco;
  final String idMediosPago;
  final double valor;
  final String idBanco;
  final int nroCheque;
  final String nroCuenta;
  final String codSeguridad;
  final String nroAutorizacion;
  final String fechaVcto;
  final String idCuentasBancarias;
  final String fechaConsignacion;
  final int rowidDoctoConsignacion;
  final int rowidMovDoctoConsignacion;
  final String idCausalesDevolucion;
  final String idSucursal;
  final int pRowidDoctoLetra;
  final String pIdUbicacionOrigen;
  final String pIdUbicacionDestino;
  final int pRowidSaOrigen;
  final int pRowidSaDestino;
  final String pIdCuentaBancaria;

  ReciboCajaModel({
    required this.idCia,
    required this.idCo,
    required this.idTipoDocto,
    required this.consecDocto,
    required this.prefijo,
    required this.fecha,
    required this.periodo,
    required this.rowidTercero,
    required this.sucursal,
    required this.totalDb,
    required this.totalCr,
    required this.indOrigen,
    required this.indEstado,
    required this.indTransmit,
    required this.fechaCreacion,
    required this.fechaActualiza,
    required this.fechaAfectado,
    required this.notas,
    required this.pEstado,
    required this.idUn,
    required this.rowidAuxiliar,
    required this.rowidCcosto,
    required this.rowidFe,
    required this.idCoMov,
    required this.valorDb,
    required this.valorCr,
    required this.doctoBanco,
    required this.nroDoctoBanco,
    required this.idMediosPago,
    required this.valor,
    required this.idBanco,
    required this.nroCheque,
    required this.nroCuenta,
    required this.codSeguridad,
    required this.nroAutorizacion,
    required this.fechaVcto,
    required this.idCuentasBancarias,
    required this.fechaConsignacion,
    required this.rowidDoctoConsignacion,
    required this.rowidMovDoctoConsignacion,
    required this.idCausalesDevolucion,
    required this.idSucursal,
    required this.pRowidDoctoLetra,
    required this.pIdUbicacionOrigen,
    required this.pIdUbicacionDestino,
    required this.pRowidSaOrigen,
    required this.pRowidSaDestino,
    required this.pIdCuentaBancaria,
  });

  /// Convierte el modelo a un Map para enviarlo como JSON
  Map<String, dynamic> toJson() {
    return {
      'id_cia': idCia,
      'id_co': idCo,
      'id_tipo_docto': idTipoDocto,
      'consec_docto': consecDocto,
      'prefijo': prefijo,
      'fecha': fecha,
      'periodo': periodo,
      'rowid_tercero': rowidTercero,
      'sucursal': sucursal,
      'total_db': totalDb,
      'total_cr': totalCr,
      'ind_origen': indOrigen,
      'ind_estado': indEstado,
      'ind_transmit': indTransmit,
      'fecha_creacion': fechaCreacion,
      'fecha_actualiza': fechaActualiza,
      'fecha_afectado': fechaAfectado,
      'notas': notas,
      'p_estado': pEstado,
      'id_un': idUn,
      'rowid_auxiliar': rowidAuxiliar,
      'rowid_ccosto': rowidCcosto,
      'rowid_fe': rowidFe,
      'id_co_mov': idCoMov,
      'valor_db': valorDb,
      'valor_cr': valorCr,
      'docto_banco': doctoBanco,
      'nro_docto_banco': nroDoctoBanco,
      'id_medios_pago': idMediosPago,
      'valor': valor,
      'id_banco': idBanco,
      'nro_cheque': nroCheque,
      'nro_cuenta': nroCuenta,
      'cod_seguridad': codSeguridad,
      'nro_autorizacion': nroAutorizacion,
      'fecha_vcto': fechaVcto,
      'id_cuentas_bancarias': idCuentasBancarias,
      'fecha_consignacion': fechaConsignacion,
      'rowid_docto_consignacion': rowidDoctoConsignacion,
      'rowid_mov_docto_consignacion': rowidMovDoctoConsignacion,
      'id_causales_devolucion': idCausalesDevolucion,
      'id_sucursal': idSucursal,
      'p_rowid_docto_letra': pRowidDoctoLetra,
      'p_id_ubicacion_origen': pIdUbicacionOrigen,
      'p_id_ubicacion_destino': pIdUbicacionDestino,
      'p_rowid_sa_origen': pRowidSaOrigen,
      'p_rowid_sa_destino': pRowidSaDestino,
      'p_id_cuenta_bancaria': pIdCuentaBancaria,
    };
  }
}

