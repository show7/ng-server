FROM nginx:latest
COPY  './www' '/var/www'
COPY  './conf.d' '/etc/nginx/conf.d'


