# Plano Técnico de Implementação: StudyMap

## 1. Estratégia de Arquitetura
O projeto adotará a arquitetura **Feature-First** combinada com **Clean Architecture**. O objetivo é garantir o isolamento das regras de negócio, facilitar a manutenção e permitir a escalabilidade do app.

Cada funcionalidade do sistema (Auth, Session, Dashboard, Places, Subjects) residirá dentro de `lib/features/<nome_da_feature>/` e será rigorosamente dividida em três camadas:
- **`domain/`**: Coração da regra de negócio. Conterá as Entidades puras do Dart (ex: `SessionEntity`) e contratos de Repositórios (Interfaces). Esta camada não conhece o Flutter nem o Firebase.
- **`data/`**: Camada de infraestrutura. Conterá os Models (conversão de JSON/Firestore para Entidades) e as implementações dos Repositórios (`RepositoryImpl`), responsáveis por fazer as chamadas diretas ao Firebase (Firestore/Auth).
- **`presentation/`**: Camada de UI. Conterá as Telas (Widgets/Scaffolds) e os Controllers baseados no pacote `provider` para gerenciar o estado da tela e reagir às ações do usuário.

## 2. Stack Tecnológica e Dependências
As ferramentas oficiais que devem ser utilizadas para desenvolver os requisitos são:
- **Core:** Flutter (Dart).
- **Backend as a Service (BaaS):** `firebase_core`, `firebase_auth` (Login Google e Email/Senha) e `cloud_firestore` (Banco de Dados).
- **Gerência de Estado:** `provider` (injetando os repositórios e gerenciando o estado reativo das telas).
- **Geolocalização:** `geolocator` (para captura das coordenadas GPS) e `geocoding` (para converter latitude/longitude em endereços ou nomes legíveis).
- **Gráficos e UI:** `fl_chart` (para renderizar o ranking de produtividade no Dashboard).
- **Notificações:** `flutter_local_notifications` (para alertas de início de estudo programados).
- **Utilitários:** `intl` (para formatação de datas e horas) e `uuid` (para geração de IDs locais, se necessário).

## 3. Estratégia de Banco de Dados (Firestore)
Como o Cloud Firestore é um banco NoSQL, os dados não serão relacionais. A estrutura seguirá o modelo de subcoleções amarradas ao usuário autenticado, garantindo segurança e privacidade:
- Coleção Raiz: `users`
  - Documento do Usuário: `{user_uid}` (obtido via Firebase Auth)
    - Subcoleção: `sessions` (Guarda os registros com data, duração, foco, produtividade e IDs de local/matéria).
    - Subcoleção: `places` (Guarda os locais cadastrados/detectados via GPS).
    - Subcoleção: `subjects` (Guarda as matérias cadastradas pelo usuário).

O cálculo do `índice de produtividade` (Foco * (Duração em minutos / 60)) será calculado no momento de salvar a sessão e armazenado diretamente no documento da sessão para facilitar a leitura nos gráficos.

## 4. Padrões de Interface e Navegação
- **Design System:** O app utilizará **Material Design 3**.
- **Tema:** Dark Mode (Tema Escuro) por padrão, para conforto visual do estudante.
- **Navegação:** Será criado um "Shell" (uma tela principal em `lib/features/main_navigation/`) contendo um `BottomNavigationBar` para alternar entre as views de Sessão, Dashboard e Perfil sem perder o estado das telas. Rotas iniciais ficarão definidas em `lib/app/app_widget.dart`.

## 5. Design do App
---
name: StudyMap
colors:
  surface: '#111317'
  surface-dim: '#111317'
  surface-bright: '#37393d'
  surface-container-lowest: '#0c0e12'
  surface-container-low: '#1a1c1f'
  surface-container: '#1e2023'
  surface-container-high: '#282a2e'
  surface-container-highest: '#333539'
  on-surface: '#e2e2e7'
  on-surface-variant: '#c1c6d7'
  inverse-surface: '#e2e2e7'
  inverse-on-surface: '#2e3034'
  outline: '#8b90a0'
  outline-variant: '#414755'
  surface-tint: '#adc6ff'
  primary: '#adc6ff'
  on-primary: '#002e69'
  primary-container: '#4b8eff'
  on-primary-container: '#00285c'
  inverse-primary: '#005bc1'
  secondary: '#d3fbff'
  on-secondary: '#00363a'
  secondary-container: '#00eefc'
  on-secondary-container: '#00686f'
  tertiary: '#ffb595'
  on-tertiary: '#571e00'
  tertiary-container: '#ef6719'
  on-tertiary-container: '#4c1a00'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc6ff'
  on-primary-fixed: '#001a41'
  on-primary-fixed-variant: '#004493'
  secondary-fixed: '#7df4ff'
  secondary-fixed-dim: '#00dbe9'
  on-secondary-fixed: '#002022'
  on-secondary-fixed-variant: '#004f54'
  tertiary-fixed: '#ffdbcc'
  tertiary-fixed-dim: '#ffb595'
  on-tertiary-fixed: '#351000'
  on-tertiary-fixed-variant: '#7c2e00'
  background: '#111317'
  on-background: '#e2e2e7'
  surface-variant: '#333539'
