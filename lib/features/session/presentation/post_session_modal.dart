import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../places/presentation/places_controller.dart';
import '../../subjects/presentation/subjects_controller.dart';
import 'session_controller.dart';

class PostSessionModal extends StatefulWidget {
  const PostSessionModal({super.key});

  @override
  State<PostSessionModal> createState() => _PostSessionModalState();
}

class _PostSessionModalState extends State<PostSessionModal> {
  String? _selectedSubjectId;
  String? _selectedPlaceId;
  int _focusLevel = 3;

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<SubjectsController>().subjects;
    final places = context.watch<PlacesController>().places;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sessão Finalizada!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: _selectedSubjectId,
            decoration: const InputDecoration(labelText: 'Matéria', border: OutlineInputBorder()),
            hint: const Text('Selecione a Matéria'),
            items: subjects.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
            onChanged: (val) => setState(() => _selectedSubjectId = val),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedPlaceId,
            decoration: const InputDecoration(labelText: 'Local', border: OutlineInputBorder()),
            hint: const Text('Selecione o Local'),
            items: places.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
            onChanged: (val) => setState(() => _selectedPlaceId = val),
          ),
          const SizedBox(height: 24),
          Text(
            'Nível de Foco: $_focusLevel',
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Slider(
            value: _focusLevel.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: _focusLevel.toString(),
            onChanged: (val) => setState(() => _focusLevel = val.round()),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: (_selectedSubjectId != null && _selectedPlaceId != null)
                ? () async {
                    try {
                      await context.read<SessionController>().stopSession(
                            _selectedSubjectId,
                            _selectedPlaceId,
                            _focusLevel,
                          );
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao salvar sessão: $e')),
                        );
                      }
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Salvar Registro de Estudo'),
          ),
        ],
      ),
    );
  }
}
