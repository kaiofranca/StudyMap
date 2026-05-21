import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'session_controller.dart';
import 'start_session_modal.dart';
import 'finish_session_modal.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../main/presentation/data_management_screen.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = context.watch<SessionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyMap'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(sessionController.elapsed),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: sessionController.isSessionActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
            ),
            const SizedBox(height: 48),
            if (!sessionController.isSessionActive)
              ElevatedButton.icon(
                onPressed: () => _showStartSessionModal(context),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar Sessão'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () => _showFinishSessionModal(context),
                icon: const Icon(Icons.stop),
                label: const Text('Parar Sessão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
          ],
        ),
      ),
    );
  }

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
