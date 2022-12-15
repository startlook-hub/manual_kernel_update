# ������������ �10. �������� ������ ��� CRON, ������� ��� � ��� ����� ����������� ������ � ���������� �� �������� �����.
## ������: ����������� ���������� � ������:

������ IP ������� (� ���������� ���-��� ��������) � ��������� ���-�� �������� c ������� ���������� ������� �������;
������ ������������� URL (� ���������� ���-��� ��������) � ��������� ���-�� �������� c ������� ���������� ������� �������;
������ ���-�������/���������� c ������� ���������� �������;
������ ���� ����� HTTP ������ � ��������� �� ���-�� � ������� ���������� ������� �������.
������ ������ ������������� ������������� ������ ���������� �����, �� ��� ����������.
� ������ ������ ���� �������� �������������� ��������� ��������.

������ ����������� �����:
```
#!/usr/bin/env bash
echo -e "\n������ IP ������� � ���������� ���-��� �������� \n" >> /tmp/send_nginx.log
cat /var/log/nginx/access.log | cut -d' ' -f1 | sort | uniq -c | sort -nr | tail -n10 >> /tmp/send_nginx.log
echo -e "\n����� ���������� �������� \n" >> /tmp/send_nginx.log
cat /var/log/nginx/access.log | cut -d' ' -f1 | sort | uniq -c | sort -nr | tail -n10 | awk '{print $1}' | awk '{sum += $1} END {print sum}'  >> /tmp/send_nginx.log

echo -e "\n������ ����� ������ HTTP ������� \n" >> /tmp/send_nginx.log
awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -rn  >> /tmp/send_nginx.log
echo -e "\n����� ���������� ����� ������ HTTP \n" >> /tmp/send_nginx.log
awk '{print $9}' /var/log/nginx/access.log | sort | uniq -c | sort -rn| awk '{sum += $1} END {print sum}'  >> /tmp/send_nginx.log

echo -e "\n���������� ������ "Connection timed out" �� ������� \n\n" >> /tmp/send_nginx.log
cat /var/log/nginx/error.log | grep -o 'Connection timed out' | wc -l >> /tmp/send_nginx.log 

echo -e "\n������ ������������� URL \n" >> /tmp/send_nginx.log
awk '{print $11}' /var/log/nginx/access.log | sort | uniq -c | sort -rn  >> /tmp/send_nginx.log
echo -e "\n����� ���������� ������������� URL \n" >> /tmp/send_nginx.log
awk '{print $11}' /var/log/nginx/access.log | sort | uniq -c | sort -rn| awk '{sum += $1} END {print sum}'  >> /tmp/send_nginx.log

mail -v -s "��� ������ nginx �� ������� $HOSTNAME" -a /tmp/send_nginx.log -S smtp="smtp.yandex.ru:465" -S smtp-auth=login -S smtp-auth-user="my-email@yandex.ru" -S smtp-auth-password="password" -S from=my-logbox@yandex.ru -S smtp-use-starttls -S ssl-verify=ignore
```

�������� ������� cron � ����������� �������������� �������
```
0 */1 * * * /usr/bin/flock -xn /var/lock/send_nginx.lock -c 'sh /home/user01/scripts/nginx_log_script.sh'
```

��� ������� ������� �� ������� "�� ��������� ���" � ���� �� ����������, �� �� ����� ������� ���� ����� ������� ���� ����� date � ���������� � ��� ��� ��������� �� ������� '{print $4}' ������ :unamused: