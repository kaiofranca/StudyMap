# StudyMap — Especificação de Componentes

> Referência de comportamento e aparência para cada componente do design system. Usar em conjunto com `design_tokens.md`.

---

## 1. Botão Primário (ElevatedButton)

- **Fundo**: Gradiente linear de `Color(0xFF4B8EFF)` → `Color(0xFF00EEFC)` (ângulo 135°)
- **Texto**: Inter 16px, w600, cor `Color(0xFF002E69)`
- **BorderRadius**: 12px
- **Altura mínima**: 52px
- **Largura**: `double.infinity` (ocupa toda a linha por padrão)
- **Estado pressed/hover**: adicionar `BoxShadow` com `color: Color(0x664B8EFF), blurRadius: 20`

> Nota: O `ElevatedButton.styleFrom` não suporta gradiente nativo. Para o gradiente, encapsular o botão em um `Container` com `decoration: BoxDecoration(gradient: LinearGradient(...))` e usar `TextButton` transparente internamente, ou criar um widget `GradientButton` customizado.

---

## 2. Botão Secundário (OutlinedButton / glassmorphic)

- **Fundo**: Transparente com `BackdropFilter blur(10)` + `color: Color(0x1AFFFFFF)` (10% branco)
- **Borda**: `Color(0x33FFFFFF)`, 1px
- **Texto**: Inter 16px, w600, cor `Color(0xFFE2E2E7)`
- **BorderRadius**: 12px
- **Altura mínima**: 52px
- **Estado pressed/hover**: aumentar opacidade do fundo para `Color(0x33FFFFFF)`

---

## 3. Card / Bento Box

- **Fundo**: `Color(0xFF1E2023)` (surfaceContainer)
- **Borda**: `Border.all(color: Color(0x33FFFFFF), width: 1)`
- **BorderRadius**: 24px
- **Elevation**: 0 (sem sombra — a separação é tonal, não por sombra)
- **Padding interno padrão**: 20px
- **Gap entre cards no grid**: 16px (bentoGap)

---

## 4. FloatingNavigationBar

- **Posição**: `Stack` + `Positioned(bottom: 24, left: 20, right: 20)`
- **Formato**: pill — `BorderRadius.circular(9999)`
- **Altura**: 64px
- **Fundo**: `BackdropFilter blur(20)` + `color: Color(0x99111317)`
- **Borda**: `Border.all(color: Color(0x33FFFFFF), width: 1)`
- **Sombra**: `BoxShadow(color: Colors.black, blurRadius: 40, spreadRadius: 0, offset: Offset(0, 8))`
- **Ícones**: `Icons.*_outlined`, tamanho 24px, cor `Color(0xFF8B90A0)` (inativo)
- **Indicador ativo**: ponto circular de 6px, cor `Color(0xFF4B8EFF)`, posicionado abaixo do ícone
- **Ícone ativo**: cor `Color(0xFFADC6FF)`
- **Itens**: Sessão (home), Dashboard (bar_chart), Perfil (person)

---

## 5. Circular Progress Ring (metas de estudo)

- **Implementação**: `CustomPainter` ou `fl_chart` PieChart com anel
- **Rastro**: `Color(0xFF1E2023)`, strokeWidth 8px
- **Progresso**: gradiente `Color(0xFF4B8EFF)` → `Color(0xFF00EEFC)`, strokeWidth 8px, `StrokeCap.round`
- **Glow**: `MaskFilter.blur(BlurStyle.outer, 8)` na cor `Color(0x664B8EFF)` aplicado ao arco de progresso
- **Conteúdo central**: texto com porcentagem em `displayMedium` (Space Grotesk 24px w600)

---

## 6. Campo de Texto (InputDecoration)

- **Estilo**: label flutuante (`floatingLabelBehavior: FloatingLabelBehavior.auto`)
- **Fundo**: `Color(0xFF1E2023)`, `filled: true`
- **Borda padrão**: `Color(0xFF414755)`, 1px, radius 12px
- **Borda focada**: `Color(0xFFADC6FF)`, 2px, radius 12px
- **Label cor padrão**: `Color(0xFF8B90A0)`
- **Label cor flutuante (focado)**: `Color(0xFFADC6FF)`
- **Padding**: horizontal 16px, vertical 18px

---

## 7. GlassContainer (widget utilitário)

Encapsula o efeito glassmorphic de nível 2. API esperada:

```dart
GlassContainer({
  required Widget child,
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(24)),
  EdgeInsets padding = const EdgeInsets.all(20),
})
```

Internamente: `ClipRRect` → `BackdropFilter(blur 20)` → `Container(color: Color(0x99111317), border: Color(0x33FFFFFF) 1px)`.

---

## 8. Card de Sessão / Estudo

- **Fundo**: `Color(0xFF1E2023)` com borda `Color(0x33FFFFFF)`
- **Canto superior**: imagem de capa opcional com `ShaderMask` ou `Container` com gradiente negro sobreposto (`Colors.black` de baixo para cima, opacidade 0 → 0.85)
- **Título**: `displayMedium` (Space Grotesk 24px) sobre o gradiente, sempre legível
- **Chips de categoria**: pill (`BorderRadius.circular(9999)`), fundo `Color(0xFF282A2E)`, texto `labelSmall`

---

## 9. Chip de Categoria

- **Formato**: pill — `BorderRadius.circular(9999)`
- **Fundo**: `Color(0xFF282A2E)` (surfaceContainerHigh)
- **Borda**: `Color(0x33FFFFFF)`, 1px
- **Texto**: Inter 12px, w600, letterSpacing 0.6, cor `Color(0xFFC1C6D7)`, UPPERCASE
- **Padding**: horizontal 12px, vertical 6px
- **Estado selecionado**: fundo `Color(0xFF4B8EFF)`, texto `Color(0xFF002E69)`
