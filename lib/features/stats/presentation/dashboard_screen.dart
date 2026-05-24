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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 130),
                children: [
                  Text(
                    'Produtividade por Local',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ProductivityChart(data: statsController.productivityByPlace),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Ranking de Performance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (statsController.productivityByPlace.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Nenhum dado de sessão disponível para o ranking.', textAlign: TextAlign.center),
                      ),
                    )
                  else
                    ..._buildRanking(context, statsController.productivityByPlace),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildRanking(BuildContext context, Map<String, double> data) {
    final sortedEntries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries.asMap().entries.map((e) {
      final index = e.key + 1;
      final entry = e.value;
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: index == 1 ? Theme.of(context).colorScheme.primaryContainer : Colors.white10,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '#$index',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: index == 1 ? Theme.of(context).colorScheme.onPrimaryContainer : Colors.white,
              ),
            ),
          ),
          title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Índice Acumulado'),
          trailing: Text(
            entry.value.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }).toList();
  }
}
