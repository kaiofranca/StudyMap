# StudyMap — Retoques Finais

---

## FF001 — Adicionar opção de remoção de Locais

**Arquivo**: tela/widget de listagem de locais (provavelmente em `lib/features/places/presentation/`)

**Problema**: A tela que lista os locais salvos não oferece nenhuma forma de remover um local cadastrado.

**O que fazer**:

Adicionar interação de remoção em cada item da lista de locais. O padrão recomendado é o `Dismissible` do Flutter (arrastar para o lado remove o item) ou um ícone de lixeira ao final de cada linha. Qualquer um dos dois é aceitável, mas deve haver uma confirmação antes de deletar — um `showDialog` com as opções "Cancelar" e "Remover" para evitar remoções acidentais.

A remoção deve chamar o método de delete no `PlacesController`, que por sua vez deve deletar o documento correspondente na subcoleção `places` do Firestore. Verificar se esse método já existe no repositório; se não existir, criá-lo.

**Verificação**: É possível remover um local salvo. Após a remoção, o item desaparece da lista imediatamente (sem precisar recarregar a tela) e não aparece mais como opção no modal de sessão.

---

## FF002 — Adicionar opção de remoção de Matérias

**Arquivo**: tela/widget de listagem de matérias (provavelmente em `lib/features/subjects/presentation/`)

**Problema**: Idêntico ao FF001, mas para matérias. Não há como remover uma matéria cadastrada.

**O que fazer**:

Aplicar a mesma solução descrita em FF001, desta vez na listagem de matérias. A remoção deve chamar o método de delete no `SubjectsController` e deletar o documento na subcoleção `subjects` do Firestore.

Atenção: ao remover uma matéria que já foi associada a sessões passadas, **não** apagar essas sessões — apenas remover a matéria da lista de opções. As sessões históricas devem manter o nome da matéria como texto salvo no documento, sem depender da existência da matéria no Firestore.

**Verificação**: É possível remover uma matéria. Após a remoção, o item desaparece da lista e não aparece mais como opção no modal de sessão. Sessões antigas que usavam essa matéria não são afetadas.

---

## FF003 — Corrigir seleção automática após criar matéria no modal de sessão

**Arquivo**: `lib/features/session/presentation/post_session_modal.dart` (ou onde o modal de seleção de matéria é implementado)

**Problema**: Quando o usuário cria uma nova matéria diretamente pelo modal de sessão, a seleção não muda para a matéria recém-criada — ela permanece na primeira matéria da lista. O comportamento esperado é que, ao confirmar a criação, a nova matéria já fique selecionada automaticamente. Verifique se o mesmo ocorre para locais de estudo.

**Causa provável**: O método de criação de matéria provavelmente salva no Firestore e atualiza a lista, mas não retorna nem comunica o ID ou objeto da matéria criada para o estado local do modal. A seleção continua apontando para o valor anterior (ou para o índice 0 da lista atualizada).

**O que fazer**:

Garantir que o método responsável por criar a matéria retorne a entidade ou o ID da matéria criada. Após a criação ser confirmada, atualizar a variável de estado que controla a matéria selecionada no modal para apontar para essa nova matéria — não para o índice 0 da lista.

Se o `SubjectsController` usa um método `addSubject` que não retorna nada (`void` ou `Future<void>`), alterá-lo para retornar a `SubjectEntity` criada ou seu ID, para que o modal consiga capturar e selecionar o item correto.

**Verificação**: Criar uma nova matéria pelo modal. Ao confirmar a criação, a matéria nova deve aparecer marcada como selecionada, sem que o usuário precise selecioná-la manualmente.

