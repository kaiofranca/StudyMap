import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stats_controller.dart';
import 'widgets/productivity_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StatsController>().loadStats();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final statsController = context.watch<StatsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: statsController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => statsController.loadStats(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 150),
                children: [
                  // 1. Ranking de Performance
                  Text(
                    'Ranking de Performance',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (statsController.productivityByPlace.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                            'Nenhum dado de sessão disponível para o ranking.',
                            textAlign: TextAlign.center),
                      ),
                    )
                  else
                    ..._buildRanking(
                        context,
                        statsController.productivityByPlace),

                  const SizedBox(height: 48),

                  // 2. Produtividade por Local (Gráfico)
                  Text(
                    'Produtividade por Local',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: (statsController.productivityByPlace.length * 52.0 +
                            12.0)
                        .clamp(100.0, 400.0),
                    child: ProductivityChart(
                        data: statsController.productivityByPlace),
                  ),

                  const SizedBox(height: 48),

                  // 3. Métricas Resumo
                  Text(
                    'Métricas Gerais',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          label: 'Sessões',
                          value: statsController.totalSessions.toString(),
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFF00EEFC),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          label: 'Horas',
                          value:
                              '${statsController.totalHours.toStringAsFixed(1)}h',
                          icon: Icons.timer_outlined,
                          color: const Color(0xFF00EEFC),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMetricCard(
                    context,
                    label: 'Foco Médio',
                    value:
                        '${(statsController.averageFocus * 20).toStringAsFixed(0)}%',
                    icon: Icons.star_border_rounded,
                    color: const Color(0xFFFFB595),
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2023),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x33FFFFFF), width: 1),
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          _MetricIcon(icon: icon, color: color),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B90A0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _MetricIcon({required IconData icon, required Color color}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.30),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  List<Widget> _buildRanking(BuildContext context, Map<String, double> data) {
    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries.asMap().entries.map((e) {
      final index = e.key + 1;
      final entry = e.value;
      final Color rankColor = index == 1
          ? const Color(0xFF4B8EFF) // Neon Blue para o #1
          : (index <= 3 ? const Color(0xFF00EEFC) : const Color(0xFF8B90A0));

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2023),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x33FFFFFF), width: 1),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: rankColor.withOpacity(0.12),
              boxShadow: index <= 3
                  ? [
                      BoxShadow(
                        color: rankColor.withOpacity(0.30),
                        blurRadius: 16,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
              border: index <= 3
                  ? Border.all(color: rankColor.withOpacity(0.5), width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '#$index',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: index <= 3 ? rankColor : const Color(0xFFE2E2E7),
              ),
            ),
          ),
          title: Text(
            entry.key,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }).toList();
  }
}
