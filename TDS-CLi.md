# TDSCLi (LS)

O TDS**CLi**-LS (**C**ommand **Li**ne) é uma ferramenta do ecossistema **TOTVS Protheus** que permite ações como a compilação e aplicação de patchs via linha de comando. 

Ele utiliza o **AdvPLS**, que está disponível no diretório do plugin do **TDS-VSCode** para os três sistemas operacionais homologados, conforme exemplo abaixo.

![Advpl-dir](https://github.com/totvs/tds-ls/blob/master/images/advpls_dirs.png)

> Mais informações sobre o plugin [clique aqui](https://marketplace.visualstudio.com/items?itemName=totvs.tds-vscode).

## Utilizando o AdvPLS

Para utilização da ferramenta é necessária a criação de um **arquivo de execução**, explicado a seguir, chamado através do parâmetro `--tdsCli`.

> `> advpls --tdsCli=<params_file>`

o AdvPLS permite executar múltiplas ações em uma única chamada, por exemplo:

* Conexão ao AppServer (action=**authentication**);
* Compilação de um conjunto de fontes (**compile**);
* Defrag do RPO (**defragRPO**)

## Modo de compatibilidade

O TDSCli-LS possui um modo de compatibilidade com o TDSCli-Eclipse, para mais informações [clique aqui](#compatibilidade_legado).

## Arquivo de execução

Recomendamos o uso de um arquivo de execução com a extensão **.INI**, pois editores como o próprio VSCode farão seu *syntax highlight*, facilitando o desenvolvimento.

### Características do arquivo de execução

* As tags "`#`" ou "`;`" representam os comentários do arquivo de execução; 
* Use a tag `[]` para subdividir as seções a serem executadas, exemplo: 
```ini
        ;Exemplo
        [Conectando]
        action = authentication
        ...
        [Compacta RPO]
        action = defragRPO
```
   * **Importante**: Duas seções **não devem ser declaradas** no arquivo de execução como subdivisão customizada:
        * `[geral] -> apenas para uso interno`
        * `[user] -> onde definimos as variáveis de ambiente`

## Usando caminhos relativos ou absolutos

Quando for necessário "apontar" para um arquivo, como um patch por exemplo, você poderá fazer uso de caminhos absolutos:

> **Windows:** `C:\dir\file.ptm` **ou Linux:** `/home/user/dir/file.ptm`

Ou poderá utilizar caminhos relativos ao diretório do seu arquivo de execução:

> **Windows:** `dir\file.ptm` **ou Linux:** `dir/file.ptm`

Prefira usar **caminhos absolutos**, garantindo a correta localização dos arquivos.

Você pode utilizar barra **`/`** como separador de diretórios independentemente do seu sistema operacional.

> A execução do TDSCli-LS no **Linux** deve respeitar as regras do *AppServer Protheus* para este sistema operacional, que são:
* Utilize apenas **caracteres minúsculos** na composição do diretorio/arquivo.ext;
* **Não utilize acentuação** na composição diretorio/arquivo.ext.

## Exemplo

Agora que conhecemos o arquivo de execução vamos ver um exemplo:

```ini
; logToFile: diretorio/arquivo para arquivar log da execução
; showConsoleOutput: True exibe informações no console
logToFile=/home/mansano/tdscli/logs/log1.log
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
psw=

; Compilando dois fontes
[compile]
action=compile 
program=/home/mansano/tdscli/src/prog1.prw,/home/mansano/tdscli/src/prog2.prw
recompile=T
includes=${INCLUDE_DIR}
```

### Retorno

```
[LOG] Starting connection to the server 'tdscli.serverName' (192.168.0.198@5025)
[LOG] Connection to the server 'tdscli.serverName' finished.
[LOG] Starting user 'admin' authentication.
[LOG] Authenticating...
[LOG] User authenticated successfully.
[LOG] User 'admin' authentication finished.
[INFO] Starting recompile.
[LOG] Starting build for environment producao.
[LOG] Start recompile of 2 files.
[LOG] Start regular compiling /home/mansano/tdscli/src/prog1.prw (1/2).
[LOG] [SUCCESS] Source /home/mansano/tdscli/src/prog1.prw compiled successfully.
[LOG] Start regular compiling /home/mansano/tdscli/src/prog2.prw (2/2).
[LOG] [SUCCESS] Source /home/mansano/tdscli/src/prog2.prw compiled successfully.
[LOG] Committing end build.
[LOG] All files compiled successfully.
[INFO] Recompile finished.
```

## Parâmetros gerais

Os parâmetros gerais devem sempre ser inseridos no **início do arquivo** de execução.

| Parâmetro         | Valor                                   | Descrição                                                                     |
|-------------------|-----------------------------------------|-------------------------------------------------------------------------------|
| logToFile         | diretorio/arquivo.log | Arquivo que receberá as informações da execução do arquivo     |
| showConsoleOutput | True (T) ou False (F)                   | True = Exibe informações no console |

### Exemplo
```ini
; logToFile: diretorio/arquivo para arquivar log da execução
; showConsoleOutput: True exibe informações no console
logToFile=/home/mansano/tdscli/logs/log1.log
showConsoleOutput=true
```

## Seção `[user]`

Na seção `[user]` definimos as variáveis de ambiente, que podem ser usadas em todas as seções do arquivo de execução.

> Para utilização da variável de ambiente use a macro `${var_name}`

### Exemplo

```ini
[user]
INCLUDE_DIR=/home/mansano/_c/lib120/src/include/
...
[compile]
action=compile 
includes=${INCLUDE_DIR}
```

## Seções de usuário

As seções permitem **organizar** seu arquivo de execução, para seu nome é permitido uso de espaços e caracteres especiais. 

### Exemplo

```ini
[compilação de arquivos]
action=compile 
```
A execução do **arquivo é sequencial**, percorrendo todas as seções cadastradas.

> O parâmetro **`skip=True`** utilizado em uma seção permite ignorar sua execução, isso pode ser util caso necessite reaproveitar o mesmo arquivo de execução para várias finalidades.

> Cada seção contém uma **`action`**, explicadas a seguir.

## `action = validate`

Obtém a versão de *release* do AppServer, permitindo seu uso na tag **build** da **action authentication**.

| Parâmetro | Valor    | Descrição                       |
|-----------|----------|---------------------------------|
| server    | IP       | Endereço IP do AppServer        |
| port      | numérico | Porta do AppServer              |
| secure    | 1 ou 0   | Se a conexão é segura ou não, 1=Conexão segura, 0=Conexão convencional    |

### Exemplo

```ini
[validate]
action=validate
server=192.168.0.198
port=5025
secure=0
```

### Retorno

```
[LOG] Appserver detected with build version: 7.00.170117A and secure: 0
build: 7.00.170117A / secure: 0
```

## `action = getID`

Obtém o ID para a chave de compilação.

### Exemplo

```ini
[getID]
action=getID
```

### Retorno

```
ID: ED75-E184
```

## `action = authorization`

Aplica a chave de compilação.

> O **ID** do TDSCli-LS é diferente do TDSCLi-Eclipse, tornando as **chaves de compilação** incompatíveis entre as IDE's.

| Parâmetro     | Valor                                   | Descrição                                  |
|---------------|-----------------------------------------|--------------------------------------------|
| authorization | Caminho relativo ou absoluto do arquivo | Define o arquivo com a chave de compilação | 

```ini
[authorization]
action=authorization 
authorization=/home/mansano/tdscli/ED75-E184.aut
```

> Em caso de erro na carga do arquivo, confirme o ID da estação utilizando a action **getID**.

## `action = authentication`

Executa a conexão com o AppServer.

| Parâmetro   | Valor             | Descrição                                     |
|-------------|-------------------|-----------------------------------------------|
| server      | IP                | Endereço do AppServer                         |
| port        | numérico          | Porta em que o AppServer escuta               |
| secure      | 1 ou 0            | Se a conexão é segura ou não, 1=Conexão segura, 0=Conexão convencional                  |
| build       | *build* ou *AUTO* | Release do AppServer ou AUTO para detecção automática         |
| user        | "nome de usuário" | Usuário para autenticação                     |
| psw         | "senha"           | Senha para autenticação                       |
| environment | "ambiente"        | Ambiente na qual será efetuada a autenticação |

### Exemplo

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

### Retorno

```
[LOG] Appserver detected with build version: 7.00.170117A and secure: 0
[LOG] Starting connection to the server 'tdscli.serverName' (192.168.0.198@5025)
[LOG] Connection to the server 'tdscli.serverName' finished.
[LOG] Starting user 'admin' authentication.
[LOG] Authenticating...
[LOG] User authenticated successfully.
[LOG] User 'admin' authentication finished.
```

## `action = compile`

Executa a compilação/recompilação de programas no RPO.

> Esta action depende da **action authentication**.

> Se for executar uma compilação que necessite do uso da **chave de compilação** crie a seção com a **action `authorization`** antes desta.

| Parâmetro   | Valor                                                       | Descrição                                                                         |
|-------------|-------------------------------------------------------------|-----------------------------------------------------------------------------------|
| program     | Nomes dos arquivos e/ou diretórios separados por `,` ou `;` | Programas a serem processados                                                     |
| programList | Caminho relativo ou absoluto do arquivo                     | Arquivo contendo os nomes dos arquivos (**fontes ou recursos**) a serem processados (**um arquivo por linha**) |
| recompile   | True (T) ou False (F)                                       | True se deve efetuar recompilação                                              |
| includes    | Diretórios com includes separados por `,` ou `;`            | Arquivos de includes                                                              |

> Informar a opção `program` ou `programList` **mas não ambas**.

### Exemplo

```ini
[compile]
action=compile 
program=/home/mansano/tdscli/src/prog1.prw,/home/mansano/tdscli/src/prog2.prw
recompile=T
includes=${INCLUDE_DIR}
```

### Retorno

```
[INFO] Starting recompile.
[LOG] Starting build for environment producao.
[LOG] Start recompile of 2 files.
[LOG] Start regular compiling /home/mansano/tdscli/src/prog1.prw (1/2).
[LOG] [SUCCESS] Source /home/mansano/tdscli/src/prog1.prw compiled successfully.
[LOG] Start regular compiling /home/mansano/tdscli/src/prog2.prw (2/2).
[LOG] [SUCCESS] Source /home/mansano/tdscli/src/prog2.prw compiled successfully.
[LOG] Committing end build.
[LOG] All files compiled successfully.
[INFO] Recompile finished.
```

## `action = patchGen`

Executa a geração de patch.

> Esta action depende da **action authentication**.

| Parâmetro        | Valor                                                       | Descrição                                                                         |
|------------------|-------------------------------------------------------------|-----------------------------------------------------------------------------------|
| saveLocal        | Caminho relativo ou absoluto do arquivo                     | Diretório onde será gerado o patch localmente                                     |
| saveRemote       | Caminho relativo                                            | Diretório onde será gerado o patch remotamente (AppServer)                        |
| fileResource     | Nomes dos arquivos e/ou diretórios separados por `,` ou `;` | Fontes e Recursos a serem processados                                                      |
| fileResourceList | Caminho relativo ou absoluto do arquivo                     | Arquivo contendo os nomes dos arquivos (**fontes ou recursos**) a serem processados (**um arquivo por linha**) |
| patchType        | PTM, UPD ou PAK                                             | Extensões permitidas para arquivos de  patches                                                  | 

> Informar a opção `saveLocal` ou `saveRemote` **mas não ambas**.

> Informar a opção `fileResource` ou `fileResourceList` **mas não ambas**.


### Exemplo

```ini
[patchGen]
action=patchGen
fileResource=prog1,prog2
patchType=PTM
saveLocal=/home/mansano/tdscli/patch/
```

### Retorno

```
[INFO] Starting generate patch.
[LOG] Starting build for environment producao.
[LOG] Patch generated successfully.
[LOG] Patch sent from appserver to user machine.
[LOG] Cleaning up appserver OK.
[LOG] Committing end build.
[INFO] Generate patch finished.
```

## `action = patchApply`

Efetua a aplicação de patch.

> Esta action depende da **action authentication**.

| Parâmetro       | Valor                                   | Descrição                                                                                   |
|-----------------|-----------------------------------------|---------------------------------------------------------------------------------------------|
| patchFile       | Caminho relativo ou absoluto do arquivo | Arquivo de patch a ser aplicado                                                             |
| localPatch      | True (T) ou False (F)                   | **True** se o arquivo de patch é local ou **False** se o arquivo estiver em um diretório no AppServer                                   |
| validatePatch   | True (T) ou False (F)                   | True para validação do patch                                                        |
| applyOldProgram | True (T) ou False (F)                   | True para aplicação de programas com data de compilação mais antigas que as existentes no RPO | 

### Exemplo

```ini
[patchApply]
action=patchApply
patchFile=/home/mansano/tdscli/patch/tttp120.ptm
localPatch=True
applyOldProgram=True
```

### Retorno

```
[INFO] Starting apply patch.
[LOG] Starting build for environment producao.
[LOG] Applying patch file: /home/mansano/tdscli/patch/tttp120.ptm
[LOG] Patch (tttp120.ptm) successfully applied.
[LOG] Committing end build.
[INFO] Apply patch finished.
```

## `action = [patchInfo]`

Obtém as informações de um patch.

> Esta action depende da **action authentication**.

| Parâmetro  | Valor                                   | Descrição                                                 |
|------------|-----------------------------------------|-----------------------------------------------------------|
| patchFile  | Caminho relativo ou absoluto do arquivo | Arquivo de patch a ser analisado                          |
| localPatch | True (T) ou False (F)                   | **True** se o arquivo de patch é local ou **False** se o arquivo estiver em um diretório no AppServer |
| output     | Caminho relativo ou absoluto do arquivo | Arquivo com as informações contidas no patch              |

### Exemplo

```ini
[patchInfo]
action=patchInfo
patchFile=/home/mansano/tdscli/patch/tttp120.ptm
output=/home/mansano/tdscli/patch/tttp120.out
localPatch=True
```

### Retorno

```
[INFO] Starting patch info.
[LOG] Patch file: /home/mansano/tdscli/patch/tttp120.ptm
[LOG] Starting build for environment producao.
[LOG] Committing end build.
[INFO] Patch info finished.
```

## `action = deleteProg`

Remove programas do RPO conectado.

> Esta action depende da **action authentication**.

> Se for executar uma remoção que necessite do uso da **chave de compilação** crie a seção com a **action `authorization`** antes desta.

| Parâmetro   | Valor                                                       | Descrição                                                                          |
|-------------|-------------------------------------------------------------|------------------------------------------------------------------------------------|
| program     | Nomes dos arquivos e/ou diretórios separados por `,` ou `;` | Programas a serem processados                                                      |
| programList | Caminho relativo ou absoluto do arquivo                     | Arquivo contendo os nomes dos arquivos (**fontes ou recursos**) a serem processados (**um arquivo por linha**) |

> Informar a opção `program` ou `programList` **mas não ambas**.

### Exemplo

```ini
[deleteProg]
action=deleteProg
program=prog1.prw
```

### Retorno

```
[INFO] Starting program deletion.
[LOG] Starting build for environment producao.
[LOG] All programs successfully deleted from RPO.
[LOG] Committing end build.
[INFO] Program deletion finished.
```

## `action = defragRPO`

Executa a desfragmentação do RPO.

> Esta action depende da **action authentication**.

### Exemplo

```ini
[defragRPO]
action=defragRPO
```

### Retorno

```
[INFO] Starting RPO defragmentation.
[LOG] Starting build for environment producao.
[WARN] This process may take a while.
[LOG] RPO successfully defragged.
[LOG] Committing end build.
[INFO] RPO defragmentation finished.
```

## <a name="compatibilidade_legado"></a>Compatibilidade (legado)

Para utilizar o modo de compatibilidade com **TDSCLi-Eclipse** usaremos arquivos de script (batch/bash), específicos para cada sistema operacional, e apenas uma **action pode ser chamada por execução**:

> Windows: `> tdscli.bat <action> <parâmetros_da_ação>`

> Linux: `> ./tdscli.sh <action> <parâmetros_da_ação>`

> Mac OS: `> ./tdscli.sh <action> <parâmetros_da_ação>`

### Usando parâmetros em linha de comando 

`> tdscli.bat <action> <parametro_da_acao_1> <parametro_da_acao_2> <parametro_da_acao_3>...`

### Usando parâmetros em arquivo

`> tdscli.bat <action> @parametros_da_acao.txt`

> Os parâmetros obrigatórios **dependem da action**, porém em todas as actions os parâmetros de conexão da **action authentication** devem ser informados.

### Exemplo usando **parâmetros em linha de comando**  

`> tdscli.bat compile serverType=AdvPL server=localhost port=1234 build=7.00.170117A environment=env user=user psw=pass includes=D:/servers/protheus/includes program=D:/fontes/advpl/prg_0001.prw;D:/fontes/advpl/prg_0002.prw;D:/fontes/advpl/prg_0003.prw authorization=D:/chave_compilacao/chave.aut recompile=t`

### Exemplo usando **parâmetros em arquivo**

`> tdscli.bat compile @compile.txt`

```ini
;compile.txt
;Exemplo de arquivo de execução para o TDSCLi (legado)

;parametros da acao authentication
serverType=AdvPL
server=localhost
port=1234
build=7.00.170117A
user=user
psw=pass
environment=env

;parametros da acao compile
includes=D:/servers/protheus/includes
program=D:/fontes/advpl/prg_0001.prw;D:/fontes/advpl/prg_0002.prw;D:/fontes/advpl/prg_0003.prw
authorization=D:/chave_compilacao/chave.aut
recompile=t
```
