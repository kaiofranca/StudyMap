# StudyMap — Design Tokens

> Fonte da verdade para todos os valores visuais do app. Não altere sem atualizar os arquivos de tarefa correspondentes.

---

## 1. Colors (ColorScheme Material 3)

Mapeamento direto para `ColorScheme.dark()` no Flutter:

| Token Flutter              | Hex       | ARGB             |
|----------------------------|-----------|------------------|
| `primary`                  | `#ADC6FF` | `0xFFADC6FF`     |
| `onPrimary`                | `#002E69` | `0xFF002E69`     |
| `primaryContainer`         | `#4B8EFF` | `0xFF4B8EFF`     |
| `onPrimaryContainer`       | `#00285C` | `0xFF00285C`     |
| `secondary`                | `#D3FBFF` | `0xFFD3FBFF`     |
| `onSecondary`              | `#00363A` | `0xFF00363A`     |
| `secondaryContainer`       | `#00EEFC` | `0xFF00EEFC`     |
| `onSecondaryContainer`     | `#00686F` | `0xFF00686F`     |
| `tertiary`                 | `#FFB595` | `0xFFFFB595`     |
| `onTertiary`               | `#571E00` | `0xFF571E00`     |
| `tertiaryContainer`        | `#EF6719` | `0xFFEF6719`     |
| `onTertiaryContainer`      | `#4C1A00` | `0xFF4C1A00`     |
| `error`                    | `#FFB4AB` | `0xFFFFB4AB`     |
| `onError`                  | `#690005` | `0xFF690005`     |
| `errorContainer`           | `#93000A` | `0xFF93000A`     |
| `onErrorContainer`         | `#FFDAD6` | `0xFFFFDAD6`     |
| `surface`                  | `#111317` | `0xFF111317`     |
| `onSurface`                | `#E2E2E7` | `0xFFE2E2E7`     |
| `surfaceContainerLowest`   | `#0C0E12` | `0xFF0C0E12`     |
| `surfaceContainerLow`      | `#1A1C1F` | `0xFF1A1C1F`     |
| `surfaceContainer`         | `#1E2023` | `0xFF1E2023`     |
| `surfaceContainerHigh`     | `#282A2E` | `0xFF282A2E`     |
| `surfaceContainerHighest`  | `#333539` | `0xFF333539`     |
| `onSurfaceVariant`         | `#C1C6D7` | `0xFFC1C6D7`     |
| `outline`                  | `#8B90A0` | `0xFF8B90A0`     |
| `outlineVariant`           | `#414755` | `0xFF414755`     |
| `inverseSurface`           | `#E2E2E7` | `0xFFE2E2E7`     |
| `onInverseSurface`         | `#2E3034` | `0xFF2E3034`     |
| `inversePrimary`           | `#005BC1` | `0xFF005BC1`     |
| `surfaceTint`              | `#ADC6FF` | `0xFFADC6FF`     |

### Constantes extras (criar em `lib/core/utils/app_colors.dart`)

```dart
static const Color cardBackground   = Color(0xFF1E2023); // surfaceContainer
static const Color cardBorder       = Color(0x33FFFFFF); // branco 20% opacidade
static const Color oledBlack        = Color(0xFF000000);
static const Color neonBlueStart    = Color(0xFF4B8EFF); // gradiente início
static const Color neonBlueEnd      = Color(0xFF00EEFC); // gradiente fim
static const Color glassBg          = Color(0x99111317); // 60% opacidade
```

---

## 2. Typography

Fontes: **Space Grotesk** (títulos) e **Inter** (corpo/labels).
Adicionar `google_fonts` ao `pubspec.yaml` se ainda não estiver presente.

| Papel (`TextTheme`)      | Família       | Size | Weight | lineHeight | letterSpacing |
|--------------------------|---------------|------|--------|------------|---------------|
| `displayLarge`           | Space Grotesk | 32   | 700    | 1.2        | -0.64         |
| `displayMedium`          | Space Grotesk | 24   | 600    | 1.3        | 0             |
| `bodyLarge`              | Inter         | 18   | 400    | 1.6        | 0             |
| `bodyMedium`             | Inter         | 16   | 400    | 1.6        | 0             |
| `labelSmall`             | Inter         | 12   | 600    | 1.2        | 0.6           |
| `labelMedium` (botões)   | Inter         | 16   | 600    | 1.0        | 0             |

> `letterSpacing` já em pixels lógicos (convertido de em): `-0.02em × 32 = -0.64`, `0.05em × 12 = 0.6`.

---

## 3. Shape

| Nome   | Flutter                        | Onde usar                              |
|--------|--------------------------------|----------------------------------------|
| `sm`   | `BorderRadius.circular(4)`     | Badges, chips internos                 |
| `md`   | `BorderRadius.circular(12)`    | Botões, campos de texto                |
| `lg`   | `BorderRadius.circular(24)`    | Cards, Bento boxes                     |
| `full` | `BorderRadius.circular(9999)`  | Navigation bar pill, chips de categoria|

---

## 4. Spacing (`lib/core/utils/app_spacing.dart`)

```dart
static const double xs              = 4;
static const double sm              = 12;
static const double base            = 8;
static const double md              = 24;
static const double lg              = 32;
static const double xl              = 48;
static const double containerMargin = 20;
static const double bentoGap        = 16;
```

---

## 5. Elevation & Glassmorphism

| Nível | Implementação Flutter                                                                                      |
|-------|------------------------------------------------------------------------------------------------------------|
| 0     | `color: Color(0xFF000000)` — fundo OLED base                                                               |
| 1     | `color: Color(0xFF1E2023)` + `Border.all(color: Color(0x33FFFFFF), width: 1)` + `BorderRadius.circular(24)`|
| 2     | `BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20))` + `color: Color(0x99111317)`            |

Sombra (apenas na FloatingNavigationBar):
```dart
BoxShadow(
  color: Colors.black,
  blurRadius: 40,
  spreadRadius: 0,
  offset: Offset(0, 8),
)
```
