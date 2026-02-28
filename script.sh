#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -e

# Update system
yum update -y

# Install Docker & Git
yum install -y docker git

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Allow ec2-user to run docker
usermod -aG docker ec2-user

# Install Docker Compose v2 system-wide
mkdir -p /usr/libexec/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64 \
  -o /usr/libexec/docker/cli-plugins/docker-compose
chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# Create application directory
mkdir -p /opt/app
cd /opt/app

# -------------------------
# Create Nginx Config
# -------------------------
cat <<'EOF' > myconfig.conf
upstream frontend_servers {
    server fend:80;
}

upstream backend_servers {
    server bend:5000;
}

server {
    listen 80;

    location / {
        proxy_pass http://frontend_servers;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api/v1/ {
        proxy_pass http://backend_servers;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# -------------------------
# Create Docker Compose File
# -------------------------
cat <<'EOF' > docker-compose.yaml
version: "3.9"

services:
  fend:
    image: public.ecr.aws/l2y6y8r3/frontend
    expose:
      - "80"
    restart: always

  bend:
    image: public.ecr.aws/l2y6y8r3/backend
    expose:
      - "5000"
    environment:
      - MONGO_URI=mongodb://db:27017/expense_db
      - JWT_SECRET=e581372412881a8a196c46b1d9d13f45a42be030085c4ba2baad205a8bd822c3
    depends_on:
      - db
    volumes:
      - expense_uploads:/app/uploads
    restart: always

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./myconfig.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - fend
      - bend
    restart: always

  db:
    image: mongo:latest
    volumes:
      - mongo_data:/data/db
    restart: always

volumes:
  mongo_data:
  expense_uploads:
EOF

# -------------------------
# Start Application
# -------------------------
docker compose up -d
