# StudyMap — Tarefas de Design (T030)

**Pré-requisito**: Ler `design_tokens.md` antes de executar qualquer tarefa.
**Referência de componentes**: Ver `design_components.md`.

---

## TD001 — Criar arquivo de constantes de cores

**Arquivo**: `lib/core/utils/app_colors.dart` (criar novo)

Criar uma classe `AppColors` com as constantes estáticas definidas na seção "Constantes extras" do `design_tokens.md`. Não duplicar valores que já existem no `ColorScheme`.

**Verificação**: O arquivo compila sem erros com `flutter analyze`.

---

## TD002 — Criar arquivo de constantes de espaçamento

**Arquivo**: `lib/core/utils/app_spacing.dart` (criar novo)

Criar uma classe `AppSpacing` com as constantes estáticas definidas na seção "Spacing" do `design_tokens.md`.

**Verificação**: O arquivo compila sem erros com `flutter analyze`.

---

## TD003 — Completar ColorScheme em `app_widget.dart`

**Arquivo**: `lib/app/app_widget.dart` (modificar existente)

No `ColorScheme.dark()` existente, adicionar os tokens que estão faltando. O `ColorScheme.dark()` atual possui apenas 10 propriedades; ele deve ter todas as listadas na seção "Colors" do `design_tokens.md`. Adicionar as propriedades ausentes sem remover as existentes:

- `secondaryContainer: Color(0xFF00EEFC)`
- `onSecondaryContainer: Color(0xFF00686F)`
- `tertiary: Color(0xFFFFB595)`
- `onTertiary: Color(0xFF571E00)`
- `tertiaryContainer: Color(0xFFEF6719)`
- `onTertiaryContainer: Color(0xFF4C1A00)`
- `errorContainer: Color(0xFF93000A)`
- `onErrorContainer: Color(0xFFFFDAD6)`
- `surfaceContainerLowest: Color(0xFF0C0E12)`
- `surfaceContainerLow: Color(0xFF1A1C1F)`
- `surfaceContainer: Color(0xFF1E2023)`
- `surfaceContainerHigh: Color(0xFF282A2E)`
- `surfaceContainerHighest: Color(0xFF333539)`
- `onSurfaceVariant: Color(0xFFC1C6D7)`
- `outline: Color(0xFF8B90A0)`
- `outlineVariant: Color(0xFF414755)`
- `inverseSurface: Color(0xFFE2E2E7)`
- `onInverseSurface: Color(0xFF2E3034)`
- `inversePrimary: Color(0xFF005BC1)`
- `surfaceTint: Color(0xFFADC6FF)`

**Verificação**: `flutter analyze` sem erros. `scaffoldBackgroundColor` deve permanecer `Color(0xFF111317)`.

---

## TD004 — Implementar TextTheme em `app_widget.dart`

**Arquivo**: `lib/app/app_widget.dart` (modificar existente)

Adicionar `google_fonts` ao `pubspec.yaml` se ainda não presente. Dentro do `ThemeData`, adicionar a propriedade `textTheme` com os estilos definidos na seção "Typography" do `design_tokens.md`. Usar `GoogleFonts.spaceGroteskTextTheme()` como base e sobrescrever com `copyWith` para os papéis específicos.

Estrutura esperada:
```dart
textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
  displayLarge: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.64, color: Color(0xFFE2E2E7)),
  displayMedium: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, color: Color(0xFFE2E2E7)),
  bodyLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w400, height: 1.6, color: Color(0xFFE2E2E7)),
  bodyMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6, color: Color(0xFFE2E2E7)),
  labelSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2, letterSpacing: 0.6, color: Color(0xFFC1C6D7)),
  labelMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, height: 1.0, color: Color(0xFFE2E2E7)),
),
```

**Verificação**: Reiniciar o app; os textos de título devem exibir Space Grotesk.

---

## TD005 — Implementar temas globais de componentes em `app_widget.dart`

**Arquivo**: `lib/app/app_widget.dart` (modificar existente)

Dentro do `ThemeData`, adicionar ou substituir os temas dos componentes listados abaixo. Não remover o `appBarTheme` nem o `cardTheme` existentes — apenas atualizar/completar.

### ElevatedButtonTheme (botão primário)
```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF4B8EFF),
    foregroundColor: Color(0xFF002E69),
    minimumSize: Size(double.infinity, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
  ),
),
```

### OutlinedButtonTheme (botão secundário glassmorphic)
```dart
outlinedButtonTheme: OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: Color(0xFFE2E2E7),
    minimumSize: Size(double.infinity, 52),
    side: BorderSide(color: Color(0x33FFFFFF), width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
  ),
),
```

### InputDecorationTheme (campos de texto minimalistas)
```dart
inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor: Color(0xFF1E2023),
  floatingLabelStyle: TextStyle(color: Color(0xFFADC6FF)),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Color(0xFF414755)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Color(0xFF414755)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Color(0xFFADC6FF), width: 2),
  ),
  labelStyle: TextStyle(color: Color(0xFF8B90A0)),
  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
),
```

### CardTheme (atualizar o existente)
```dart
cardTheme: CardThemeData(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
    side: BorderSide(color: Color(0x33FFFFFF), width: 1),
  ),
  color: Color(0xFF1E2023),
  elevation: 0,
),
```

**Verificação**: `flutter analyze` sem erros. Botões e campos de texto devem refletir os novos estilos visualmente.

---

## TD006 — Criar utilitário de Glassmorphism

**Arquivo**: `lib/core/utils/glass_container.dart` (criar novo)

Criar um widget `GlassContainer` reutilizável que encapsula o efeito glassmorphic de nível 2. Deve aceitar `child`, `borderRadius` (padrão `BorderRadius.circular(24)`), e `padding` como parâmetros. Internamente usar `ClipRRect` + `BackdropFilter` com `ImageFilter.blur(sigmaX: 20, sigmaY: 20)` + `Container` com `color: Color(0x99111317)` e borda `Color(0x33FFFFFF)`.

Importar `dart:ui` para o `ImageFilter`.

**Verificação**: Widget compila e pode ser instanciado em qualquer tela sem erros.

---

## TD007 — Atualizar FloatingNavigationBar para pill glassmorphic

**Arquivo**: `lib/features/main/presentation/main_shell.dart` (modificar existente)

Substituir o `BottomNavigationBar` ou `NavigationBar` atual por um widget customizado posicionado com `Stack` + `Positioned` na base da tela. O widget deve:

- Ter formato pill (`BorderRadius.circular(9999)`)
- Usar fundo glassmorphic: `BackdropFilter blur(20)` + `color: Color(0x99111317)`
- Ter borda sutil: `Border.all(color: Color(0x33FFFFFF), width: 1)`
- Ter sombra: `BoxShadow(color: Colors.black, blurRadius: 40, offset: Offset(0, 8))`
- Exibir ícones em outline (usar `Icons.*_outlined`)
- Indicar item ativo com um ponto neon azul (`Color(0xFF4B8EFF)`) abaixo do ícone, não com cor de ícone

**Verificação**: A navigation bar aparece flutuando sobre o conteúdo, com visual pill e efeito de vidro.

