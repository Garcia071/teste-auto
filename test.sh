#!/bin/bash

# Arquivo de log CSV
log_file="test_log.csv"

# Arquivo de configuração JSON
config_file="config.json"

# Verificar se o arquivo de configuração existe
if [ ! -f "$config_file" ]; then
    echo "Arquivo de configuração $config_file não encontrado!"
    exit 1
fi

# Carregar configurações do JSON
error_limit=$(jq '.error_limit' "$config_file")
success_color=$(jq -r '.colors.success' "$config_file")
failure_color=$(jq -r '.colors.failure' "$config_file")
error_color=$(jq -r '.colors.error' "$config_file")

# Função para colorir texto
color_text() {
    local color=$1
    local text=$2
    case $color in
        "green") echo -e "\033[0;32m$text\033[0m" ;;
        "red") echo -e "\033[0;31m$text\033[0m" ;;
        "yellow") echo -e "\033[0;33m$text\033[0m" ;;
        *) echo "$text" ;;
    esac
}

# Parsing das flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -i|--input) input_file="$2"; shift ;;
        -t|--tests) tests_dir="$2"; shift ;;
        *) echo "Opção desconhecida: $1"; exit 1 ;;
    esac
    shift
done

# Identificar a extensão do arquivo
ext="${input_file##*.}"

# Definir a linguagem com base na extensão do arquivo
case "$ext" in
    py) language="python" ;;
    c) language="c" ;;
    cpp) language="cpp" ;;
    *) echo "Linguagem não suportada"; exit 1 ;;
esac

echo "Arquivo de entrada: $input_file"
echo "Diretório de testes: $tests_dir"
echo "Linguagem detectada: $language"

# Verificar se o arquivo de log já existe, se não, criar o cabeçalho
if [ ! -f "$log_file" ]; then
    echo "Data,Arquivo,Total_Testes,Sucessos,Falhas,Erros" >> "$log_file"
fi

# Função para rodar os testes
run_tests() {
    local total_tests=0
    local success=0
    local failure=0
    local error_count=0
    
    # Verificar se o diretório de testes existe
    if [ ! -d "$tests_dir" ]; then
        echo "Diretório de testes não encontrado: $tests_dir"
        exit 1
    fi

    for input in "$tests_dir"/*.in; do
        total_tests=$((total_tests + 1))
        expected_output="${input%.in}.out"
        actual_output="${input%.in}.actual"

        # Verificar se o arquivo de saída esperado existe
        if [ ! -f "$expected_output" ]; then
            echo "$(color_text "$error_color" "Arquivo de saída esperada não encontrado: $expected_output")"
            continue
        fi

        # Executar o código baseado na linguagem
        if [ "$language" == "python" ]; then
            python "$input_file" < "$input" > "$actual_output"
        elif [ "$language" == "c" ]; then
            gcc "$input_file" -o "${input_file%.c}.out"
            ./"${input_file%.c}.out" < "$input" > "$actual_output"
        elif [ "$language" == "cpp" ]; then
            g++ "$input_file" -o "${input_file%.cpp}.out"
            ./"${input_file%.cpp}.out" < "$input" > "$actual_output"
        fi

        # Comparação de saídas, ignorando espaços em branco e linhas extras
        if diff -wB "$expected_output" "$actual_output" > /dev/null; then
            echo "$(color_text "$success_color" "Teste $(basename "$input"): Sucesso")"
            success=$((success + 1))
        else
            echo "$(color_text "$failure_color" "Teste $(basename "$input"): Falha")"
            diff "$expected_output" "$actual_output"
            failure=$((failure + 1))
        fi

        # Verificar limite de erros
        if [ "$failure" -ge "$error_limit" ]; then
            echo "$(color_text "$error_color" "Número máximo de erros atingido ($error_limit). Testes interrompidos.")"
            break
        fi
    done

    # Registrar execução no CSV
    echo "$(date),$input_file,$total_tests,$success,$failure,$error_count" >> "$log_file"
}

# Chamada para rodar os testes
run_tests