typography:
  h1:
    fontFamily: Space Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  h2:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: 0.05em
  button:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: '1.0'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 32px
  xl: 48px
  container-margin: 20px
  bento-gap: 16px
---

### Brand & Style

Este design system projeta uma estética de prestígio, focada em foco absoluto e clareza cognitiva. Destinado a estudantes de alto desempenho e profissionais em aprendizado contínuo, a interface evoca uma sensação de calma tecnológica e profundidade.

A linguagem visual funde o **Minimalismo** com o **Glassmorphism**, utilizando camadas translúcidas para criar uma hierarquia baseada em profundidade em vez de apenas cor. O estilo é futurista e "limpo", eliminando ruídos visuais para priorizar o conteúdo educacional. A experiência do usuário deve parecer premium, como uma ferramenta de precisão envolta em uma estética noturna e imersiva.

### Colors

O sistema utiliza um "Deep Dark Mode" para maximizar o contraste e economizar energia em telas OLED. A base é o preto absoluto (#000000), enquanto superfícies secundárias utilizam o carvão escuro (#121212).

A cor de destaque, **Electric Blue**, é aplicada em elementos de ação e progresso. Gradientes neon que transitam do azul royal para o ciano são reservados para estados ativos e indicadores de sucesso. O texto utiliza variações de cinza claro e branco puro para garantir legibilidade máxima sem causar fadiga ocular.

### Typography

A tipografia combina a precisão geométrica da **Space Grotesk** para títulos com a funcionalidade utilitária da **Inter** para leitura contínua.

Os títulos devem ser curtos e diretos, utilizando o peso negrito para ancorar a página. O corpo do texto prioriza o espaçamento entre linhas (line-height) generoso para facilitar a absorção de conteúdo denso. Labels e metadados utilizam a Inter em caixa alta com leve espaçamento entre letras para um visual técnico e organizado.

### Layout & Spacing

O sistema adota uma filosofia de **Fluid Grid** baseada em módulos de 8px. A estrutura principal utiliza um modelo de grade de 4 colunas para dispositivos móveis, com margens laterais de 20px.

A organização de conteúdo segue o padrão **Bento-box**, onde cards de diferentes tamanhos se encaixam harmonicamente para exibir estatísticas, cursos e cronogramas. O espaçamento (gutters) entre os boxes é fixado em 16px para manter uma separação clara sem fragmentar a unidade visual do layout.

### Elevation & Depth

A profundidade não é comunicada através de sombras pesadas, mas sim através de **Glassmorphism** e camadas tonais.

1. **Nível 0 (Base):** OLED Black (#000000).
2. **Nível 1 (Cards):** Dark Charcoal (#121212) com bordas sutis de 1px (20% de opacidade branca).
3. **Nível 2 (Modais e Overlays):** Fundo translúcido com `backdrop-filter: blur(20px)` e opacidade de 60%.
4. **Sombras:** Sombras projetadas são raras, usadas apenas para elevar o Floating Navigation Bar, sendo extremamente suaves, largas e de cor preta pura.

### Shapes

O sistema de formas é definido por raios de curvatura generosos e orgânicos que contrastam com a tipografia técnica.

Cards de conteúdo e seções da grade bento utilizam um raio de **24px**. Botões e campos de entrada utilizam um raio de **14px** para uma aparência moderna e amigável ao toque. Elementos de navegação e chips de categoria adotam o formato **Pill (totalmente arredondado)**, reforçando a natureza tátil e fluida da interface.

### Components

#### Buttons

Os botões primários são preenchidos com o gradiente "Electric Blue". Os botões secundários utilizam um estilo de vidro (glassmorphic) com bordas finas e texto em branco. Todos os estados de hover/press devem incluir um leve brilho externo (neon glow).

#### Floating Navigation Bar

Uma barra flutuante em formato de pílula posicionada na base da tela. Possui fundo de vidro fosco, ícones minimalistas em outline e um indicador de estado ativo que utiliza um ponto neon azul.

#### Bento-Box Grids

Containers versáteis que organizam informações de forma assimétrica. Cada box deve ter um fundo levemente mais claro que o background principal para separação visual imediata.

#### Circular Progress Rings

Utilizados para metas de estudo. Devem apresentar um rastro escuro e um progresso em gradiente neon azul, acompanhado de um "glow" suave que simula luz emitida.

#### Minimalist Form Fields

Campos sem bordas completas ou apenas com uma linha de base discreta. O rótulo (label) flutua acima do campo quando focado, mantendo a interface limpa e focada na entrada de dados.

#### Cards de Estudo

Devem suportar imagens de capa com sobreposição de gradiente preto para garantir que o texto (títulos das lições) permaneça legível em qualquer circunstância.