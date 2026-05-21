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
### 2. Configuração do Firebase
Por questões de segurança, as chaves do banco de dados (o arquivo `firebase_options.dart`) não são enviadas para o GitHub. Para rodar o projeto na sua máquina, você precisa conectá-lo ao seu próprio projeto do Firebase:

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/) e ative o **Authentication** e o **Firestore Database**.
2. Instale o CLI do Firebase e faça login:
   ```bash
   firebase login
   ```
3. Instale o FlutterFire CLI e configure o projeto:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   *(Selecione o projeto que você acabou de criar no painel do Firebase).*

### 3. Compilar e rodar
Com o emulador aberto ou celular conectado, execute:
```bash
# Para rodar em modo de desenvolvimento (Hot Reload ativo)
flutter run

# Para gerar um novo arquivo APK de instalação
flutter build apk --debug
```