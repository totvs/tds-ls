# TDS LS 

O projeto **TDS LS** é a implementação da **TOTVS** da especificação do [*Language Server Protocol*](https://microsoft.github.io/language-server-protocol/) que pode ser utilizada por quaisquer *IDEs* ou *editores* que suportam este protocolo.

Atualmente o **TDS LS** é utilizado pela extensão [**TDS-VS Code**](https://github.com/totvs/tds-vscode)) e pelo [**TDS Eclipse**](https://github.com/totvs/tds-eclipse).

Também pode ser usado em [interface de linha de comando](.TDS-CLi.md) para automação de tarefas ou editores que não suportem o **LSP**.

## Especificação

Além das mensagens especificadas do protocolo **LSP**, o **TDS LS** implementa mensagens adicionais (`$totvsserver`) de uso dos _AppServers_ da **TOTVS**, para realizar a conexão, compilação, aplicação de _patches_ dentre outras ações.

Assim que estabilizadas as mensagens adicionais serão documentadas aqui para que quailquer desenvolvedor possa implementar sua própria *IDE* e utilizar o motor do **TDS LS**.

## Chamados

Esse repositório não é acompanhado pela equipe de desenvolvimento, para problemas com a utilização dessa ferramenta, favor utilizar o repositório do tds-vscode: https://github.com/totvs/tds-vscode/

## Mensagens `$totvsserver`

| Mensagem                    | Descrição                                |
|-----------------------------|------------------------------------------|
| $totvsserver/authentication | Conexão e autenticação com o *AppServer* |
| $totvsserver/compilation    | Compilação de fontes no *RPO*            |
| ...                         | ...                                      |

> **TODO** - Lista completa e detalhada dos parâmetros das mensagens
