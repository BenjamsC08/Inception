FROM debian:12-slim

RUN apt-get update && \
	apt-get install -y mariadb-server && \
	apt autoclean  && \	
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY tools/init_db.sh /init_db.sh
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
RUN chmod +x /init_db.sh

ENTRYPOINT ["./init_db.sh"]
