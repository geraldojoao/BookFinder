# 📚 BookFinder

**BookFinder** é um aplicativo Flutter que permite pesquisar livros usando a API do Google Books.

---

## ✨ Funcionalidades

- 🔐 Login com Google via Firebase  
- 📚 Busca de livros com a API do Google Books  
- 📄 Visualização de detalhes do livro  
- ⭐ Adição de livros aos favoritos (armazenamento local)  
- 📱 Layout responsivo para diferentes tamanhos de tela  
- 🌙 Tema escuro nativo  
- 🔄 Tratamento de carregamento, erros e dados vazios  
- 🔗 Rotas nomeadas com passagem de parâmetros  
- 🌐 Interface 100% em Português  

---

## 🖼️ Pré-visualização

### Tela de Login
![Tela de Login](https://github.com/geraldojoao/BookFinder/blob/main/BookFinder/home.PNG)

### Tela de Resultados da Busca
![Tela de Resultados](https://github.com/geraldojoao/BookFinder/blob/main/BookFinder/lista.PNG)

---

## 🚀 Instalação

```yaml
environment:
  sdk: ">=2.18.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.5
  provider: ^6.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
