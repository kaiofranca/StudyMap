# Tarefa Crítica: Refatoração do Core Flow da Sessão e Correção do GPS

## 1. Contexto e Problema
O fluxo principal (Core Loop) do aplicativo está incorreto.
- **Erro de GPS:** A captura de latitude e longitude falha (retornando 0.0, 0.0) porque as permissões não estão sendo devidamente requisitadas ou aguardadas.
- **Erro de Fluxo (UI/UX):** O modal de seleção de local e matéria está abrindo no FINAL da sessão (ao parar) e permite apenas selecionar. Se o usuário não tiver locais/matérias pré-cadastrados, ele fica travado.
- **Comportamento Desejado:** Ao clicar em "Iniciar Sessão", um Modal de Preparação deve abrir IMEDIATAMENTE. O app busca o GPS. O modal permite *selecionar* ou *criar* um Local e uma Matéria. Só após confirmar neste modal é que o Cronômetro inicia. Ao parar o cronômetro, o app apenas pede o "Nível de Foco" (1 a 5) e salva a sessão.

## 2. Tarefas para o Agente (Execução Rigorosa)

### Tarefa A: Correção Nativa do GPS
- **Arquivo:** `android/app/src/main/AndroidManifest.xml`
- **Ação:** Adicionar as permissões de localização (acima da tag `<application>`):
  `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`

### Tarefa B: Refatoração do Serviço de Localização
- **Arquivo:** `lib/core/location/location_service.dart`
- **Ação:** Reescrever a captura de GPS utilizando `geolocator`.
  1. O método deve verificar `Geolocator.checkPermission()`.
  2. Se negado, deve chamar `Geolocator.requestPermission()`.
  3. Se a permissão for concedida, chamar `Geolocator.getCurrentPosition()` aguardando a resposta real.
  4. Nunca retorne 0.0 silenciosamente em caso de erro; levante uma `Exception` para a UI tratar.

### Tarefa C: Criação do Modal de Preparação (Pré-Sessão)
- **Arquivo Novo:** `lib/features/session/presentation/start_session_modal.dart`
- **Ações:** Criar um `BottomSheet` ou `Dialog` que contenha:
  1. **Status do GPS:** Um indicador de carregamento enquanto busca o GPS. Quando encontrar, exibir o endereço aproximado via `geocoding` (se disponível).
  2. **Campo de Local (Place):** Um Dropdown listando os locais do usuário. Deve incluir uma opção destacada: "+ Criar Local Atual". Se selecionada, exibe um `TextField` para dar nome ao local, salva no Firebase via `PlaceController` usando as coordenadas atuais, e seleciona o local recém-criado.
  3. **Campo de Matéria (Subject):** Um Dropdown listando as matérias. Deve incluir uma opção: "+ Criar Nova Matéria". Se selecionada, exibe um `TextField` para o nome (gera uma cor aleatória ou padrão), salva via `SubjectController`, e seleciona a recém-criada.
  4. **Botão "Começar a Estudar":** Valida se Local e Matéria estão selecionados. Se sim, fecha o modal retornando os IDs escolhidos.

### Tarefa D: Refatoração da Tela de Sessão (Session Screen & Controller)
- **Arquivos:** `lib/features/session/presentation/session_screen.dart` e `session_controller.dart`
- **Ações:**
  1. O botão principal "Iniciar Sessão" não deve mais disparar o timer diretamente. Ele deve chamar o `StartSessionModal` (Tarefa C).
  2. Apenas após o retorno positivo do modal (contendo `placeId` e `subjectId`), o estado da sessão muda para "em andamento" e o Timer inicia. Os IDs devem ser armazenados no estado do `SessionController`.
  3. O Botão "Parar Sessão" deve abrir um novo modal simples (`FinishSessionModal`) que pergunta APENAS o Nível de Foco (Slider ou botões de 1 a 5).
  4. Ao confirmar o foco, a entidade `SessionEntity` é montada (início, fim, foco, IDs armazenados) e enviada ao Firestore para cálculo de produtividade.

## 3. Regras de Integração
- Injete e consuma os Controllers corretos (`PlacesController`, `SubjectsController`) via `Provider` dentro dos modais para garantir que a UI reaja imediatamente à criação de um novo local ou matéria.
- Exiba `SnackBars` em caso de erro no GPS (ex: "Permissão de localização negada").
- Notifique o usuário ao concluir toda a refatoração.