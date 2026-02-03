import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anticipo_notifier.dart';

/// Formulario del anticipo seleccionado: datos del registro + conceptos
class ReembolsoFormScreen extends ConsumerStatefulWidget {
  final AnticipoMock anticipo;

  const ReembolsoFormScreen({super.key, required this.anticipo});

  @override
  ConsumerState<ReembolsoFormScreen> createState() => _ReembolsoFormScreenState();
}

class _ReembolsoFormScreenState extends ConsumerState<ReembolsoFormScreen> {
  final _valorConceptoController = TextEditingController();
  final List<ConceptoAnticipo> _conceptos = [];
  int _conceptoIdCounter = 0;
  String? _conceptoSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarConceptosInicialesMock();
  }

  void _cargarConceptosInicialesMock() {
    // Mock: algunos conceptos ya cargados para el anticipo
    final a = widget.anticipo;
    if (a.id == 'a1' || a.id == 'a3') {
      setState(() {
        _conceptos.addAll([
          ConceptoAnticipo(id: '${_conceptoIdCounter++}', concepto: 'Combustible', valor: 800000),
          ConceptoAnticipo(id: '${_conceptoIdCounter++}', concepto: 'Peajes', valor: 120000),
        ]);
      });
    }
  }

  @override
  void dispose() {
    _valorConceptoController.dispose();
    super.dispose();
  }

  double get _totalAnticipo => widget.anticipo.valorTotal;
  double get _totalConceptos => _conceptos.fold<double>(0, (s, c) => s + c.valor);
  double get _diferencia => _totalAnticipo - _totalConceptos;

  String _formatValor(String value) {
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return '';
    final n = int.tryParse(digits) ?? 0;
    return n.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  void _agregarConcepto() {
    if (_conceptoSeleccionado == null || _conceptoSeleccionado!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione un concepto'), backgroundColor: Colors.orange),
      );
      return;
    }
    final valorText = _valorConceptoController.text.replaceAll(',', '');
    final valor = double.tryParse(valorText) ?? 0;
    if (valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un valor mayor a cero'), backgroundColor: Colors.orange),
      );
      return;
    }
    final conceptoNombre = _conceptoSeleccionado!;
    _valorConceptoController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _conceptos.add(ConceptoAnticipo(
        id: '${_conceptoIdCounter++}',
        concepto: conceptoNombre,
        valor: valor,
      ));
      _conceptoSeleccionado = null;
    });
  }

  void _quitarConcepto(ConceptoAnticipo c) {
    setState(() => _conceptos.removeWhere((x) => x.id == c.id));
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.anticipo;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          a.numeroAnticipo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle(icon: Icons.description_outlined, title: 'Datos de la legalización'),
          const SizedBox(height: 8),
          _buildCardCompact(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildDatoCompact('Número', a.numeroAnticipo)),
                    Expanded(child: _buildDatoCompact('Fecha', a.fecha)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(child: _buildDatoCompact('Conductor', a.conductorNombre)),
                    Expanded(child: _buildDatoCompact('Identificación', a.conductorIdentificacion)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(child: _buildDatoCompact('Estado', a.estado)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Total ', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                          Flexible(
                            child: Text(
                              _formatCurrency(_totalAnticipo),
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle(icon: Icons.list_alt, title: 'Conceptos'),
          const SizedBox(height: 8),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String?>(
                  value: _conceptoSeleccionado,
                  decoration: _inputDecoration('Concepto'),
                  hint: const Text('Seleccione concepto'),
                  isExpanded: true,
                  items: mockConceptosDisponibles
                      .map((c) => DropdownMenuItem<String?>(value: c, child: Text(c, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (v) => setState(() => _conceptoSeleccionado = v),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _valorConceptoController,
                        decoration: _inputDecoration('Valor'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          TextInputFormatter.withFunction((old, newVal) {
                            final digits = newVal.text.replaceAll(RegExp(r'[^\d]'), '');
                            final f = digits.isEmpty ? '' : _formatValor(digits);
                            return TextEditingValue(
                              text: f,
                              selection: TextSelection.collapsed(offset: f.length),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: _agregarConcepto,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      tooltip: 'Agregar concepto',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_conceptos.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, color: Colors.grey[500], size: 28),
                        const SizedBox(width: 12),
                        Text(
                          'Agregue conceptos con su valor',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Table(
                        border: TableBorder.all(color: Colors.grey[300]!, width: 1),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1.2),
                          2: FixedColumnWidth(44),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.1)),
                            children: [
                              _cell('Concepto', bold: true),
                              _cell('Valor', bold: true),
                              _cell('', bold: true),
                            ],
                          ),
                          ..._conceptos.map((c) {
                            return TableRow(
                              children: [
                                _cell(c.concepto),
                                _cell(_formatCurrency(c.valor)),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child: IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.red),
                                    onPressed: () => _quitarConcepto(c),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildTotalRow('Total legalización (registro)', _totalAnticipo),
                            const SizedBox(height: 6),
                            _buildTotalRow('Total conceptos', _totalConceptos),
                            const Divider(height: 12),
                            _buildTotalRow(
                              'Diferencia',
                              _diferencia,
                              color: _diferencia >= 0 ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _mostrarConfirmacionGuardar,
              icon: const Icon(Icons.save_outlined, size: 22),
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.teal.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.teal[700], size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[900]),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }

  Widget _buildCardCompact({required Widget child}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: child),
    );
  }

  Widget _buildDatoCompact(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis, maxLines: 1),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _cell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double value, {Color? color}) {
    final valueStr = _formatCurrency(value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, color: color ?? Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            valueStr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color ?? Colors.teal[800],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _mostrarConfirmacionGuardar() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar guardado'),
        content: const Text(
          '¿Desea guardar los conceptos y datos de la legalización?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (confirmado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Legalización guardada correctamente'),
          backgroundColor: Colors.teal[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }
}
