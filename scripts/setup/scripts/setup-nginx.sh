#!/bin/bash

cat > /tmp/bestshift.conf <<EOF
server {
    listen 80 default_server;
    listen 8000 default_server;
    server_name _;

    large_client_header_buffers 4 32k;

    client_max_body_size 50M;
    charset utf-8;

    access_log /home/$USER/logs/nginx.access.log;
    error_log /home/$USER/logs/nginx.error.log;

    location / {
        root /home/$USER/bestshift-front/dist/;
        try_files \$uri \$uri/ /index.html;
    }

    location /api {
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Scheme \$scheme;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:8001/api;
        proxy_redirect off;
    }

    location /static {
        alias /home/$USER/bestshift/static;
    }

    location /media {
        alias /home/$USER/bestshift/media;
    }
}
EOF

apt-install-if-needed nginx-full
# sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf
sudo mv /tmp/bestshift.conf /etc/nginx/sites-available/bestshift
sudo rm -rf /etc/nginx/sites-enabled/bestshift
sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/bestshift /etc/nginx/sites-enabled/bestshift
sudo service nginx restart
