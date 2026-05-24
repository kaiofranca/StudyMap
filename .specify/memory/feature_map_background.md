# Tarefa de Design e Fluxo: Fundo com Mapa Interativo na Inicialização da Sessão

## 1. Contexto e Objetivo
Queremos alterar radicalmente o design inicial da feature de Sessão (`lib/features/session/`). 
- **Estado Incial (Ocioso):** A tela não deve exibir o cronômetro. O fundo da tela deve ser um mapa interativo (Google Maps) centralizado na localização atual do usuário. O mapa deve renderizar Pins (*Markers*) em todos os locais de estudo (`places`) já cadastrados pelo usuário no banco de dados. No rodapé do mapa, deve haver apenas um botão flutuante "Iniciar Sessão".
- **Transição de Fluxo:** Ao clicar em "Iniciar Sessão", abre-se o `StartSessionModal` (modal de preparação para escolha/criação de matéria e local).
- **Estado Ativo (Em Andamento):** Assim que o usuário confirmar os dados no modal, o mapa sai de cena e a interface muda para a tela de cronômetro já existente, iniciando a contagem do tempo.

## 2. Tarefas para o Agente (CLI)

### Tarefa A: Atualização do `pubspec.yaml`
- **Ação:** Adicionar o pacote `Maps_flutter` sob as dependências do projeto, garantindo compatibilidade com a versão atual do Flutter.

### Tarefa B: Configuração Nativa (Android)
- **Arquivo:** `android/app/src/main/AndroidManifest.xml`
- **Ação:** Adicionar a tag de metadados da API do Google Maps dentro do bloco `<application>`:
  ```xml
  <meta-data 
      android:name="com.google.android.geo.API_KEY"
      android:value="YOUR_API_KEY_HERE" />
  ```
  *(Nota: Deixe o valor como "YOUR_API_KEY_HERE" ou use uma String vazia para que o usuário insira sua chave do Google Cloud manualmente depois).*

### Tarefa C: Adaptação no Controller da Sessão
- **Arquivo:** `lib/features/session/presentation/session_controller.dart`
- **Ações:**
  1. Garantir que o controller exponha claramente se a sessão está ativa ou não (ex: uma propriedade booleana `isSessionActive`).
  2. Criar um método ou getter que consuma a lista de locais do `PlacesController` e a converta em um `Set<Marker>` do Google Maps. Cada Marker deve usar a `latitude` e `longitude` do local e exibir o nome do local no atributo `infoWindow`.

### Tarefa D: Refatoração Cosmética da Tela (`session_screen.dart`)
- **Arquivo:** `lib/features/session/presentation/session_screen.dart`
- **Ações:**
  1. Utilizar uma estrutura condicional (`if (!controller.isSessionActive)`) para alternar o layout da tela.
  2. **Layout Sem Sessão (Mapa):** Retornar um `Stack` contendo:
     - Na base: O widget `GoogleMap` ocupando a tela cheia. Configurar `initialCameraPosition` usando o GPS atual obtido do `LocationService`. Atribuir o `Set<Marker>` gerado na Tarefa C. Desativar botões poluentes do mapa se achar necessário (`myLocationButtonEnabled: false`, etc).
     - No topo (Overlay): Um botão customizado e estilizado (Roxo, Material 3, Dark) centralizado na parte inferior da tela com o texto "Iniciar Sessão".
  3. **Layout Com Sessão (Cronômetro):** Exibir o layout com o Timer correndo e o botão "Parar Sessão" (exatamente como já está implementado no app atual).

## 3. Regras de Design e UI
- O mapa deve se integrar de forma fluida. Certifique-se de que o botão flutuante "Iniciar Sessão" use elevação suficiente e cores contrastantes do tema escuro (Dark Mode) para não sumir visualmente sobre os detalhes das ruas do mapa.
- Caso o serviço de GPS ainda esteja carregando a posição inicial, exiba um `CircularProgressIndicator` centralizado antes de renderizar o mapa.
- Notifique o usuário assim que todas as alterações de código forem concluídas.