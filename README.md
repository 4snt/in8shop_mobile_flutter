# In8Shop Mobile

**Parte 3 de 3 do Desafio Técnico da In8**

Este repositório contém o **App Mobile do In8Shop**, desenvolvido em **Flutter**, com gerenciamento de estado utilizando **Provider** e integração total com o backend em **NestJS**.

---

## 📝 Requisitos do Desafio

### Itens obrigatórios (Flutter)

| Requisito                                       | Implementado |
| ----------------------------------------------- | :----------: |
| Interface mobile com Flutter                    |      ✔       |
| Listagem de produtos de dois fornecedores       |      ✔       |
| Busca de produtos                               |      ✔       |
| Filtro de produtos (categoria, preço, desconto) |      ✔       |
| Carrinho de compras (adicionar/remover)         |      ✔       |
| Finalização da compra                           |      ✔       |
| Registro de compras                             |      ✔       |

### Itens opcionais

| Requisito                                          | Implementado |
| -------------------------------------------------- | :----------: |
| Backend em Node.js (NestJS) com endpoint unificado |      ✔       |
| Endpoint unificado de produtos (2 APIs externas)   |      ✔       |
| Persistência de pedidos em banco via API           |      ✔       |

---

## ✨ Funcionalidades Entregues

- ✅ **Catálogo de Produtos**
- ✅ **Busca e Filtros**
- ✅ **Carrinho de Compras**
- ✅ **Finalização de Pedido (Checkout)**
- ✅ **Confirmação de Pagamento**
- ✅ **Tela "Meus Pedidos"**
- ✅ **Login e Cadastro**
- ✅ **App Responsivo**

---

## 🚀 Instalação & Execução

### 🔗 Clonar o projeto

```bash
git clone <seu-repo-url>
cd in8shop_mobile_flutter
```

### 🔑 Configurar variáveis de ambiente

Crie um arquivo `.env` na raiz:

```env
API_URL=https://backend-in8-nest-production.up.railway.app <= recomendo usar esse para  facilitar os testes
OU
API_URL=https://seu.ipv4:8080/
```

### 📦 Instalar dependências

```bash
flutter pub get
```

### ▶️ Executar o projeto

```bash
flutter run
```

### 🔥 Gerar APK

```bash
flutter build apk --release
```

O APK estará em:

```bash
build/app/outputs/flutter-apk/app-release.apk
```

### 🍏 Gerar para iOS

```bash
flutter build ios --release
```

> ⚠️ Necessário rodar em macOS com Xcode instalado.

---

## 🗂️ Estrutura do Projeto

```plaintext
lib
├── main.dart
├── src
│   ├── pages
│   ├── shared
│   │   ├── components
│   │   ├── models
│   │   ├── providers
│   │   ├── services
│   │   ├── theme
│   │   ├── utils
│   │   └── widgets
assets
├── fonts
├── images
```

---

## ✅ Features Técnicas

- Arquitetura limpa e modular
- Provider para estado global
- Persistência de sessão (token)
- Toast customizado
- API única para produtos de dois fornecedores

---

## 💡 Melhorias Futuras

- Tela de detalhe do pedido
- Histórico detalhado de produtos comprados
- Controle de estoque
- Melhorias visuais e UX

---

## 🤝 Contribuição

1. Fork & clone este repositório
2. Crie uma branch `feature/sua-feature`
3. Execute `flutter analyze`
4. Commit e envie um PR 🚀

---

## 🧠 Desenvolvido por

**Murilo Santiago**
