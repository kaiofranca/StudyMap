import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../main/presentation/data_management_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final user = authController.user;
    final String? photoUrl = user?.photoUrl?.replaceAll('=s96-c', '=s200-c');

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 150),
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF4B8EFF), width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4B8EFF).withOpacity(0.45),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: const Color(0xFF1E2023),
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? const Icon(Icons.person, size: 48, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            user?.name ?? 'Estudante',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            user?.email ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: const Color(0xFF8B90A0)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // Card de Configurações
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E2023),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x33FFFFFF), width: 1),
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.settings_outlined,
                  label: 'Gerenciar Locais e Matérias',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DataManagementScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () => authController.logout(),
            icon: const Icon(Icons.logout, size: 20, color: Color(0xFFFFB4AB)),
            label: const Text(
              'Sair da conta',
              style: TextStyle(color: Color(0xFFFFB4AB)),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              side: const BorderSide(color: Color(0xFFFFB4AB), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFC1C6D7)),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing:
          trailing ?? const Icon(Icons.chevron_right, color: Color(0xFF8B90A0)),
      onTap: onTap,
    );
  }
}
