import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anticipo_notifier.dart';
import 'reembolso_form_screen.dart';

/// Pantalla de lista de anticipos al conductor con filtro por conductor
class ReembolsosScreen extends ConsumerStatefulWidget {
  const ReembolsosScreen({super.key});

  @override
  ConsumerState<ReembolsosScreen> createState() => _ReembolsosScreenState();
}

class _ReembolsosScreenState extends ConsumerState<ReembolsosScreen> {
  @override
  Widget build(BuildContext context) {
    final anticipos = ref.watch<List<AnticipoMock>>(anticiposFiltradosProvider);
    final conductorId = ref.watch<String?>(conductorFiltroProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: const Text(
          'Legalización anticipo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFiltroConductor(context, conductorId),
          Expanded(
            child: anticipos.isEmpty
                ? _buildEmptyState(context, conductorId != null)
                : _buildListaAnticipos(context, anticipos),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroConductor(BuildContext context, String? conductorId) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: Colors.teal[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Conductor',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String?>(
            value: conductorId,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            hint: const Text('Todos los conductores'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Todos los conductores'),
              ),
              ...mockConductores.map((c) {
                return DropdownMenuItem<String?>(
                  value: c.id,
                  child: Text('${c.nombre} (${c.identificacion})'),
                );
              }),
            ],
            onChanged: (value) {
              ref.read(conductorFiltroProvider.notifier).setConductor(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool filtrado) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            filtrado ? Icons.search_off : Icons.directions_car_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            filtrado
                ? 'No hay legalizaciones anticipo para este conductor'
                : 'Seleccione un conductor para ver legalizaciones anticipo',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListaAnticipos(BuildContext context, List<AnticipoMock> anticipos) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: anticipos.length,
      itemBuilder: (context, index) {
        final a = anticipos[index];
        return _buildAnticipoCard(context, a);
      },
    );
  }

  Widget _buildAnticipoCard(BuildContext context, AnticipoMock a) {
    final estadoColor = _colorEstado(a.estado);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (context) => ReembolsoFormScreen(anticipo: a),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.payments_outlined, color: Colors.teal[700], size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.numeroAnticipo,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[800],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          a.fecha,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: estadoColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      a.estado,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: estadoColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[500]),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      a.conductorNombre,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    Text(
                      _formatCurrency(a.valorTotal),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'Pendiente':
        return Colors.orange;
      case 'Aprobado':
        return Colors.blue;
      case 'Pagado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatCurrency(double value) {
    final entero = value.toInt();
    return '\$${entero.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    )}';
  }
}
