# TDS-CLI Arquivo de execução (_script_)

O TDS-CLI necessita de um arquivo de execução (_script_) contendo as informações das ações que ele deverá executar ao ser invocado.

## Informações gerais

**ATENÇÃO**: Este arquivo deve ter o formato ANSI (CP1252). Caso contrário poderá ocorrer erro na sua execução.

**RECOMENDAÇÃO**: Prefira o uso de um arquivo de execução com a extensão **.INI**, pois editores como o próprio VSCode farão seu _syntax highlight_, facilitando o desenvolvimento.

### Características do arquivo de execução

- Formato ANSI (CP1252);
- As marcações "`#`" ou "`;`" representam os comentários do arquivo de execução;
- Use as marcaçções `[]` para subdividir as seções a serem executadas, exemplo:

```ini
;Exemplo
[Conectando]
action = authentication
...
[Compacta RPO]
action = defragRPO
```

- **Importante**: Duas seções **não devem ser declaradas** no arquivo de execução como subdivisão customizada:

    - `[general] -> apenas para uso interno`
    - `[user] -> onde definimos as variáveis de ambiente`

### Usando caminhos relativos ou absolutos

Quando for necessário indicar um arquivo, como um _patch_ por exemplo, você poderá fazer uso de caminhos absolutos:

> **Windows:** `C:\dir\file.ptm` **ou Linux:** `/home/user/dir/file.ptm`

Ou utilizar caminhos relativos ao diretório do seu arquivo de execução:

> **Windows:** `dir\file.ptm` **ou Linux:** `dir/file.ptm`

**RECOMENDAÇÃO**: Prefira usar **caminhos absolutos**, garantindo a correta localização dos arquivos.

Você pode utilizar a barra **`/`** como separador de diretórios independentemente do seu sistema operacional.

> A execução do TDScli-LS no **Linux** deve respeitar as regras do _AppServer Protheus_ para este sistema operacional, que são:

- Utilize apenas **caracteres minúsculos** na composição do diretorio/arquivo.ext;
- **Não utilize acentuação** na composição diretorio/arquivo.ext.

### Exemplo de arquivo de execução

Agora que conhecemos o arquivo de execução vamos ver um exemplo:

#### Exemplo

```ini
; logToFile: diretorio/arquivo para arquivar log da execução
; showConsoleOutput: True exibe informações no console
logToFile=/home/mansano/TDScli/logs/log1.log
showConsoleOutput=true

; Na seção [user] definimos as variáveis de ambiente
[user]
INCLUDE_DIR=/home/mansano/_c/lib120/src/include/

; Conexão e autenticação com o AppServer
[authentication]
action=authentication
server=192.168.0.198
port=5025
secure=0
build=7.00.170117A
environment=producao
user=admin
psw=****

; Compilando dois fontes
[compile]
action=compile
program=/home/mansano/TDScli/src/prog1.prw,/home/mansano/TDScli/src/prog2.prw
recompile=T
includes=${INCLUDE_DIR}
```

#### Retorno

```log
[LOG] Starting connection to the server 'TDScli.serverName' (192.168.0.198@5025)
[LOG] Connection to the server 'TDScli.serverName' finished.
[LOG] Starting user 'admin' authentication.
[LOG] Authenticating...
[LOG] User authenticated successfully.
[LOG] User 'admin' authentication finished.
[INFO] Starting recompile.
[LOG] Starting build for environment producao.
[LOG] Start recompile of 2 files.
[LOG] Start regular compiling /home/mansano/TDScli/src/prog1.prw (1/2).
[LOG] [SUCCESS] Source /home/mansano/TDScli/src/prog1.prw compiled successfully.
[LOG] Start regular compiling /home/mansano/TDScli/src/prog2.prw (2/2).
[LOG] [SUCCESS] Source /home/mansano/TDScli/src/prog2.prw compiled successfully.
[LOG] Committing end build.
[LOG] All files compiled successfully.
[INFO] Recompile finished.
```

