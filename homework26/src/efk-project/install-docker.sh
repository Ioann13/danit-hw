#!/bin/bash
set -e

echo "w Обновляем индекс пакетов..."
sudo apt update

echo " Устанавливаем зависимости..."
sudo apt install -y ca-certificates curl gnupg lsb-release

echo " Добавляем официальный GPG-ключ Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo " Добавляем Docker-репозиторий..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo " Обновляем индекс с новым репозиторием..."
sudo apt update

echo " Устанавливаем Docker Engine..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo " Запускаем и включаем автозапуск Docker..."
sudo systemctl start docker
sudo systemctl enable docker

echo " Добавляем текущего пользователя в группу docker..."
sudo usermod -aG docker ioann

echo " Устанавливаем последнюю версию Docker Compose..."
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | \
  grep tag_name | cut -d '"' -f 4)

sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

echo " Установка завершена!"
echo " Версия Docker: $(docker --version)"
echo " Версия Docker Compose: $(docker-compose --version)"
echo " Выйди из системы и войди снова, чтобы использовать docker без sudo."