## 🚀 Instalación local

#bash
git clone https://github.com/pmercado12/flutter-proy-final

cd flutter-proy-final

#Terminal 1
docker compose up --build

#Terminal 2
docker compose exec backend npx prisma migrate deploy

docker compose exec backend npx prisma db seed
