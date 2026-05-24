# StudyMap — Correções Visuais (Design Fixes)

**Contexto**: Tarefas para alinhar o app ao protótipo visual. Ler em conjunto com `design_tokens.md` e `design_components.md`.

**Prioridade de execução**: TF001 → TF002 → TF003 → TF004 → TF005

---

## TF001 — Criar widget `GradientButton` (botão primário com glow)

**Arquivo**: `lib/core/widgets/gradient_button.dart` (criar novo)

O botão primário no protótipo tem gradiente horizontal azul→ciano e um brilho externo (glow). O `ElevatedButton` padrão não suporta isso. Criar um widget customizado:

```dart
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double height;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4B8EFF), Color(0xFF00EEFC)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B8EFF).withOpacity(0.45),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF002E69),
          minimumSize: Size(double.infinity, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF002E69),
          ),
        ),
      ),
    );
  }
}
```

**Verificação**: Widget compila. Quando usado em uma tela, exibe gradiente azul→ciano com sombra azul visível abaixo do botão.

---

## TF002 — Atualizar tela de Login

**Arquivo**: `lib/features/auth/presentation/login_screen.dart` (modificar existente)

### 2a. Logo com glow neon

Substituir o widget de logo atual por um `Container` com `BoxDecoration` que aplique glow ciano:

```dart
Container(
  width: 72,
  height: 72,
  decoration: BoxDecoration(
    color: const Color(0xFF1E2023),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: const Color(0x4400EEFC), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF00EEFC).withOpacity(0.25),
        blurRadius: 24,
        spreadRadius: 2,
      ),
    ],
  ),
  child: const Icon(
    Icons.explore_outlined,
    color: Color(0xFF00EEFC),
    size: 36,
  ),
),
```

### 2b. Botão "Entrar"

Substituir o `ElevatedButton` atual pelo widget `GradientButton` criado em TF001:

```dart
GradientButton(
  label: 'Entrar',
  onPressed: () { /* lógica de login existente */ },
),
```

### 2c. Botão "Continuar com Google"

Deve ter visual de borda sutil (não glassmorphic agressivo). Usar `OutlinedButton` com estilo:

```dart
OutlinedButton.icon(
  onPressed: () { /* lógica Google existente */ },
  icon: const Icon(Icons.account_circle_outlined, size: 20),
  label: const Text('Continuar com o Google'),
  style: OutlinedButton.styleFrom(
    foregroundColor: const Color(0xFFE2E2E7),
    minimumSize: const Size(double.infinity, 52),
    side: const BorderSide(color: Color(0x33FFFFFF), width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: const Color(0xFF1E2023),
  ),
),
```

### 2d. Campos de texto

Garantir que `InputDecoration` dos campos use borda arredondada completa (não apenas underline). Verificar se `inputDecorationTheme` do tema global (definido em TD005) já está sendo aplicado. Se não estiver, aplicar explicitamente em cada `TextField` da tela.

**Verificação**: Tela de login mostra logo com glow ciano, botão "Entrar" com gradiente azul→ciano e sombra azul, botão Google com borda sutil.

---

## TF003 — Substituir gráfico do Dashboard por barras horizontais

**Arquivo**: `lib/features/stats/presentation/widgets/productivity_chart.dart` (modificar existente)

O gráfico atual está na vertical com bugs visuais. Substituir por `BarChart` do `fl_chart` configurado para barras **horizontais**, replicando o protótipo.

Configuração esperada do `BarChart`:

```dart
BarChart(
  BarChartData(
    alignment: BarChartAlignment.spaceEvenly,
    barTouchData: BarTouchData(enabled: false),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 72,
          getTitlesWidget: (value, meta) {
            // retornar o nome abreviado do local (ex: 'Bibliot.')
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            // retornar a porcentagem (ex: '85%')
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    gridData: FlGridData(show: false),
    borderData: FlBorderData(show: false),
    barGroups: // grupos gerados dinamicamente a partir dos dados do controller,
    // cada grupo com um único BarChartRodData horizontal
  ),
  swapMainAndCrossAxes: true, // ESSENCIAL: torna as barras horizontais
),
```

Configuração do `BarChartRodData` para cada barra:

```dart
BarChartRodData(
  toY: valorNormalizado,        // valor entre 0 e 1 (produtividade / máxima)
  width: 12,
  borderRadius: BorderRadius.circular(6),
  gradient: LinearGradient(
    colors: [Color(0xFF4B8EFF), Color(0xFF00EEFC)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
  backDrawRodData: BackgroundBarChartRodData(
    show: true,
    toY: 1.0,
    color: const Color(0xFF282A2E), // trilha escura atrás da barra
  ),
),
```

