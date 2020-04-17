*** Settings ***
Documentation    Documentação da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#/Books
Library          RequestsLibrary
Library          Collections

*** Variables ***
${URL}            https://fakerestapi.azurewebsites.net/api/
&{BOOK_19}        ID=19
...               Title=Book 19
...               PageCount=1900
&{BOOK_1932}       ID=1932
...               Title=testeMiguel
...               PageCount=119
&{BOOK_150}    ID=150
...               Title=string
...               PageCount=0

*** Keywords ***
Conectar minha API
    Create Session    fakeAPI    ${URL}

Requisitar todos os livros
    ${RESPOSTA}       Get Request    fakeAPI    Books
    Log    ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Conferir o status code
    [Arguments]       ${STATUSCODE_DESEJADO}
    Should Be Equal As Strings    ${RESPOSTA.status_code}    ${STATUSCODE_DESEJADO}

Conferir o reason
    [Arguments]       ${REASON_DESEJADO}
    Should Be Equal As Strings    ${RESPOSTA.reason}    ${REASON_DESEJADO}

Conferir se retorna uma lista com "${QTD_LIVROS}" livros
    Length Should Be    ${RESPOSTA.json()}    ${QTD_LIVROS}

Requisitar o livro "${ID_BOOK}"
    ${RESPOSTA}       Get Request    fakeAPI    Books/${ID_BOOK}
    Log    ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Conferir Livro
    [Arguments]       ${ID_BOOK}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    ID              ${BOOK_${ID_BOOK}.ID}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    Title           ${BOOK_${ID_BOOK}.Title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    PageCount       ${BOOK_${ID_BOOK}.PageCount}
    Should Not Be Empty               ${RESPOSTA.json()["Description"]}
    Should Not Be Empty               ${RESPOSTA.json()["Excerpt"]}
    Should Not Be Empty               ${RESPOSTA.json()["PublishDate"]}

Conferir todos os dados do livro "${ID_BOOK}"
    Conferir Livro    ${ID_BOOK}

Cadastrar um novo livro
    ${HEADERS}        Create Dictionary    content-type=application/json
    ${RESPOSTA}       Post Request    fakeAPI    Books
    ...                               data={"ID": 1932,"Title": "testeMiguel","Description": "testeMiguel","PageCount": 119,"Excerpt": "testeMiguel","PublishDate": "2020-04-16T10:53:53.207Z"}
    ...                               headers=${HEADERS}
    Log    ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Conferir se retorna todos os dados cadastrados do livro "${ID_BOOK}"
    Conferir Livro    ${ID_BOOK}

Alterar o livro "${ID_BOOK}"
    ${HEADERS}        Create Dictionary    content-type=application/json
    ${RESPOSTA}       Put Request    fakeAPI    Books/${ID_BOOK}
    ...                              data={"ID": ${ID_BOOK},"Title": "string","Description": "string","PageCount": 0,"Excerpt": "string","PublishDate": "2020-04-16T10:53:53.208Z"}
    ...                              headers=${HEADERS}
    Log    ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Conferir se retorna todos os dados alterados do livro "${ID_BOOK}"
    Conferir Livro    ${ID_BOOK}

Deletar o livro "${ID_BOOK}"
    ${RESPOSTA}       Delete Request    fakeAPI    Books/${ID_BOOK}
    Log    ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Conferir se deletou o livro "${ID_BOOK}"
    Should Be Empty    ${RESPOSTA.content}
