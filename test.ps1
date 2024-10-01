# Parsing de parâmetros
param (
    [string]$inputFile,
    [string]$testsDir
)

# Função para identificar a linguagem do arquivo baseado na extensão
function Detect-Language {
    param (
        [string]$file
    )
    $ext = [System.IO.Path]::GetExtension($file)
    switch ($ext) {
        ".py" { return "python" }
        ".c" { return "c" }
        ".cpp" { return "cpp" }
        default { throw "Linguagem não suportada!" }
    }
}

# Função para executar os testes
function Run-Tests {
    param (
        [string]$inputFile,
        [string]$testsDir,
        [string]$language
    )

    $success = 0
    $failure = 0
    $totalTests = 0
    $errorLimit = 3  # Limite de falhas antes de parar os testes

    # Verificar se a pasta de testes existe
    if (-Not (Test-Path -Path $testsDir)) {
        Write-Host "Diretório de testes não encontrado: $testsDir" -ForegroundColor Red
        exit 1
    }

    # Rodar testes em todos os arquivos .in
    Get-ChildItem -Path "$testsDir" -Filter *.in | ForEach-Object {
        $totalTests++
        $inputFileTest = $_.FullName
        $expectedOutput = "$($inputFileTest -replace '.in$', '.out')"
        $actualOutput = "$($inputFileTest -replace '.in$', '.actual')"

        # Verificar se o arquivo de saída esperado existe
        if (-Not (Test-Path -Path $expectedOutput)) {
            Write-Host "Arquivo de saída esperada não encontrado: $expectedOutput" -ForegroundColor Yellow
            return
        }

        # Ler o conteúdo do arquivo de entrada
        $inputContent = Get-Content $inputFileTest -Raw

        # Executar o código dependendo da linguagem detectada
        switch ($language) {
            "python" {
                # Passar o conteúdo do arquivo de entrada para o código Python
                $process = Start-Process -FilePath "python" -ArgumentList $inputFile -NoNewWindow -PassThru -RedirectStandardInput $inputFileTest -RedirectStandardOutput $actualOutput
                $process.WaitForExit()
            }
            "c" {
                # Compilar o código C
                $exeFile = "${inputFile -replace '.c$', '.exe'}"
                gcc $inputFile -o $exeFile
                if (Test-Path $exeFile) {
                    # Executar o código compilado
                    $process = Start-Process -FilePath $exeFile -NoNewWindow -PassThru -RedirectStandardInput $inputFileTest -RedirectStandardOutput $actualOutput
                    $process.WaitForExit()
                } else {
                    Write-Host "Erro: Falha na compilação do código C" -ForegroundColor Red
                }
            }
            "cpp" {
                # Compilar o código C++
                $exeFile = "${inputFile -replace '.cpp$', '.exe'}"
                g++ $inputFile -o $exeFile
                if (Test-Path $exeFile) {
                    # Executar o código compilado
                    $process = Start-Process -FilePath $exeFile -NoNewWindow -PassThru -RedirectStandardInput $inputFileTest -RedirectStandardOutput $actualOutput
                    $process.WaitForExit()
                } else {
                    Write-Host "Erro: Falha na compilação do código C++" -ForegroundColor Red
                }
            }
        }

        # Comparação de saídas usando Compare-Object
        $expectedContent = Get-Content $expectedOutput
        $actualContent = Get-Content $actualOutput

        if ((Compare-Object $expectedContent $actualContent -SyncWindow 0).Length -eq 0) {
            Write-Host "Teste $($_.Name): Sucesso" -ForegroundColor Green
            $success++
        } else {
            Write-Host "Teste $($_.Name): Falha" -ForegroundColor Red
            $failure++
        }

        # Limite de falhas
        if ($failure -ge $errorLimit) {
            Write-Host "Número máximo de falhas atingido ($errorLimit). Interrompendo os testes." -ForegroundColor Yellow
            return
        }
    }

    # Exibir resumo dos testes
    Write-Host "`nResumo dos testes:"
    Write-Host "Total de Testes: $totalTests"
    Write-Host "Sucessos: $success"
    Write-Host "Falhas: $failure"
}

# Identificar a linguagem
try {
    $language = Detect-Language -file $inputFile
    Write-Host "Arquivo de entrada: $inputFile"
    Write-Host "Diretório de testes: $testsDir"
    Write-Host "Linguagem detectada: $language"
}
catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Rodar os testes
Run-Tests -inputFile $inputFile -testsDir $testsDir -language $language