## Seções de configuração

### Parâmetros gerais

Os parâmetros gerais devem sempre ser inseridos no **início do arquivo** do script de execução.

| Parâmetro         | Valor                 | Descrição                                                  |
| ----------------- | --------------------- | ---------------------------------------------------------- |
| logToFile         | diretorio/arquivo.log | Arquivo que receberá as informações da execução do arquivo |
| showConsoleOutput | True (T) ou False (F) | Exibe ou não exibe informações no console                  |

#### Exemplo - Parâmetros gerais

```ini
; logToFile: diretorio/arquivo para arquivar log da execução
; showConsoleOutput: True exibe informações no console
logToFile=/home/mansano/TDScli/logs/log1.log
showConsoleOutput=true
```

### Seção `[user]`

Na seção `[user]` definimos as variáveis de ambiente, que podem ser usadas em todas as seções do arquivo de execução.

> Para utilização da variável de ambiente use a macro `${var_name}`

#### Exemplo `[user]`

```ini
[user]
INCLUDE_DIR=/home/mansano/_c/lib120/src/include/
...
[compile]
action=compile
includes=${INCLUDE_DIR}
```

## Seções de execução

As seções permitem **organizar** seu arquivo de execução, para seu nome é permitido uso de espaços e caracteres especiais.

### Exemplo básico

```ini
[compilação de arquivos]
action=compile
...
```

A execução do **arquivo é sequencial**, percorrendo todas as seções cadastradas.

> O parâmetro **`skip=True`** utilizado em uma seção permite ignorar sua execução, isso pode ser util caso necessite reaproveitar o mesmo arquivo de execução para várias finalidades.</br>
> </br>
> Cada seção deve conter apenas uma **`action`**, que serão explicadas a seguir.

No exemplo a seguir a ação de compilação não será executada, pois está marcada como `skip`.

### Exemplo `skip`

```ini
[compilação de arquivos]
skip=true
action=compile
```

## Ações de execução (`action`)

### `action = validate`

Obtém a versão de _release_ do AppServer, permitindo seu uso na tag **build** da **action authentication**.

| Parâmetro | Valor    | Descrição                                                              |
| --------- | -------- | ---------------------------------------------------------------------- |
| server    | IP       | Endereço IP do AppServer                                               |
| port      | numérico | Porta do AppServer                                                     |

Informações do retorno da validação.

| Parâmetro | Valor        | Descrição                                                              |
| --------- | ------------ | ---------------------------------------------------------------------- |
| build     | 7.00.170117A | Build do AppServer validado                                            |
| secure    | 1 ou 0       | Se a conexão é segura ou não, 1=Conexão segura, 0=Conexão convencional |

#### Exemplo `action = validate`

```ini
[validate]
action=validate
server=192.168.0.198
port=5025
```

#### Retorno `action = validate`

```log
[LOG] Appserver detected with build version: 7.00.170117A and secure: 0
build: 7.00.170117A / secure: 0
```

### `action = authorization`

Aplica o token de compilação (Harpia) ou chave de compilação.

> O **token de compilação** é de uso exclusivo da TOTVS para o Appserver Harpia.

| Parâmetro | Valor               | Descrição                    |
| --------- | ------------------- | ---------------------------- |
| authtoken | Token de compilação | Define o token de compilação |

```ini
[authorization]
action=authorization
authtoken=<token de compilação>
```

#### Deprecated - O uso da **chave de compilação** deve ser substituida pela utilização do **token de compilação**

> O **ID** do TDScli-LS é diferente do TDScli-Eclipse, tornando as **chaves de compilação** incompatíveis.

| Parâmetro     | Valor                                   | Descrição                                  |
| ------------- | --------------------------------------- | ------------------------------------------ |
| authorization | Caminho relativo ou absoluto do arquivo | Define o arquivo com a chave de compilação |

```ini
[authorization]
action=authorization
authorization=/home/mansano/TDScli/ED75-E184.aut
```

