FROM debian:12-slim
RUN apt update && \
	apt upgrade -y && \
	apt install -y mariadb-server && \
	apt autoclean

EXPOSE 3306

LABEL version="1.0"
LABEL description="Mariadb Server for my Wordpress"

#copy conf

#copy script
COPY tools/entrypoint.sh entrypoint.sh

RUN chmod +x entryoint.sh

CMD ["/entrypoint.sh"]
