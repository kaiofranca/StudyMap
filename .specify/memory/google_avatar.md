# StudyMap — Foto de Perfil via Google Auth

**Escopo**: Exibir a foto da conta Google do usuário autenticado na tela de Perfil.
**Dependência**: Usuário autenticado via `firebase_auth`. Nenhum pacote novo necessário.

---

## Como funciona

O Firebase Auth expõe `FirebaseAuth.instance.currentUser.photoURL` após o login com Google. Essa URL aponta diretamente para a foto da conta Google do usuário. Basta carregar essa URL em um `CircleAvatar` usando `NetworkImage`.

---

## GA001 — Expor `photoURL` na `UserEntity`

**Arquivo**: `lib/features/auth/domain/user_entity.dart` (modificar existente)

Adicionar o campo `photoUrl` à entidade:

```dart
class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;   // << adicionar este campo

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,          // << adicionar aqui
  });
}
```

---

## GA002 — Mapear `photoURL` no `AuthRepositoryImpl`

**Arquivo**: `lib/features/auth/data/auth_repository_impl.dart` (modificar existente)

No ponto onde o `User` do Firebase é convertido para `UserEntity`, adicionar o mapeamento de `photoURL`:

```dart
UserEntity _mapFirebaseUser(User firebaseUser) {
  return UserEntity(
    id: firebaseUser.uid,
    email: firebaseUser.email ?? '',
    name: firebaseUser.displayName,
    photoUrl: firebaseUser.photoURL,   // << adicionar esta linha
  );
}
```

> Se o repositório não tiver um método auxiliar como `_mapFirebaseUser`, localizar onde o `User` do Firebase é convertido para `UserEntity` (geralmente nos métodos `signInWithGoogle` e `signInWithEmailAndPassword`) e adicionar `photoUrl: firebaseUser.photoURL` em ambos.

---

## GA003 — Atualizar tela de Perfil para exibir a foto

**Arquivo**: `lib/features/profile/presentation/profile_screen.dart` (modificar existente)

Substituir o widget de avatar pelo código abaixo. Ele exibe a foto se disponível, e um ícone padrão como fallback caso o usuário tenha feito login por e-mail/senha (sem foto):

```dart
final String? photoUrl = authController.user?.photoUrl;

Stack(
  alignment: Alignment.center,
  children: [
    // Anel externo com glow azul
    Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF4B8EFF),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4B8EFF).withOpacity(0.45),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
    ),
    // Avatar com foto ou fallback
    CircleAvatar(
      radius: 48,
      backgroundColor: const Color(0xFF1E2023),
      backgroundImage: photoUrl != null
          ? NetworkImage(photoUrl)
          : null,
      child: photoUrl == null
          ? const Icon(
              Icons.person_outline,
              color: Color(0xFF8B90A0),
              size: 36,
            )
          : null,
    ),
  ],
),
```

> `authController` deve ser obtido via `context.watch<AuthController>()` ou equivalente já usado na tela.

---

## GA004 — Adicionar permissão de rede para imagens Google (Android)

**Arquivo**: `android/app/src/main/AndroidManifest.xml` (verificar existente)

Confirmar que a permissão de internet já está declarada. Se não estiver, adicionar antes da tag `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

> Esta permissão provavelmente já existe no projeto por causa do Firebase. Apenas verificar — não duplicar se já houver.

---

## Notas

- `photoURL` pode ser `null` para usuários que se cadastraram com e-mail/senha e nunca adicionaram foto ao perfil do Google. O fallback com ícone em GA003 cobre esse caso.
- A URL retornada pelo Google geralmente termina em `=s96-c` (96px). Para melhor resolução, substituir por `=s200-c` antes de passar para o `NetworkImage`:
  ```dart
  final String? photoUrl = authController.user?.photoUrl
      ?.replaceAll('=s96-c', '=s200-c');
  ```
- Não é necessário cache manual — o Flutter já faz cache de `NetworkImage` automaticamente em memória durante a sessão.

