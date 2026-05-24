# Tarefa de Evolução: Sessão em Background, Notificação Persistente e Função Pausar

## 1. Contexto e Objetivos
A fase de testes revelou que o usuário precisa poder desligar a tela ou minimizar o app sem perder o progresso da sessão de estudo.
- **Objetivo 1:** Adicionar a funcionalidade de "Pausar" e "Retomar" a sessão atual.
- **Objetivo 2:** Garantir que o tempo seja calculado corretamente mesmo se o app for minimizado (utilizando validação por *timestamps* ao invés de depender apenas de um `Timer` contínuo).
- **Objetivo 3:** Exibir uma notificação persistente (*ongoing*) com o cronômetro rodando nativamente no Android enquanto a sessão estiver ativa, para que o usuário saiba que o estudo está sendo contabilizado.

## 2. Tarefas para o Agente (CLI)

### Tarefa A: Atualização do Serviço de Notificações
- **Arquivo:** `lib/core/notifications/notification_service.dart`
- **Ações:**
  1. Criar um novo método `showSessionOngoingNotification({required String subjectName})`.
  2. Na configuração do `AndroidNotificationDetails`, é OBRIGATÓRIO incluir as seguintes propriedades para criar o cronômetro nativo:
     `ongoing: true`, `autoCancel: false`, `showWhen: true`, `usesChronometer: true`.
  3. Criar um método `cancelSessionNotification()` que chama `flutterLocalNotificationsPlugin.cancel(id_da_notificacao)` para ser disparado quando a sessão for parada ou pausada.

### Tarefa B: Refatoração do `SessionController` (Lógica de Pausa e Background)
- **Arquivo:** `lib/features/session/presentation/session_controller.dart`
- **Ações:**
  1. Adicionar uma variável de estado booleana `isPaused` (padrão `false`).
  2. Implementar a função `pauseSession()`. Ela deve cancelar o `Timer` interno do Dart, alterar `isPaused` para `true`, e invocar `NotificationService.cancelSessionNotification()`.
  3. Implementar a função `resumeSession()`. Ela reativa o `Timer`, altera `isPaused` para `false` e chama novamente o `showSessionOngoingNotification`.
  4. Na função de iniciar a sessão, chamar `showSessionOngoingNotification` passando o nome da matéria selecionada.
  5. Na função de parar/finalizar a sessão, garantir que a notificação seja cancelada.

### Tarefa C: Evolução da Interface (`SessionScreen`)
- **Arquivo:** `lib/features/session/presentation/session_screen.dart`
- **Ações:**
  1. Integrar os botões de Pausa e Retomada na UI.
  2. Onde atualmente existe o botão "Parar Sessão", crie uma `Row` alinhada ao centro (`MainAxisAlignment.center`) com um espaçamento adequado (`SizedBox(width: 16)`).
  3. Exiba dois botões lado a lado:
     - Botão 1: Um botão de Pausa (ícone de pause). Se `isPaused` for verdadeiro, este botão deve mudar para um ícone de "Play" (Retomar). Ele deve invocar as respectivas funções do Controller criadas na Tarefa B.
     - Botão 2: O botão existente de "Finalizar/Parar" (que abre o modal de foco).
  4. Garanta que o estado da tela reaja à variável `isPaused` (ex: fazendo o texto do cronômetro piscar ou alterando levemente a cor para indicar o estado de pausa).

## 3. Regras de Execução
- A contagem do tempo total no `SessionController` deve refletir estritamente o tempo em que o app esteve em foco (descontando o tempo em que permaneceu pausado). 
- Utilize as instâncias já fornecidas pelo `Provider` e a arquitetura existente.
- Avise assim que a implementação for finalizada.