# Лабораторная №1. Обновление ядра CentOS
## Задачи: клонирование базового репозитория Git, создание своего репозитория, создание кастомного образа с обновленным ядром и его публикация

Образ системы с обновленным ядром опубликован по ссылке:
https://app.vagrantup.com/startlook/boxes/centos-7-9/versions/1/providers/virtualbox.box


Запуск VM из Vagrant:
```
 vagrant init startlook/centos-7-9 \
  --box-version 1
vagrant up 
```

Соединение с VM:
```
vagrant ssh
```

Проверка версии ядра:
```
uname -r
```

Вывод:
```
[vagrant@localhost ~]$ uname -r
6.0.6-1.el7.elrepo.x86_64
```