> Em caso de erro na carga do arquivo, confirme o ID da estação de trabalho, utilizando a action **getID**.

### `action = authentication`

Executa a conexão com o AppServer.

| Parâmetro   | Valor             | Descrição                                                              |
| ----------- | ----------------- | ---------------------------------------------------------------------- |
| server      | IP                | Endereço do AppServer                                                  |
| port        | numérico          | Porta em que o AppServer escuta                                        |
| secure      | 1 ou 0            | Se a conexão é segura ou não, 1=Conexão segura, 0=Conexão convencional |
| build       | _build_ ou _AUTO_ | Release do AppServer ou AUTO para detecção automática                  |
| user        | "nome de usuário" | Usuário para autenticação                                              |
| psw         | "senha"           | Senha para autenticação                                                |
| environment | "ambiente"        | Ambiente na qual será efetuada a autenticação                          |

#### Exemplo `action = authentication`

```ini
[authentication]
action=authentication
server=192.168.0.198
port=5025
secure=0
build=AUTO
environment=producao
user=admin
psw=
```

#### Retorno `action = authentication`

```log
[LOG] Appserver detected with build version: 7.00.170117A and secure: 0
[LOG] Starting connection to the server 'TDScli.serverName' (192.168.0.198@5025)
[LOG] Connection to the server 'TDScli.serverName' finished.
[LOG] Starting user 'admin' authentication.
[LOG] Authenticating...
[LOG] User authenticated successfully.
[LOG] User 'admin' authentication finished.
```

### `action = compile`

Executa a compilação/recompilação de programas no RPO.

> Esta action depende da **action authentication**.</br>
> </br>
> Se for executar uma compilação que necessite do uso do **token de compilação** crie a seção com a **action `authorization`** antes desta ação.

| Parâmetro   | Valor                                                       | Descrição                                                                                                                                                                   |
| ----------- | ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| program     | Nomes dos arquivos e/ou diretórios separados por `,` ou `;` | Programas a serem processados                                                                                                                                               |
| programList | Caminho relativo ou absoluto do arquivo                     | Arquivo contendo os nomes dos arquivos (**fontes ou recursos**) a serem processados (**um arquivo por linha**)                                                              |
| recompile   | True (T) ou False (F)                                       | True se deve efetuar recompilação                                                                                                                                           |
| includes    | Diretórios com includes separados por `,` ou `;`            | Arquivos de includes, **O caminho para os diretórios de include deve sempre ser absoluto, ex: c:\dir\includes pois será utilizado pelo AppServer no momento da compilação** |

> Informar a opção `program` ou `programList` **mas não ambas**.

#### Exemplo `action = compile`

```ini
[compile]
action=compile
program=/home/mansano/TDScli/src/prog1.prw,/home/mansano/TDScli/src/prog2.prw
recompile=T
includes=/home/mansano/_c/lib120/src/include/
```

#### Retorno `action = compile`

```log
[INFO] Starting recompile.
[LOG] Starting build for environment producao.
[LOG] Start recompile of 2 files.
[LOG] Start regular compiling /home/mansano/TDScli/src/prog1.prw (1/2).
[LOG] [SUCCESS] Source /home/mansano/TDScli/src/prog1.prw compiled successfully.
[LOG] Start regular compiling /home/mansano/TDScli/src/prog2.prw (2/2).
[LOG] [SUCCESS] Source /home/mansano/TDScli/src/prog2.prw compiled successfully.
[LOG] Committing end build.
[LOG] All files compiled successfully.
[INFO] Recompile finished.
```

### `action = patchGen`

Executa a geração de um patch.

> Esta action depende da **action authentication**.</br>
> </br>
> Se for executar uma geração que necessite do uso do **token de compilação** crie a seção com a **action `authorization`** antes desta ação.

