# Tarefa: Sincronizar Cadastro do Auth com o Firestore

## 1. Contexto do Problema
Atualmente, quando um usuário se cadastra (via E-mail ou Google), a conta é criada no Firebase Authentication, mas nenhum registro de perfil é criado no banco de dados Cloud Firestore. Precisamos garantir que um documento raiz do usuário seja criado na coleção `users` imediatamente após o cadastro bem-sucedido.

## 2. Tarefa para o Agente (CLI)
Você deve modificar a implementação do repositório de autenticação para gravar os dados do usuário no Firestore após o registro.

- **Arquivo a modificar:** `lib/features/auth/data/auth_repository_impl.dart`
- **Ações Exigidas:**
  1. No método de **Cadastro com E-mail/Senha**, após receber o `UserCredential` do `createUserWithEmailAndPassword`, extraia o `uid` e o `email`.
  2. No método de **Login com Google**, após receber o `UserCredential` de `signInWithCredential`, faça a mesma extração (incluindo o nome, se disponível).
  3. Em AMBOS os métodos, adicione uma chamada ao Firestore para criar/atualizar o documento do usuário:
     ```dart
     await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
       'email': user.email,
       'name': user.displayName ?? '',
       'created_at': FieldValue.serverTimestamp(),
     }, SetOptions(merge: true));
     ```
  4. Certifique-se de importar `package:cloud_firestore/cloud_firestore.dart` no topo do arquivo.

## 3. Regra de Execução
O uso de `SetOptions(merge: true)` é obrigatório no Google Login para evitar que dados de usuários que já existem sejam sobrescritos caso eles façam login novamente. Após concluir, avise o usuário.