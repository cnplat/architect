# dev

## Step 1

0. install [Vagrant](https://www.vagrantup.com/downloads) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads) soft.
1. vagant up
2. visit [Portainer](https://documentation.portainer.io/quickstart/): http://192.168.33.10:9000/
3. deploy stack use `infra.yml` file.

## Service

 - [Traefik](https://doc.traefik.io/traefik/) :80 :8080
 - Mysql :3306
 - Mongodb :27017
 - Redis :6379
 - Rabbitmq :5672 :15672

## Admin Web Port
 - [Portainer](https://documentation.portainer.io/quickstart/): http://192.168.33.10:9000/
 - [Traefik](https://doc.traefik.io/traefik/): http://192.168.33.10:8080/
 - Adminer: http://192.168.33.10:18080/
 - Redis commander: http://192.168.33.10:18081/
 - Mongo Express: http://192.168.33.10:18082/
 - nsqadmin: http://192.168.33.10:4171/