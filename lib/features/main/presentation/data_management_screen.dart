import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../places/presentation/places_controller.dart';
import '../../subjects/presentation/subjects_controller.dart';

class DataManagementScreen extends StatelessWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Dados')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'Locais', onAdd: () => _addPlace(context)),
          const _PlacesList(),
          const SizedBox(height: 32),
          _SectionHeader(title: 'Matérias', onAdd: () => _addSubject(context)),
          const _SubjectsList(),
        ],
      ),
    );
  }

  void _addPlace(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo Local'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nome do Local'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<PlacesController>().addPlace(controller.text, 0, 0);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _addSubject(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Matéria'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nome da Matéria'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<SubjectsController>().addSubject(controller.text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;

  const _SectionHeader({required this.title, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: onAdd),
      ],
    );
  }
}

class _PlacesList extends StatelessWidget {
  const _PlacesList();

  @override
  Widget build(BuildContext context) {
    final places = context.watch<PlacesController>().places;
    if (places.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('Nenhum local cadastrado.', style: TextStyle(fontStyle: FontStyle.italic)),
      );
    }
    return Column(
      children: places
          .map((p) => ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(p.name),
                subtitle: const Text('GPS: Coordenadas salvas'),
              ))
          .toList(),
    );
  }
}

class _SubjectsList extends StatelessWidget {
  const _SubjectsList();

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<SubjectsController>().subjects;
    if (subjects.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('Nenhuma matéria cadastrada.', style: TextStyle(fontStyle: FontStyle.italic)),
      );
    }
    return Column(
      children: subjects
          .map((s) => ListTile(
                leading: const Icon(Icons.book_outlined),
                title: Text(s.name),
              ))
          .toList(),
    );
  }
}