| Parâmetro        | Valor                                                       | Descrição                                                                                                      |
| ---------------- | ----------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| saveLocal        | Caminho relativo ou absoluto do arquivo                     | Diretório onde será gerado o patch localmente                                                                  |
| saveRemote       | Caminho relativo                                            | Diretório onde será gerado o patch remotamente (AppServer)                                                     |
| fileResource     | Nomes dos arquivos e/ou diretórios separados por `,` ou `;` | Fontes e Recursos a serem processados                                                                          |
| fileResourceList | Caminho relativo ou absoluto do arquivo                     | Arquivo contendo os nomes dos arquivos (**fontes ou recursos**) a serem processados (**um arquivo por linha**) |
| patchType        | PTM, UPD ou PAK                                             | Extensões permitidas para arquivos de patches                                                                  |
| patchName        | O nome do patch a ser gerado                                | Caso não informado, será gerado com o nome padrão para o tipo escolhido                                        |

> Informar a opção `saveLocal` ou `saveRemote` **mas não ambas**.</br>
> </br>
> Informar a opção `fileResource` ou `fileResourceList` **mas não ambas**.

#### Exemplo `action = patchGen`

```ini
[patchGen]
action=patchGen
fileResource=prog1,prog2
patchType=PTM
saveLocal=/home/mansano/TDScli/patch/
```

#### Retorno `action = patchGen`

```log
[INFO] Starting generate patch.
[LOG] Starting build for environment producao.
[LOG] Patch generated successfully.
[LOG] Patch sent from appserver to user machine.
[LOG] Cleaning up appserver OK.
[LOG] Committing end build.
[INFO] Generate patch finished.
```

### `action = patchValidate`

Efetua apenas a validação de um patch, sem efetuar sua aplicação.

Caso a validação acuse alguma problema, o retorno da execução do batch será diferente de 0 (zero).

> Esta action depende da **action authentication**.

| Parâmetro       | Valor                                   | Descrição                                                                                             |
| --------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| patchFile       | Caminho relativo ou absoluto do arquivo | Arquivo de patch a ser aplicado                                                                       |
| localPatch      | True (T) ou False (F)                   | **True** se o arquivo de patch é local ou **False** se o arquivo estiver em um diretório no AppServer |

#### Exemplo `action = patchValidate`

```ini
[patchValidate]
action=patchValidate
patchFile=/home/mansano/TDScli/patch/tttp120.ptm
localPatch=True
```

#### Retorno `action = patchValidate`

```log
[INFO] Starting patch validate.
[INFO] Patch file: /home/mansano/TDScli/patch/tttp120.ptm
[INFO] Starting build for environment producao.
[INFO] Starting build using RPO token ...
[WARN] Patch validated with problems. There are resources in patch file older than RPO.
[INFO] Aborting end build (rollback changes).
[INFO] Starting reconnection to the server 'tdscli.serverName_rpc'
[INFO] Authenticating...
[INFO] User authenticated successfully.
[INFO] Reconnection to the server 'tdscli.serverName_rpc' finished.
[INFO] Starting validating a package in Protheus application.
[INFO] Package validated in Protheus application without problems.
[INFO] Validating a package in Protheus application finished.
[INFO] Server 'tdscli.serverName_rpc' successfully disconnected.
[INFO] Patch validate finished.
[WARN] Outdated sources and/or resources detected.
[INFO] File     Date Patch      Date RPO
[INFO] APDA020.PRX      06/10/2023 14:08:26     10/11/2023 11:07:03
[INFO] APTA100APIB.PRW  27/09/2023 18:17:34     30/11/2023 16:16:49
...
[INFO] TRMA060_PT-BR.TRES       25/06/2021 02:24:04     01/09/2023 02:29:25

tdscli batch error [5]!!!
```

### `action = patchApply`

Efetua a aplicação de um patch.

> Esta action depende da **action authentication**.

