# In8Shop Mobile

**Parte 3 de 3 do Desafio Técnico da In8**

Este repositório contém o **App Mobile do In8Shop**, desenvolvido em **Flutter**, utilizando **Provider** para gerenciamento de estado e integração com backend em **NestJS**.

---

## 📝 Requisitos do Desafio

### Itens obrigatórios (React/Flutter)

| Requisito                                       | Implementado |
| ----------------------------------------------- | :----------: |
| Interface mobile com Flutter                    |      ✔       |
| Listagem de produtos de dois fornecedores       |      ✔       |
| Busca de produtos                               |      ✔       |
| Filtro de produtos (categoria, preço, desconto) |      ✔       |
| Carrinho de compras (adicionar/remover)         |      ✔       |
| Finalização da compra                           |      ❌      |
| Registro de compras                             |      ❌      |

> **Observação:** a funcionalidade de checkout e registro de pedidos será entregue em uma futura iteração.

### Itens opcionais

| Requisito                                          | Implementado |
| -------------------------------------------------- | :----------: |
| Backend em Node.js (NestJS) com endpoint unificado |      ✔       |
| Endpoint unificado de produtos (2 APIs externas)   |      ✔       |
| Persistência de pedidos em banco via API           |      ✔       |

---

## ✨ Funcionalidades Entregues

- **Catálogo de produtos**

  - Integração com backend NestJS
  - Endpoint unificado: `GET /api/products`

- **Busca e filtros**

  - Componente `SearchBarComponent`
  - Filtros: provider, categoria, preço mínimo/máximo, desconto

- **Carrinho de compras**

  - `CartProvider` com estado global
  - Adição e remoção de itens
  - Quantidade ajustável

- **Detalhe do Produto**

  - Informações de preço, desconto e fornecedor
  - Seletor de quantidade
  - Adicionar e remover do carrinho

- **App Responsivo**
  - Compatível com Android e iOS
  - Tema claro e escuro (`ThemeMode.system`)

---

## 🚀 Instalação & Execução

1. **Clone o projeto**

```bash
git clone <seu-repo-url>
cd in8shop_mobile
```

2. **Variáveis de ambiente**

Crie um arquivo `.env` na raiz:

```env
API_URL=http://localhost:8080
            OU
API_URL= https://backend-in8-nest-production.up.railway.app
```

3. **Instale dependências**

```bash
flutter pub get
```

4. **Execute o projeto**

```bash
flutter run
```

---

## 🗂️ Estrutura do Projeto

```text
lib/
├── src/
│   ├── modules/
│   │   ├── product/
│   │   │   ├── models/        # Modelo Product
│   │   │   ├── pages/         # products_page.dart, product_page_item.dart
│   │   │   ├── components/    # product_search.dart, product_filter.dart
│   │   │   └── widgets/       # product_card.dart
│   │   └── cart/
│   │       └── pages/         # cart_page.dart
│   ├── shared/
│   │   ├── providers/         # cart_provider.dart
│   │   ├── theme/             # app_theme.dart, app_colors.dart
│   │   └── utils/             # format_price.dart, truncate_text.dart
│   └── pages/                 # home_page.dart
```

---

## 🛠️ Scripts Úteis

```bash
flutter pub get      # Instalar dependências
flutter run          # Executar app
flutter build apk    # Gerar APK
flutter build ios    # Gerar para iOS
flutter analyze      # Analisar código
```

---

## 🤝 Contribuição

1. Fork & clone este repositório
2. Crie uma branch `feature/sua-feature`
3. Codifique e execute `flutter analyze`
4. Faça commit e envie PR para revisão

**Desenvolvido por Murilo Santiago**
