import 'package:flutter/material.dart';

void main() => runApp(const MisMedicinasApp());

class MisMedicinasApp extends StatelessWidget {
  const MisMedicinasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis medicinas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const PantallaMedicinas(),
    );
  }
}

// Modelo simple de datos (solo para mostrar la interfaz)
class Medicina {
  String nombre;
  String hora;
  bool tomada;

  Medicina({required this.nombre, required this.hora, this.tomada = false});
}

class PantallaMedicinas extends StatefulWidget {
  const PantallaMedicinas({super.key});

  @override
  State<PantallaMedicinas> createState() => _PantallaMedicinasState();
}

class _PantallaMedicinasState extends State<PantallaMedicinas> {
  // Colores tomados del boceto
  static const Color colorFondo = Color(0xFFC8102E);
  static const Color colorTarjeta = Color(0xFFF7D4D8);
  static const Color colorPendiente = Color(0xFFC46F00);
  static const Color colorTomada = Color(0xFF12B05F);
  static const Color colorGris = Color(0xFF767676);

  final List<Medicina> medicinas = [
    Medicina(nombre: 'Paracetamol', hora: '08:00 A.M.'),
    Medicina(nombre: 'Loratadina', hora: '01:00 P.M.'),
    Medicina(nombre: 'Levotiroxina', hora: '04:00 P.M.', tomada: true),
  ];

  // Convierte un TimeOfDay a formato "08:00 A.M."
  String _formatoHora(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final sufijo = t.period == DayPeriod.am ? 'A.M.' : 'P.M.';
    return '${h.toString().padLeft(2, '0')}:$min $sufijo';
  }

  // Diálogo para agregar una medicina nueva
  Future<void> _agregarMedicina() async {
    final controlador = TextEditingController();
    TimeOfDay hora = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogo) => AlertDialog(
          title: const Text('Nueva medicina'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controlador,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ej. Ibuprofeno',
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.access_time),
                label: Text(_formatoHora(hora)),
                onPressed: () async {
                  final elegida =
                      await showTimePicker(context: ctx, initialTime: hora);
                  if (elegida != null) setDialogo(() => hora = elegida);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colorFondo),
              onPressed: () {
                if (controlador.text.trim().isEmpty) return;
                setState(() {
                  medicinas.add(Medicina(
                    nombre: controlador.text.trim(),
                    hora: _formatoHora(hora),
                  ));
                });
                Navigator.pop(ctx);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      body: SafeArea(
        child: Stack(
          children: [
            // Botón de menú (hamburguesa) arriba a la derecha
            Positioned(
              top: 8,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.menu, size: 36, color: Color(0xFF1A1A1A)),
                tooltip: 'Abrir menú',
                onPressed: () {},
              ),
            ),
            // Tarjeta con la lista
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 70, 38, 110),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                decoration: BoxDecoration(
                  color: colorTarjeta,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF8A5A60)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mis medicinas',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Color(0xFF555555), height: 1),
                    const SizedBox(height: 8),
                    Expanded(
                      child: medicinas.isEmpty
                          ? const Text(
                              'Aún no tienes medicinas. Toca + para agregar una.',
                              style: TextStyle(color: colorGris),
                            )
                          : ListView.builder(
                              itemCount: medicinas.length,
                              itemBuilder: (_, i) => _filaMedicina(medicinas[i]),
                            ),
                    ),
                    const Divider(color: Color(0xFF555555), height: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Botón flotante "+"
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: SizedBox(
          width: 78,
          height: 74,
          child: FloatingActionButton(
            onPressed: _agregarMedicina,
            backgroundColor: const Color(0xFFE6E6E6),
            foregroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.add, size: 32),
          ),
        ),
      ),
    );
  }

  // Una fila: ícono editar + nombre/hora + etiqueta de estado
  Widget _filaMedicina(Medicina m) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(top: 2, right: 10),
              child: Icon(Icons.edit_note_outlined, size: 22),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.nombre, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 4),
                Text(m.hora,
                    style: const TextStyle(fontSize: 13, color: colorGris)),
              ],
            ),
          ),
          // Al tocar la etiqueta cambia entre Pendiente y Tomada
          GestureDetector(
            onTap: () => setState(() => m.tomada = !m.tomada),
            child: Container(
              width: 95,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: m.tomada ? colorTomada : colorPendiente,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                m.tomada ? 'Tomada' : 'Pendiente',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
