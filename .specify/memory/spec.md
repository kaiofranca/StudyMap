# Especificação: StudyMap — Mapa de Produtividade nos Estudos

## 1. Visão Geral
O StudyMap é uma aplicação móvel offline e nativa que registra sessões de estudo associadas à localização GPS do usuário. O objetivo é permitir que estudantes identifiquem objetivamente os locais onde rendem mais.

## 2. Fluxo de Utilização (Core)
1. O usuário abre o app e inicia uma sessão.
2. O app registra a localização (GPS) e a hora de início.
3. Ao terminar, o usuário insere a Matéria estudada e o Nível de Foco (1 a 5).
4. O app calcula o Índice de Produtividade (Foco x Duração) e guarda os dados.
5. O usuário acessa um Dashboard com um ranking dos melhores locais e gráficos de desempenho.

## 3. Telas e Funcionalidades Exigidas
- **Login / Auth:** Login com E-mail/Senha e com o Google (Integração com Firebase Auth).
- **Início de Sessão:** Botão principal para começar a gravar o tempo e obter o GPS.
- **Sessão em Andamento:** Cronômetro rodando, botão para parar. Ao parar, abre um modal para escolher a matéria e o nível de foco (1 a 5).
- **Dashboard de Produtividade:** Gráficos de barras (usando `fl_chart`) mostrando os índices e o ranking dos melhores locais do usuário.
- **Meu Perfil:** Informações do usuário logado e opção de logout.

## 4. Regras de Negócio
- Todo o armazenamento deve ser feito no `cloud_firestore` em subcoleções amarradas ao ID do usuário autenticado.
- A localização usa o `geolocator` para pegar as coordenadas no início da sessão.
- O cálculo de produtividade é sempre agrupado por Local.