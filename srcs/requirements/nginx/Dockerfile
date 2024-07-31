FROM debian:bullseye

RUN apt-get update -y && apt-get install -y \
    nginx \
    openssl \
    libssl-dev \ 
    && apt-get clean

COPY conf/default.conf /etc/nginx/conf.d/

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
CMD ["sh", "/usr/local/bin//entrypoint.sh"]