**Verificação**: Dashboard exibe barras horizontais com gradiente azul→ciano, trilha escura de fundo, labels de local à esquerda e porcentagem à direita. Sem bugs visuais de overflow.

---

## TF004 — Adicionar ícones coloridos com glow nas métricas do Dashboard

**Arquivo**: `lib/features/stats/presentation/dashboard_screen.dart` (modificar existente)

No protótipo, os cards de métricas têm ícones com cores e brilho específicos:
- Sessões: ícone de check, cor ciano (`Color(0xFF00EEFC)`)
- Horas: ícone de relógio, cor ciano (`Color(0xFF00EEFC)`)
- Foco médio: ícone de estrela, cor dourada/terciária (`Color(0xFFFFB595)`)

Criar um widget auxiliar `_MetricIcon` dentro do arquivo:

```dart
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
```

Usar nos cards:
```dart
_MetricIcon(icon: Icons.check_circle_outline, color: Color(0xFF00EEFC))  // Sessões
_MetricIcon(icon: Icons.timer_outlined, color: Color(0xFF00EEFC))         // Horas
_MetricIcon(icon: Icons.star_border_rounded, color: Color(0xFFFFB595))    // Foco
```

**Verificação**: Cards de métricas exibem ícones com fundo circular colorido translúcido e glow visível ao redor.

---

## TF005 — Atualizar tela de Perfil

**Arquivo**: `lib/features/profile/presentation/profile_screen.dart` (modificar existente)

### 5a. Avatar com borda azul brilhante

Substituir o widget de avatar atual por:

```dart
Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF4B8EFF).withOpacity(0.50),
        blurRadius: 24,
        spreadRadius: 2,
      ),
    ],
  ),
  child: CircleAvatar(
    radius: 48,
    backgroundImage: /* foto do usuário ou null */,
    backgroundColor: const Color(0xFF1E2023),
    child: /* ícone padrão se sem foto */,
  ).outlined(
    // Alternativa: usar Stack com Container circular de borda
  ),
)
```

Implementação mais simples com `Stack`:

```dart
Stack(
  alignment: Alignment.center,
  children: [
    Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF4B8EFF), width: 2.5),
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
      backgroundImage: /* networkImage ou null */,
      backgroundColor: const Color(0xFF1E2023),
    ),
  ],
),
```

### 5b. Card de configurações com divisores internos

Substituir os itens de configuração soltos por um único `Card` com itens separados por `Divider`:

```dart
Container(
  decoration: BoxDecoration(
    color: const Color(0xFF1E2023),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: const Color(0x33FFFFFF), width: 1),
  ),
  child: Column(
    children: [
      _SettingsItem(
        icon: Icons.notifications_outlined,
        label: 'Notificações de Lembrete',
        trailing: Switch(
          value: notificacoesAtivas,
          onChanged: (v) { /* toggle */ },
          activeColor: const Color(0xFF4B8EFF),
        ),
      ),
      const Divider(height: 1, color: Color(0x33FFFFFF)),
      _SettingsItem(
        icon: Icons.file_download_outlined,
        label: 'Exportar dados de estudo',
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF8B90A0)),
        onTap: () { /* ação */ },
      ),
      const Divider(height: 1, color: Color(0x33FFFFFF)),
      _SettingsItem(
        icon: Icons.sync_outlined,
        label: 'Sincronizar conta',
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF8B90A0)),
        onTap: () { /* ação */ },
      ),
    ],
  ),
),
```

### 5c. Botão "Sair da conta" com borda vermelha

```dart
OutlinedButton.icon(
  onPressed: () { /* lógica de logout existente */ },
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
```

**Verificação**: Tela de perfil mostra avatar com borda azul brilhante, configurações agrupadas em card único com divisores, botão de logout com borda e texto vermelhos.

---

## Notas de Implementação

- O `GradientButton` (TF001) deve substituir **todos** os `ElevatedButton` que representam ações primárias no app, não apenas o de login.
- O efeito `boxShadow` com a cor do elemento é o padrão de "glow" do protótipo. Aplicar o mesmo princípio em qualquer novo elemento interativo primário que for criado.
- Para o gráfico (TF003), o parâmetro `swapMainAndCrossAxes: true` no `fl_chart` é o que inverte a orientação para horizontal — sem ele o gráfico permanece vertical.
- Executar `flutter analyze` após cada tarefa antes de prosseguir.
