# DOCKER ON UBUNTU STEP BY STEP..
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu noble stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin

sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
#DOCKER NOW INSTALLED

sudo usermod -aG docker $<usertogivedockerpriviledges>

docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
 --env-file .env.staging
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
docker compose down
docker compose restart
docker ps -a
docker stats
docker logs <containername>
docker compose logs -f <service_name>

# If all running properly
docker compose run --rm --user root web chown -R 33:33 /lenicle/static
# to make nginx that is not in  container but in host to access the static files

docker images
docker image prune

docker volume
docker volume ls
docker volume inspect <volume_name>
docker volume prune


docker system prune -f