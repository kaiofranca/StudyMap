# StudyMap

O **StudyMap** é um aplicativo móvel nativo desenvolvido em Flutter voltado para a otimização de rotinas de estudo. A proposta central do aplicativo é solucionar um problema comum entre estudantes: a falta de dados objetivos sobre quais ambientes externos ou internos favorecem ou prejudicam a sua concentração.

Associando sessões de cronometragem ativa à coleta de coordenadas geográficas via GPS, o aplicativo ajuda estudantes a identificar analiticamente onde seu rendimento atinge o potencial máximo.

---

## Funcionalidades principais

- **Rastreamento de sessão por GPS:** Captura automatizada da localização no início do ciclo de estudo, convertendo coordenadas geográficas em endereços legíveis por humanos (*Geocoding*).
- **Métricas de produtividade:** Entrada manual da matéria estudada associada a uma escala avaliativa de foco (1 a 5). O sistema calcula dinamicamente o Índice de Produtividade:
  $$\text{Índice} = \text{Nível de Foco} \times \left(\frac{\text{Duração em Minutos}}{60}\right)$$
- **Dashboard analítico:** Exibição de gráficos de barras horizontais e verticais com o ranqueamento dos locais mais produtivos do usuário.
- **Lembretes ativos:** Configuração de notificações locais agendadas para alertar o estudante sobre o início de seus blocos de foco.

---

## Stack tecnológica & arquitetura

O projeto foi construído seguindo rigorosos padrões de engenharia de software para garantir escalabilidade, testabilidade e separação clara de conceitos:

- **Framework:** Flutter 3.x (Linguagem Dart)
- **Arquitetura:** *Feature-First* combinada com *Clean Architecture* (Divisão explícita em camadas `domain`, `data` e `presentation` dentro de módulos isolados).
- **Gerência de estado:** Provider (Arquitetura reativa leve e performática).
- **Backend as a Service (BaaS):** Firebase Ecosystem.
  - **Firebase Authentication:** Gestão de usuários.
  - **Cloud Firestore:** Banco de Dados NoSQL orientado a documentos (Organizado em subcoleções privadas por UID do usuário).
- **Pacotes Principais:** `geolocator`, `geocoding`, `fl_chart`, `flutter_local_notifications`.
- **UI/UX:** Material Design 3 configurado nativamente com suporte a *Dark Mode*.

---

## Como executar o StudyMap

### Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
- Dispositivo Android físico (com depuração USB ativa) ou Emulador configurado.

### 1. Clonar e preparar o projeto
Abra o seu terminal e execute:
```bash
# Clonar o repositório
git clone https://github.com/SEU_USUARIO/studymap.git
cd studymap

# Baixar as dependências do Flutter
flutter pub get
```
### 2. Configuração do Backend (Firebase & Autenticação)
Você precisará vincular o app ao seu próprio projeto do Firebase para que o banco de dados e o login funcionem.

1. Acesse o [Firebase Console](https://console.firebase.google.com/) e crie um novo projeto.
2. Ative o **Firestore Database** (inicie em modo de teste) e o **Authentication** (ative os provedores *E-mail/Senha* e *Google*).
3. No seu terminal, faça login na sua conta do Google e instale o assistente do FlutterFire:
   ```bash
   firebase login
   dart pub global activate flutterfire_cli
   ```
4. Execute o comando de vinculação:
   ```bash
   flutterfire configure
   ```
   *(Este comando vai gerar automaticamente o arquivo `lib/firebase_options.dart` e os arquivos `.json` nativos contendo as chaves públicas de conexão).*

**Importante para o Google Login:** Para que o login com o Google funcione no Android, você precisa extrair a chave **SHA-1** do seu computador e adicioná-la nas configurações do app Android dentro do painel do Firebase.

### 3. Configuração do Google Maps (API Key)
O mapa interativo na tela de sessão exige uma chave de API do Google Cloud injetada de forma segura durante a compilação.

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/).
2. Crie ou selecione um projeto e ative a biblioteca **Maps SDK for Android**.
3. Gere uma credencial do tipo **Chave de API**.
4. No seu projeto Flutter, abra o arquivo `android/local.properties` (se o arquivo não existir, crie-o na raiz da pasta `android/`).
5. Adicione a sua chave no final do arquivo exatamente com esta sintaxe:
   ```properties
   MAPS_API_KEY=sua_chave_gerada_aqui
   ```
   *(Nota: O arquivo `local.properties` é ignorado pelo Git, garantindo que sua chave privada nunca vaze).*

### 4. Compilar e rodar
Com as chaves do Firebase geradas e a chave do Maps configurada, o projeto já pode ser executado!

Com o emulador aberto ou celular conectado, rode:
```bash
# Para rodar em modo de desenvolvimento (Hot Reload)
flutter run

# Para compilar o APK de instalação
flutter build apk --debug
```