# Tarefa de Correção: Implementação Completa de Autenticação (Google e Cadastro via E-mail)

## 1. Contexto do Problema
O aplicativo não está realizando cadastros. É necessário finalizar a implementação da autenticação, garantindo duas vias de acesso para o usuário: Login com Google (atualmente não implementado) e um fluxo de Cadastro Tradicional (E-mail e Senha) através de uma tela dedicada. Sem o usuário autenticado, o Firestore não consegue criar as subcoleções baseadas no `uid`.

## 2. Objetivos e Tarefas para o Agente (CLI)
Você deve atuar imediatamente nos seguintes arquivos para finalizar o fluxo de autenticação, mantendo a arquitetura do projeto:

### Tarefa A: Atualização de Dependências
- **Arquivo:** `pubspec.yaml`
- **Ação:** Adicionar o pacote `google_sign_in` compatível com a versão atual do Flutter.

### Tarefa B: Implementação no Repositório (Data e Domain Layer)
- **Arquivos:** `lib/features/auth/domain/auth_repository.dart` e `lib/features/auth/data/auth_repository_impl.dart`
- **Ações:**
  1. **Google Auth:** Substituir o `UnimplementedError` no método `loginWithGoogle`. Implementar o fluxo usando `GoogleSignIn` e `FirebaseAuth.instance.signInWithCredential`.
  2. **Cadastro por E-mail:** Garantir que exista a assinatura no domínio e implementar o método `registerWithEmailAndPassword(String email, String password)` no repositório utilizando `FirebaseAuth.instance.createUserWithEmailAndPassword`.

### Tarefa C: Conexão com o Controller (Presentation Layer)
- **Arquivo:** `lib/features/auth/presentation/auth_controller.dart`
- **Ações:**
  1. Implementar `loginWithGoogle()` manipulando o estado de `isLoading` e tratando falhas.
  2. Implementar `registerWithEmail(String email, String password)` chamando a nova função do repositório, também com tratamento de `isLoading` e mensagens de erro (ex: e-mail já em uso, senha fraca).

### Tarefa D: Atualização da Tela de Login Atual (UI)
- **Arquivo:** `lib/features/auth/presentation/login_screen.dart`
- **Ações:**
  1. Alterar o botão do Google (`onPressed: null`) para invocar `authController.loginWithGoogle()`.
  2. Adicionar um botão (ex: `TextButton`) na parte inferior da tela com o texto "Não tem uma conta? Cadastre-se", que faça a navegação para a nova tela de cadastro (Tarefa E).

### Tarefa E: Criação da Nova Tela de Cadastro (UI)
- **Arquivo Novo:** `lib/features/auth/presentation/signup_screen.dart` (ou similar)
- **Ações:**
  1. Criar um layout contendo campos para: E-mail, Senha e Confirmar Senha.
  2. Implementar lógica de validação básica (garantir que "Senha" e "Confirmar Senha" sejam iguais antes de tentar o cadastro).
  3. Adicionar um botão principal "Criar Conta" que execute o `registerWithEmail` do Controller.
  4. Em caso de sucesso, navegar para a estrutura principal do app (`MainShell` ou equivalente). Em caso de erro, exibir um `SnackBar` com o feedback para o usuário.

## 3. Regras de Execução
- Siga rigorosamente a **Clean Architecture** (Pastas Data, Domain e Presentation) e o uso do pacote **Provider** para injeção e gerência de estado.
- Utilize o Material Design 3 e mantenha a identidade visual do projeto (Tema Escuro, botão primário na cor Roxa).
- Após concluir as alterações em todos os arquivos, notifique o usuário da conclusão do fluxo.