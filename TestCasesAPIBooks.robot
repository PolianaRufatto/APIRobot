*** Settings ***
Documentation     Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#/Books
Resource          ResourceAPI.robot
Suite Setup       Conectar minha API

*** Test Cases ***
Buscar a listagem de todos os livros (GET em todos os livros)
    Requisitar todos os livros
    Conferir o status code    200
    Conferir o reason         OK
    Conferir se retorna uma lista com "200" livros

Buscar um livro específico
    Requisitar o livro "19"
    Conferir o status code    200
    Conferir o reason         OK
    Conferir todos os dados do livro "19"

Cadastrar um novo livro (POST)
    Cadastrar um novo livro
    Conferir o status code    200
    Conferir o reason         OK
    Conferir se retorna todos os dados cadastrados do livro "1932"

Alterar um livro (PUT)
    Alterar o livro "150"
    Conferir o status code    200
    Conferir o reason         OK
    Conferir se retorna todos os dados alterados do livro "150"

Deletar um livro (DELETE)
    Deletar o livro "200"
    Conferir se deletou o livro "200"
