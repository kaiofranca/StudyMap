import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'session_controller.dart';
import 'start_session_modal.dart';
import 'finish_session_modal.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../main/presentation/data_management_screen.dart';
import '../../places/presentation/places_controller.dart';
import '../../../core/location/location_service.dart';
import '../../../core/widgets/gradient_button.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadInitialLocation();
  }

  Future<void> _loadInitialLocation() async {
    try {
      final pos = await LocationService.getCurrentLocation();
      if (mounted) {
        setState(() => _currentPosition = pos);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final sessionController = context.watch<SessionController>();
    final placesController = context.watch<PlacesController>();

    // Sincroniza os markers com os locais carregados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<SessionController>().updateMarkers(placesController.places);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('StudyMap',style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataManagementScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthController>().logout(),
          ),
        ],
      ),
      body: sessionController.isSessionActive
          ? _buildActiveSessionLayout(context, sessionController)
          : _buildIdleLayout(context, sessionController),
    );
  }

  Widget _buildIdleLayout(BuildContext context, SessionController controller) {
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
          markers: controller.markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          onMapCreated: (mapController) {
            mapController.setMapStyle(_mapStyle);
          },
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 150,
          child: GradientButton(
                label: 'Iniciar Sessão',
                onPressed: () => _showStartSessionModal(context)
              ),
        ),
      ],
    );
  }

  Widget _buildActiveSessionLayout(
      BuildContext context, SessionController controller) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cronômetro Centralizado (com padding inferior para subir na tela)
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatDuration(controller.elapsed),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 64, // Destaque maior para o tempo
                        fontWeight: FontWeight.bold,
                        color: controller.isPaused
                            ? Theme.of(context).colorScheme.outline
                            : Theme.of(context).colorScheme.primary,
                      ),
                ),
                if (controller.isPaused)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        'SESSÃO PAUSADA',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Controles na Base (Acima da Floating Nav Bar)
          Positioned(
            bottom: 150, // Mesma altura usada no botão de início
            left: 0,
            right: 0,
            child: Row(
              children: [
                // Botão Pausar/Retomar
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.isPaused
                        ? controller.resumeSession()
                        : controller.pauseSession(),
                    icon: Icon(
                        controller.isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(controller.isPaused ? 'RETOMAR' : 'PAUSAR'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: controller.isPaused
                          ? const Color(0xFF00EEFC)
                          : Colors.white,
                      side: BorderSide(
                        color: controller.isPaused
                            ? const Color(0xFF00EEFC)
                            : const Color(0x33FFFFFF),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Botão Finalizar
                Expanded(
                  child: GradientButton(
                    label: 'FINALIZAR',
                    onPressed: () => _showFinishSessionModal(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Estilo Dark para o Google Maps
  final String _mapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#263c3f"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6b9a76"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#38414e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#212a37"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9ca5b3"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1f2835"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#f3d19c"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2f3948"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#515c6d"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  }
]
''';

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _showStartSessionModal(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const StartSessionModal(),
    );

    if (result != null && context.mounted) {
      try {
        await context.read<SessionController>().startSession(
              subjectId: result['subjectId'],
              subjectName: result['subjectName'],
              placeId: result['placeId'],
              latitude: result['latitude'],
              longitude: result['longitude'],
            );
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao iniciar sessão: $e')),
          );
        }
      }
    }
  }

  void _showFinishSessionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FinishSessionModal(),
    );
  }
}
