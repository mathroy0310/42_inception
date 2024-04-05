FROM debian:bullseye

RUN apt update -y && apt-get install -y nginx && apt-get clean

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]

