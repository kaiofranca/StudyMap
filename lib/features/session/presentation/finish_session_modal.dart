import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'session_controller.dart';
import '../../../core/widgets/gradient_button.dart';

class FinishSessionModal extends StatefulWidget {
  const FinishSessionModal({super.key});

  @override
  State<FinishSessionModal> createState() => _FinishSessionModalState();
}

class _FinishSessionModalState extends State<FinishSessionModal> {
  int _focusLevel = 3;

  @override
  Widget build(BuildContext context) {
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
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Como foi seu foco?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Nível: $_focusLevel',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
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
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                final level = index + 1;
                return Text(
                  level.toString(),
                  style: TextStyle(
                    fontWeight: _focusLevel == level ? FontWeight.bold : FontWeight.normal,
                    color: _focusLevel == level 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 32),
          GradientButton(
            label: 'Concluir e Salvar',
            onPressed: () async {
              try {
                await context.read<SessionController>().stopSession(_focusLevel);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao salvar sessão: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
