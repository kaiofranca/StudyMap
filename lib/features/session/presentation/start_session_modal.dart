import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../../core/location/location_service.dart';
import '../../places/presentation/places_controller.dart';
import '../../subjects/presentation/subjects_controller.dart';

class StartSessionModal extends StatefulWidget {
  const StartSessionModal({super.key});

  @override
  State<StartSessionModal> createState() => _StartSessionModalState();
}

class _StartSessionModalState extends State<StartSessionModal> {
  Position? _currentPosition;
  String _address = "Buscando localização...";
  String? _selectedPlaceId;
  String? _selectedSubjectId;
  bool _isLoadingLocation = true;
  bool _isCreatingPlace = false;
  bool _isCreatingSubject = false;
  
  final _placeNameController = TextEditingController();
  final _subjectNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final pos = await LocationService.getCurrentLocation();
      final addr = await LocationService.getAddressFromCoordinates(pos.latitude, pos.longitude);
      if (mounted) {
        setState(() {
          _currentPosition = pos;
          _address = addr;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _address = "Erro ao obter localização: $e";
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    _subjectNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final placesController = context.watch<PlacesController>();
    final subjectsController = context.watch<SubjectsController>();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Preparar Sessão',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // GPS Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _isLoadingLocation 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _address,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Place Selection
          _buildPlaceSection(placesController),
          const SizedBox(height: 16),

          // Subject Selection
          _buildSubjectSection(subjectsController),
          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: (_selectedPlaceId != null && _selectedSubjectId != null && _currentPosition != null)
              ? _startSession
              : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Começar a Estudar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceSection(PlacesController controller) {
    if (_isCreatingPlace) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nome do Novo Local', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _placeNameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Ex: Minha Casa, Biblioteca...',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check),
                onPressed: _createNewPlace,
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _isCreatingPlace = false),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Onde você está?', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedPlaceId,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          hint: const Text('Selecione um local'),
          items: [
            ...controller.places.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))),
            DropdownMenuItem(
              value: 'new', 
              child: Text('+ Criar Local Atual', style: TextStyle(color: Theme.of(context).colorScheme.primary))
            ),
          ],
          onChanged: (val) {
            if (val == 'new') {
              setState(() => _isCreatingPlace = true);
            } else {
              setState(() => _selectedPlaceId = val);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSubjectSection(SubjectsController controller) {
    if (_isCreatingSubject) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nome da Nova Matéria', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _subjectNameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Ex: Cálculo I, História...',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check),
                onPressed: _createNewSubject,
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _isCreatingSubject = false),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('O que vai estudar?', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedSubjectId,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          hint: const Text('Selecione uma matéria'),
          items: [
            ...controller.subjects.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))),
            DropdownMenuItem(
              value: 'new', 
              child: Text('+ Criar Nova Matéria', style: TextStyle(color: Theme.of(context).colorScheme.primary))
            ),
          ],
          onChanged: (val) {
            if (val == 'new') {
              setState(() => _isCreatingSubject = true);
            } else {
              setState(() => _selectedSubjectId = val);
            }
          },
        ),
      ],
    );
  }

  Future<void> _createNewPlace() async {
    if (_placeNameController.text.isEmpty || _currentPosition == null) return;
    
    final controller = context.read<PlacesController>();
    await controller.addPlace(
      _placeNameController.text,
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );
    
    if (mounted) {
      setState(() {
        _selectedPlaceId = controller.places.last.id;
        _isCreatingPlace = false;
      });
    }
  }

  Future<void> _createNewSubject() async {
    if (_subjectNameController.text.isEmpty) return;
    
    final controller = context.read<SubjectsController>();
    await controller.addSubject(_subjectNameController.text);
    
    if (mounted) {
      setState(() {
        _selectedSubjectId = controller.subjects.last.id;
        _isCreatingSubject = false;
      });
    }
  }

  void _startSession() {
    Navigator.pop(context, {
      'placeId': _selectedPlaceId,
      'subjectId': _selectedSubjectId,
      'latitude': _currentPosition!.latitude,
      'longitude': _currentPosition!.longitude,
    });
  }
}
