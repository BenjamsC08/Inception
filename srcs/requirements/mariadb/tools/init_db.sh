#!/bin/bash
set -eu

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"
PIDFILE="/run/mysqld/mysqld.pid"

if [ ! -f /run/secrets/db_root_password ]; then
  echo "secret db_root_password not found" >&2
  exit 1
fi

if [ ! -f /run/secrets/db_user_password ]; then
  echo "secret db_user_password not found" >&2
  exit 1
fi

MARIADB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
MARIADB_PASSWORD="$(cat /run/secrets/db_user_password)"

mkdir -p "$(dirname "${SOCKET}")" "${DATADIR}"
chown -R mysql:mysql "$(dirname "${SOCKET}")" "${DATADIR}"

init_db() {
    if [ ! -d "${DATADIR}/mysql" ]; then
        mariadb-install-db --user=mysql --datadir="${DATADIR}" --skip-test-db
    fi
}

setup_database() {
    mysqld --skip-networking --socket="${SOCKET}" --datadir="${DATADIR}" --user=mysql &
    local pid="$!"

    for i in {30..0}; do
        if mysqladmin --socket="${SOCKET}" --silent ping; then
            break
        fi
        sleep 1
    done

    # Configuration via variables d’environnement
	# https://mariadb.com/docs/server/reference/plugins/authentication-plugins/authentication-plugin-unix-socket
	# i init my db with the socket like mariadb 10.1+ want, and change root password when done
	# and then kill the process rm the sokcet and restart the db
    mariadb --socket="${SOCKET}" -uroot <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    kill "${pid}"
    wait "${pid}" 2>/dev/null || true
    rm -f "${SOCKET}" "${PIDFILE}"
}

start_mariadb() {
    exec mysqld \
        --datadir="${DATADIR}" \
        --socket="${SOCKET}" \
        --pid-file="${PIDFILE}" \
        --user=mysql
}

init_db

if [ ! -f "${DATADIR}/.initialized" ]; then
    setup_database
    touch "${DATADIR}/.initialized"
fi

start_mariadb
