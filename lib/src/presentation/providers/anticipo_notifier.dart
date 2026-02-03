import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Conductor (para filtro y datos del anticipo)
class ConductorMock {
  final String id;
  final String nombre;
  final String identificacion;

  const ConductorMock({
    required this.id,
    required this.nombre,
    required this.identificacion,
  });
}

/// Anticipo recibido por un conductor (registro del listado)
class AnticipoMock {
  final String id;
  final String numeroAnticipo;
  final String fecha;
  final String conductorId;
  final String conductorNombre;
  final String conductorIdentificacion;
  final double valorTotal;
  final String estado; // Pendiente, Aprobado, Pagado

  const AnticipoMock({
    required this.id,
    required this.numeroAnticipo,
    required this.fecha,
    required this.conductorId,
    required this.conductorNombre,
    required this.conductorIdentificacion,
    required this.valorTotal,
    required this.estado,
  });
}

/// Concepto del anticipo (detalle maestro-detalle)
class ConceptoAnticipo {
  final String id;
  final String concepto;
  final double valor;

  ConceptoAnticipo({
    required this.id,
    required this.concepto,
    required this.valor,
  });
}

/// Mock: conductores
final List<ConductorMock> mockConductores = [
  const ConductorMock(id: 'c1', nombre: 'Juan Pérez', identificacion: '12345678'),
  const ConductorMock(id: 'c2', nombre: 'María García', identificacion: '87654321'),
  const ConductorMock(id: 'c3', nombre: 'Carlos Rodríguez', identificacion: '11223344'),
  const ConductorMock(id: 'c4', nombre: 'Ana Martínez', identificacion: '44332211'),
  const ConductorMock(id: 'c5', nombre: 'Luis Hernández', identificacion: '55667788'),
];

/// Mock: anticipos por conductor
final List<AnticipoMock> mockAnticipos = [
  const AnticipoMock(
    id: 'a1',
    numeroAnticipo: 'ANT-001',
    fecha: '15/01/2025',
    conductorId: 'c1',
    conductorNombre: 'Juan Pérez',
    conductorIdentificacion: '12345678',
    valorTotal: 2500000,
    estado: 'Pendiente',
  ),
  const AnticipoMock(
    id: 'a2',
    numeroAnticipo: 'ANT-002',
    fecha: '18/01/2025',
    conductorId: 'c1',
    conductorNombre: 'Juan Pérez',
    conductorIdentificacion: '12345678',
    valorTotal: 1800000,
    estado: 'Aprobado',
  ),
  const AnticipoMock(
    id: 'a3',
    numeroAnticipo: 'ANT-003',
    fecha: '20/01/2025',
    conductorId: 'c2',
    conductorNombre: 'María García',
    conductorIdentificacion: '87654321',
    valorTotal: 3200000,
    estado: 'Pendiente',
  ),
  const AnticipoMock(
    id: 'a4',
    numeroAnticipo: 'ANT-004',
    fecha: '22/01/2025',
    conductorId: 'c2',
    conductorNombre: 'María García',
    conductorIdentificacion: '87654321',
    valorTotal: 1500000,
    estado: 'Pagado',
  ),
  const AnticipoMock(
    id: 'a5',
    numeroAnticipo: 'ANT-005',
    fecha: '25/01/2025',
    conductorId: 'c3',
    conductorNombre: 'Carlos Rodríguez',
    conductorIdentificacion: '11223344',
    valorTotal: 2100000,
    estado: 'Pendiente',
  ),
  const AnticipoMock(
    id: 'a6',
    numeroAnticipo: 'ANT-006',
    fecha: '28/01/2025',
    conductorId: 'c4',
    conductorNombre: 'Ana Martínez',
    conductorIdentificacion: '44332211',
    valorTotal: 2800000,
    estado: 'Aprobado',
  ),
  const AnticipoMock(
    id: 'a7',
    numeroAnticipo: 'ANT-007',
    fecha: '30/01/2025',
    conductorId: 'c5',
    conductorNombre: 'Luis Hernández',
    conductorIdentificacion: '55667788',
    valorTotal: 1900000,
    estado: 'Pendiente',
  ),
];

/// Mock: conceptos disponibles para agregar al detalle
final List<String> mockConceptosDisponibles = [
  'Combustible',
  'Peajes',
  'Alimentación',
  'Hospedaje',
  'Otros viáticos',
  'Mantenimiento',
  'Lavado',
];

/// Notifier para el filtro de conductor (null = todos)
class ConductorFiltroNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setConductor(String? id) {
    state = id;
  }
}

/// Estado: conductor seleccionado para filtrar (null = todos)
final conductorFiltroProvider =
    NotifierProvider<ConductorFiltroNotifier, String?>(ConductorFiltroNotifier.new);

/// Lista de anticipos filtrada por conductor
final anticiposFiltradosProvider = Provider<List<AnticipoMock>>((ref) {
  final conductorId = ref.watch(conductorFiltroProvider);
  if ((conductorId ?? '').isEmpty) return mockAnticipos;
  return mockAnticipos.where((a) => a.conductorId == conductorId).toList();
});