| Parâmetro       | Valor                                   | Descrição                                                                                             |
| --------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| patchFile       | Caminho relativo ou absoluto do arquivo | Arquivo de patch a ser aplicado                                                                       |
| localPatch      | True (T) ou False (F)                   | **True** se o arquivo de patch é local ou **False** se o arquivo estiver em um diretório no AppServer |
| applyOldProgram | True (T) ou False (F)                   | True para aplicação de programas com data de compilação mais antigas que as existentes no RPO         |

#### Exemplo `action = patchApply`

```ini
[patchApply]
action=patchApply
patchFile=/home/mansano/TDScli/patch/tttp120.ptm
localPatch=True
applyOldProgram=True
```

#### Retorno `action = patchApply`

```log
[INFO] Starting apply patch.
[LOG] Starting build for environment producao.
[LOG] Applying patch file: /home/mansano/TDScli/patch/tttp120.ptm
[LOG] Patch (tttp120.ptm) successfully applied.
[LOG] Committing end build.
[INFO] Apply patch finished.
```

### `action = patchInfo`

Obtém as informações de um patch.

> Esta action depende da **action authentication**.

| Parâmetro  | Valor                                   | Descrição                                                                                             |
| ---------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| patchFile  | Caminho relativo ou absoluto do arquivo | Arquivo de patch a ser analisado                                                                      |
| localPatch | True (T) ou False (F)                   | **True** se o arquivo de patch é local ou **False** se o arquivo estiver em um diretório no AppServer |
| output     | Caminho relativo ou absoluto do arquivo | Arquivo com as informações contidas no patch                                                          |

#### Exemplo `action = patchInfo`

```ini
[patchInfo]
action=patchInfo
patchFile=/home/mansano/TDScli/patch/tttp120.ptm
output=/home/mansano/TDScli/patch/tttp120.out
localPatch=True
```

#### Retorno `action = patchInfo`

```log
[INFO] Starting patch info.
[LOG] Patch file: /home/mansano/TDScli/patch/tttp120.ptm
[LOG] Starting build for environment producao.
[LOG] Committing end build.
[INFO] Patch info finished.
```

### `action = deleteProg`

Remove programas do RPO conectado.

> Esta action depende da **action authentication**.</br>
> </br>
> Se for executar uma remoção que necessite do uso do **token de compilação** crie a seção com a **action `authorization`** antes desta.

| Parâmetro   | Valor                                                       | Descrição                                                                                                      |
| ----------- | ----------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| program     | Nomes dos arquivos e/ou diretórios separados por `,` ou `;` | Programas a serem processados                                                                                  |
| programList | Caminho relativo ou absoluto do arquivo                     | Arquivo contendo os nomes dos arquivos (**fontes ou recursos**) a serem processados (**um arquivo por linha**) |

> Informar a opção `program` ou `programList` **mas não ambas**.

#### Exemplo `action = deleteProg`

```ini
[deleteProg]
action=deleteProg
program=prog1.prw
```

#### Retorno `action = deleteProg`

```log
[INFO] Starting program deletion.
[LOG] Starting build for environment producao.
[LOG] All programs successfully deleted from RPO.
[LOG] Committing end build.
[INFO] Program deletion finished.
```

### `action = defragRPO`

Executa a desfragmentação do RPO.

> Esta action depende da **action authentication**.

#### Exemplo `action = defragRPO`

```ini
[defragRPO]
action=defragRPO
```

#### Retorno `action = defragRPO`

```log
[INFO] Starting RPO defragmentation.
[LOG] Starting build for environment producao.
[WARN] This process may take a while.
[LOG] RPO successfully defragged.
[LOG] Committing end build.
[INFO] RPO defragmentation finished.
```

## Ações de execução `deprecated`

Estas ações devem ser substituidas e podem ser removidas a qualquer momento.

### `action = getID` 

> Atenção: As chaves de compilação foram substituidas pelos tokens de compilação a partir dos AppServer Harpia.

Obtém o ID para a chave de compilação.

#### Exemplo `action = getID`

```ini
[getID]
action=getID
```

#### Retorno `action = getID`

```log
ID: ED75-E184
```
