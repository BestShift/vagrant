sudo apt-get -y update
sudo apt-get -y install git bash

cat > ~/.setup/data.sh <<EOF
scheme="http"
hostname="localhost:8000"
EOF

cd ~/.setup/
bash setup-server.sh
