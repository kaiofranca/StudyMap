# Constituição do Projeto StudyMap

## 1. Arquitetura Obrigatória
O aplicativo Flutter utiliza a abordagem **Feature-First** com **Clean Architecture**. 
Toda nova funcionalidade DEVE ser criada dentro do diretório `lib/features/<nome_da_feature>/`, dividida obrigatoriamente nas seguintes subcamadas:
- `data/`
- `domain/`
- `presentation/`

## 2. Regras de Modificação (Atenção)
- O projeto já possui as pastas estruturais e o Firebase configurado (incluindo o arquivo `firebase_options.dart`).
- **NUNCA** apague arquivos de configuração, o `main.dart` atual ou diretórios base existentes. Apenas adicione novos arquivos ou popule os existentes.

## 3. Stack Tecnológica Restrita
Você deve utilizar estritamente os seguintes pacotes para resolver os problemas:
- **Banco de Dados e Autenticação:** `cloud_firestore` e `firebase_auth` (Paradigma NoSQL via subcoleções).
- **Gerência de Estado:** `provider`.
- **Mapas/GPS:** `geolocator`.
- **Gráficos:** `fl_chart`.

## 4. Padrão de Interface (UI)
- **Design System:** Material Design 3.
- **Tema:** Dark Mode (Tema Escuro) como padrão, refletindo os wireframes.
- **Cor Primária:** Roxo (`#6750A4`).

## 5. Entrypoint e Rotas
- O ponto de entrada é obrigatório ser o `lib/main.dart`.
- As configurações de MaterialApp, tema e rotas globais devem residir em `lib/app/app_widget.dart`.