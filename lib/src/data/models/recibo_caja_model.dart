/// Modelo para el JSON del recibo de caja
class ReciboCajaModel {
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
    this.pIdCaja,
    this.pIdMoneda,
    this.pIndTipoMedio,
    this.pReferenciaOtros,
    this.pValorCr,
    this.pValorCrAlt,
    this.pIndCambio,
    this.pNroAltDoctoBanco,
    this.pIndAuxOrden,
    this.pIdCtaBancariaCg,
    this.pReferenciaCg,
    this.pRowidCcostoCg,
    this.pFechaCgCg,
    this.pNroDoctoAlternoCg,
    this.pIndLiquidaTarjeta,
    this.pVlrImptoTarjeta,
    this.pVlrImptoTarjetaAlt,
    this.pFechaElabCheqPostf,
    this.pDoctoBanco,
  });
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
  final String? pIdCaja;
  final String? pIdMoneda;
  final int? pIndTipoMedio;
  final String? pReferenciaOtros;
  final int? pValorCr;
  final int? pValorCrAlt;
  final int? pIndCambio;
  final String? pNroAltDoctoBanco;
  final int? pIndAuxOrden;
  final String? pIdCtaBancariaCg;
  final String? pReferenciaCg;
  final int? pRowidCcostoCg;
  final String? pFechaCgCg;
  final String? pNroDoctoAlternoCg;
  final int? pIndLiquidaTarjeta;
  final int? pVlrImptoTarjeta;
  final int? pVlrImptoTarjetaAlt;
  final String? pFechaElabCheqPostf;
  final String? pDoctoBanco;

  /// Convierte el modelo a un Map para enviarlo como JSON
  Map<String, dynamic> toJson() => {
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
    'p_id_caja': pIdCaja,
    'p_id_moneda': pIdMoneda,
    'p_ind_tipo_medio': pIndTipoMedio,
    'p_referencia_otros': pReferenciaOtros,
    'p_valor_cr': pValorCr,
    'p_valor_cr_alt': pValorCrAlt,
    'p_ind_cambio': pIndCambio,
    'p_NroAltDoctoBanco': pNroAltDoctoBanco,
    'p_ind_aux_orden': pIndAuxOrden,
    'p_id_cta_bancaria_cg': pIdCtaBancariaCg,
    'p_referencia_cg': pReferenciaCg,
    'p_rowid_ccosto_cg': pRowidCcostoCg,
    'p_fecha_cg_cg': pFechaCgCg,
    'p_nro_docto_alterno_cg': pNroDoctoAlternoCg,
    'p_ind_liquida_tarjeta': pIndLiquidaTarjeta,
    'p_vlr_impto_tarjeta': pVlrImptoTarjeta,
    'p_vlr_impto_tarjeta_alt': pVlrImptoTarjetaAlt,
    'p_fecha_elab_cheq_postf': pFechaElabCheqPostf,
    'p_docto_banco': pDoctoBanco,
  };
}
