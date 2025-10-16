# run dev (default docker-compose.yml) ใน path 
docker compose up -d

#path
docker compose -f production.yml up -d
docker compose -f /path/to/docker-production.yml up -d

#new add
docker run --rm -v nginx_project:/data -v /c/Users/tow/Desktop/nginx/project:/source busybox cp -r /source/. /data 
docker run --rm -v nginx_project:/data -v "$(pwd)/project:/source busybox cp -r /source/. /data"  # is linux 
#เปลี่ยนเจ้าของ
docker run --rm -v nginx_project:/data busybox chown -R 33:33 /data

docker exec -it nginx bash
docker exec -it nginx ls -l /var/www/html


#clean - copy 
docker run --rm -v nginx_project:/data -v /c/Users/tow/Desktop/nginx/project:/source busybox sh -c "rm -rf /data/* && cp -r /source/. /data 
#owner set
docker run --rm -v nginx_project:/data busybox chown -R 33:33 /data

#backup
docker run --rm -v nginx_project:/data -v ./:/backup busybox sh -c "cd /data && tar -czf /backup/myapp_php_backup.tar.gz ."
docker run --rm -v nginx_project:/data -v /c/Users/tow/Desktop/backup:/backup busybox sh -c "cd /data && tar -czf /backup/nginx_project_backup.tar.gz ."
#restore
docker run --rm -v nginx_project:/data -v /c/Users/tow/Desktop/backup:/backup busybox sh -c "tar -xzf /backup/nginx_project_backup.tar.gz -C /data"
docker run --rm -v nginx_project:/data -v ./:/backup busybox sh -c "tar -xzf /backup/myapp_php_backup.tar.gz -C /data"



#restore linux 
docker run --rm -v nginx_project:/data -v "$(pwd)/backup:/backup" busybox sh -c "tar -xzf /backup/nginx_project_backup.tar.gz -C /data"



#cron job (optional)
chmod +x backup-mysql.sh
./backup-mysql.sh

crontab -e

0 2 * * * /path/to/project/backup-mysql.sh >> /path/to/project/backup.log 2>&1



#ย่อชือให้ terminal จะได้พิ่มสั้นลง
alias artisan="docker exec -it php-fpm php artisan"
alias composer="docker exec -it php-fpm composer"

ab -n 1000 -c 50 http://localhost:8000/benchmark.php