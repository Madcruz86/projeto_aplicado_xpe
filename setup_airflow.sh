#!/bin/bash

set -e

echo "Atualizando lista de pacotes..."
sudo apt-get update

echo "Instalando pacotes para repositório HTTPS..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo "Criando diretório para chaves de repositórios..."
sudo mkdir -m 0755 -p /etc/apt/keyrings

echo "Adicionando chave GPG do Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "Adicionando repositório do Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Atualizando lista de pacotes novamente..."
sudo apt-get update

echo "Instalando Docker e componentes..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Entrar na pasta do script (projeto_clima)
cd "$(dirname "$0")"

# Criar pasta airflow se não existir
mkdir -p airflow

cd airflow

echo "Baixando docker-compose.yaml do Airflow dentro da pasta airflow..."
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml'

echo "Criando diretórios dags, logs e plugins dentro da pasta airflow..."
mkdir -p dags logs plugins

echo "Criando arquivo .env com UID do usuário dentro da pasta airflow..."
echo -e "AIRFLOW_UID=$(id -u)" > .env

echo "Inicializando Airflow (airflow-init)..."
sudo docker compose up airflow-init

echo "Subindo Airflow em modo desacoplado..."
sudo docker compose up -d

echo "Setup do Airflow na pasta 'airflow' concluído."
echo "Acesse o Airflow via http://seu-ip-ou-dns:8080"

echo "Para editar docker-compose.yaml e modificar AIRFLOW__CORE__LOAD_EXAMPLES para 'false', faça:"
echo "  nano docker-compose.yaml"
echo "Depois reinicie:"
echo "  sudo docker compose stop"
echo "  sudo docker compose up -d"
echo "  sudo docker ps"

echo "Script finalizado."

