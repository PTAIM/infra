#!/bin/bash

# --- Configuração ---
# IMPORTANTE: Substitua as URLs de placeholder abaixo
# pelas URLs SSH ou HTTPS reais dos seus repositórios Git.

REPO_AI="https://github.com/PTAIM/medical-service.git"
REPO_BACKEND="https://github.com/PTAIM/backend.git"
REPO_EMAIL="https://github.com/PTAIM/middle-end.git"
REPO_FRONTEND="https://github.com/PTAIM/frontend.git"

# OPCIONAL: Especifique os branches que deseja clonar.
# Deixe em branco ("") para usar o branch padrão do repositório.
BRANCH_AI="main"
BRANCH_BACKEND="fix/rotas"
BRANCH_EMAIL="main"
BRANCH_FRONTEND="fix/integracao-backend"

# Define os diretórios de destino
DIR_AI="ai/app"
DIR_BACKEND="backend/app"
DIR_EMAIL="email/app"
DIR_FRONTEND="frontend/app"

# Array para armazenar repositórios que falharam
FALHAS=()

# --- Função Auxiliar para Clonar ---
# $1: URL do Repositório
# $2: Diretório de Destino
# $3: Nome do Branch (opcional)
clonar_repo() {
  local repo_url=$1
  local dest_dir=$2
  local branch_name=$3
  local repo_name=$(basename "$dest_dir") # Pega o nome 'app'

  echo "----------------------------------------"
  echo "Processando: $repo_name em $dest_dir"
  if [ -n "$branch_name" ]; then
    echo "Branch:      $branch_name"
  else
    echo "Branch:      (Padrão do repositório)"
  fi
  echo "----------------------------------------"

  # Verifica se a URL do placeholder foi alterada
  if [[ "$repo_url" == *"URL_DO_SEU_REPO_"* ]]; then
    echo "ERRO: Por favor, edite o script e defina a URL para $repo_name."
    FALHAS+=("$repo_name (URL não definida)")
    echo ""
    return
  fi

  # Verifica se o diretório de destino já existe e não está vazio
  if [ -d "$dest_dir" ] && [ "$(ls -A "$dest_dir")" ]; then
    echo "AVISO: O diretório '$dest_dir' já existe e não está vazio. Pulando..."
  else
    # Cria os diretórios pais (ex: "ai/", "backend/") se não existirem
    mkdir -p "$dest_dir"

    # Constrói o comando git clone
    local clone_cmd="git clone"
    if [ -n "$branch_name" ]; then
      # Adiciona a flag -b se um branch foi especificado
      clone_cmd+=" -b $branch_name"
    fi
    # Adiciona a URL e o destino ao comando
    clone_cmd+=" $repo_url $dest_dir"

    # Executa o git clone
    echo "Executando: $clone_cmd"
    if $clone_cmd; then
      echo "SUCESSO: Repositório $repo_name clonado em $dest_dir"
    else
      echo "ERRO: Falha ao clonar $repo_url"
      FALHAS+=("$repo_name ($repo_url)")
      # Remove o diretório se o clone falhou e o diretório ficou vazio
      rmdir "$dest_dir" 2>/dev/null
    fi
  fi
  echo "" # Adiciona uma linha em branco para melhor legibilidade
}

# --- Execução Principal ---
echo "Iniciando o script de clonagem de repositórios..."
echo ""

clonar_repo "$REPO_AI" "$DIR_AI" "$BRANCH_AI"
clonar_repo "$REPO_BACKEND" "$DIR_BACKEND" "$BRANCH_BACKEND"
clonar_repo "$REPO_EMAIL" "$DIR_EMAIL" "$BRANCH_EMAIL"
clonar_repo "$REPO_FRONTEND" "$DIR_FRONTEND" "$BRANCH_FRONTEND"

# --- Resumo Final ---
echo "----------------------------------------"
echo "Processo de clonagem concluído."
echo "----------------------------------------"

if [ ${#FALHAS[@]} -eq 0 ]; then
  echo "Tudo certo! Todos os repositórios foram clonados com sucesso (ou já existiam)."
else
  echo "Atenção! Os seguintes repositórios falharam ao clonar:"
  for falha in "${FALHAS[@]}"; do
    echo "  - $falha"
  done
fi