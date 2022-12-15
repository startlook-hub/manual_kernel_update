
#!/usr/bin/env bash
echo -e "\nСписок IP адресов с наибольшим кол-вом запросов \n" >> /tmp/send_nginx.log
cat /var/log/nginx/access.log | cut -d' ' -f1 | sort | uniq -c | sort -nr | tail -n20 >> /tmp/send_nginx.log
echo -e "\nОбщее количество запросов \n" >> /tmp/send_nginx.log
cat /var/log/nginx/access.log | cut -d' ' -f1 | sort | uniq -c | sort -nr | tail -n20 | awk '{print $1}' | awk '{sum += $1} END {print sum}'  >> /tmp/send_nginx.log

echo -e "\nСписок кодов ответа HTTP сервера \n" >> /tmp/send_nginx.log
awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -rn  >> /tmp/send_nginx.log
echo -e "\nОбщее количество кодов ответа HTTP \n" >> /tmp/send_nginx.log
awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -rn| awk '{sum += $1} END {print sum}'  >> /tmp/send_nginx.log

echo -e "\nКоличество ошибок "Connection timed out" на сервере \n\n" >> /tmp/send_nginx.log
cat /var/log/nginx/error.log | grep -o 'Connection timed out' | wc -l >> /tmp/send_nginx.log 

echo -e "\nСписок запрашиваемых URL \n" >> /tmp/send_nginx.log
awk '{print $11}' /var/log/nginx/access.log | sort | uniq -c | sort -rn  >> /tmp/send_nginx.log
echo -e "\nОбщее количество запрашиваемых URL \n" >> /tmp/send_nginx.log
awk '{print $11}' /var/log/nginx/access.log | sort | uniq -c | sort -rn| awk '{sum += $1} END {print sum}'  >> /tmp/send_nginx.log

mail -v -s "Лог работы nginx на сервере $HOSTNAME" -a /tmp/send_nginx.log -S smtp="smtp.yandex.ru:465" -S smtp-auth=login -S smtp-auth-user="my-email@yandex.ru" -S smtp-auth-password="password" -S from=my-logbox@yandex.ru -S smtp-use-starttls -S ssl-verify=ignore
