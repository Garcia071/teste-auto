# Teste Automatizado de Códigos em Python, C e C++

## Descrição do Projeto

Este projeto é um conjunto de scripts (Bash e PowerShell) que automatiza a execução e teste de códigos escritos em **Python**, **C** e **C++**. Os scripts identificam dinamicamente a linguagem do código submetido pelo usuário, compilam (quando necessário), executam o código com base em entradas fornecidas e compararam a saída gerada com saídas esperadas.

## Funcionalidades

- Suporta linguagens **Python**, **C** e **C++**.
- Detecta automaticamente a linguagem com base na extensão do arquivo:
  - `.py` para Python.
  - `.c` para C.
  - `.cpp` para C++.
- Para C e C++, o código é compilado utilizando o **gcc** e **g++**.
- Compara a saída gerada com a saída esperada usando ferramentas integradas.
- Gera um relatório de execução com o resultado de cada teste.
- Utiliza um arquivo **JSON** para configurar cores de saída e limite de erros.
- Registra as execuções em um arquivo **CSV** com o resumo dos testes.

## Pré-requisitos

Antes de começar, você precisará ter instalado:
- **Git Bash** (para rodar o script Bash no Windows ou Linux).
- **PowerShell** (para rodar o script PowerShell no Windows).
- **gcc** e **g++** (para compilar e executar código C e C++).
- **Python** (para rodar código Python).
- **jq** (para leitura de arquivos JSON no Bash).

### Instalação do MinGW (para Windows)

1. Baixe e instale o [MinGW](https://sourceforge.net/projects/mingw/).
2. Durante a instalação, marque as opções para **gcc** e **g++**.
3. Certifique-se de adicionar o caminho `C:\MinGW\bin` ao `PATH` do sistema.

### Instalação do jq

Baixe o **jq** para manipular arquivos JSON:
- Acesse: [jq Download](https://stedolan.github.io/jq/download/)
- Baixe a versão correta para Windows e adicione ao `PATH`.

### Instalação do MSYS2 (Alternativa ao MinGW)

Se preferir, você pode instalar o **MSYS2**, que fornece o compilador **gcc** e outras ferramentas:

1. Baixe o instalador do **MSYS2**: [MSYS2 Download](https://www.msys2.org/).
2. Siga as instruções de instalação disponíveis no site.

## Estrutura do Projeto

A estrutura de diretórios do projeto deve ser a seguinte:


Aqui está uma versão do README.md que cobre tanto o script em Bash quanto o em PowerShell. Este documento descreve o funcionamento do projeto, como configurar e executar os testes para códigos em Python, C e C++.

# Teste Automatizado de Códigos em Python, C e C++

## Descrição do Projeto

Este projeto é um conjunto de scripts (Bash e PowerShell) que automatiza a execução e teste de códigos escritos em **Python**, **C** e **C++**. Os scripts identificam dinamicamente a linguagem do código submetido pelo usuário, compilam (quando necessário), executam o código com base em entradas fornecidas e compararam a saída gerada com saídas esperadas.

## Funcionalidades

- Suporta linguagens **Python**, **C** e **C++**.
- Detecta automaticamente a linguagem com base na extensão do arquivo:
  - `.py` para Python.
  - `.c` para C.
  - `.cpp` para C++.
- Para C e C++, o código é compilado utilizando o **gcc** e **g++**.
- Compara a saída gerada com a saída esperada usando ferramentas integradas.
- Gera um relatório de execução com o resultado de cada teste.
- Utiliza um arquivo **JSON** para configurar cores de saída e limite de erros.
- Registra as execuções em um arquivo **CSV** com o resumo dos testes.

## Pré-requisitos

Antes de começar, você precisará ter instalado:
- **Git Bash** (para rodar o script Bash no Windows ou Linux).
- **PowerShell** (para rodar o script PowerShell no Windows).
- **gcc** e **g++** (para compilar e executar código C e C++).
- **Python** (para rodar código Python).
- **jq** (para leitura de arquivos JSON no Bash).

### Instalação do MinGW (para Windows)

1. Baixe e instale o [MinGW](https://sourceforge.net/projects/mingw/).
2. Durante a instalação, marque as opções para **gcc** e **g++**.
3. Certifique-se de adicionar o caminho `C:\MinGW\bin` ao `PATH` do sistema.

### Instalação do jq

Baixe o **jq** para manipular arquivos JSON:
- Acesse: [jq Download](https://stedolan.github.io/jq/download/)
- Baixe a versão correta para Windows e adicione ao `PATH`.

### Instalação do MSYS2 (Alternativa ao MinGW)

Se preferir, você pode instalar o **MSYS2**, que fornece o compilador **gcc** e outras ferramentas:

1. Baixe o instalador do **MSYS2**: [MSYS2 Download](https://www.msys2.org/).
2. Siga as instruções de instalação disponíveis no site.

## Estrutura do Projeto

A estrutura de diretórios do projeto deve ser a seguinte:

- /meu_projeto/
  - **test.sh**: Script Bash
  - **test.ps1**: Script PowerShell
  - **config.json**: Configurações em JSON
  - **test_log.csv**: Histórico de execuções
  - **main.py**: Exemplo de código em Python
  - **main.c**: Exemplo de código em C
  - **main.cpp**: Exemplo de código em C++
  - /testes/: Diretório com entradas e saídas de teste
    - **1.in**: Arquivo de entrada
    - **1.out**: Arquivo de saída esperada
    - **2.in**: Outro arquivo de entrada
    - **2.out**: Outro arquivo de saída esperada
      

## Executando o Projeto

### Executando o Script Bash

1. No Git Bash, vá até o diretório onde está o script:

   ```bash
   cd /caminho/para/meu_projeto/
    
    
    
2. Execute o script com os parâmetros necessários:

    bash
    Copiar código
    ./test.sh --input ./main.py --tests ./testes/
  
  Ou para C:

    ./test.sh --input ./main.c --tests ./testes/

### Executando o Script PowerShell

Abra o PowerShell e navegue até o diretório onde o script está salvo:

cd C:\caminho\para\meu_projeto

Execute o script passando os parâmetros:
.\test.ps1 -inputFile .\main.py -testsDir .\testes

Ou para C:

.\test.ps1 -inputFile .\main.c -testsDir .\testes

## Saída Esperada
Após a execução, o script exibirá o status de cada teste:

Arquivo de entrada: ./main.py
Diretório de testes: ./testes/
Linguagem detectada: python
Teste 1.in: Sucesso
Teste 2.in: Falha


