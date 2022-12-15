# Лабораторная №10. Написать скрипт для CRON, который раз в час будет формировать письмо и отправлять на заданную почту.
## Задачи: Необходимая информация в письме:

Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
Ошибки веб-сервера/приложения c момента последнего запуска;
Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта.
Скрипт должен предотвращать одновременный запуск нескольких копий, до его завершения.
В письме должен быть прописан обрабатываемый временной диапазон.

Скрипт мониторинга логов:
```
#!/usr/bin/env bash
echo -e "\nСписок IP адресов с наибольшим кол-вом запросов \n" >> /tmp/send_nginx.log
cat /var/log/nginx/access.log | cut -d' ' -f1 | sort | uniq -c | sort -nr | tail -n10 >> /tmp/send_nginx.log
echo -e "\nОбщее количество запросов \n" >> /tmp/send_nginx.log
cat /var/log/nginx/access.log | cut -d' ' -f1 | sort | uniq -c | sort -nr | tail -n10 | awk '{print $1}' | awk '{sum += $1} END {print sum}'  >> /tmp/send_nginx.log

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
```

Создание задания cron с блокировкой одновременного запуска
```
0 */1 * * * /usr/bin/flock -xn /var/lock/send_nginx.lock -c 'sh /home/user01/scripts/nginx_log_script.sh'
```

Как сделать выборку по времени "за последний час" я пока не разобрался, из не очень хороших идей взять текущую дату через date и сравнивать с ней все вхождения по столбцу '{print $4}' циклом :unamused: