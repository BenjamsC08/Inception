#!/bin/bash
set -euo pipefail

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"          # ← correction du nom
PIDFILE="/run/mysqld/mysqld.pid"

# 1. Toujours recréer le dossier runtime (éphémère dans le conteneur)
mkdir -p "$(dirname "${SOCKET}")" "${DATADIR}"
chown -R mysql:mysql "$(dirname "${SOCKET}")" "${DATADIR}"

initialize_database() {
    if [ ! -d "${DATADIR}/mysql" ]; then
        echo "Première initialisation de la base de données..."
        mariadb-install-db --user=mysql --datadir="${DATADIR}" --skip-test-db
    fi
}

setup_database() {
    echo "Configuration des utilisateurs et de la base..."
    # Serveur temporaire
    mysqld --skip-networking --socket="${SOCKET}" --datadir="${DATADIR}" --user=mysql &
    local pid="$!"

    # Attendre qu’il soit prêt
    for i in {30..0}; do
        if mysqladmin --socket="${SOCKET}" --silent ping; then
            break
        fi
        sleep 1
    done

    # Configuration via variables d’environnement
    mariadb --socket="${SOCKET}" -uroot <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    kill "${pid}"
    wait "${pid}" 2>/dev/null || true
    rm -f "${SOCKET}" "${PIDFILE}"          # ← nettoyage du socket
}

start_mariadb() {
    echo "Démarrage de MariaDB..."
    exec mysqld \
        --datadir="${DATADIR}" \
        --socket="${SOCKET}" \
        --pid-file="${PIDFILE}" \
        --user=mysql
}

# === Flux principal ===
initialize_database

if [ ! -f "${DATADIR}/.initialized" ]; then
    setup_database
    touch "${DATADIR}/.initialized"
fi

start_mariadb
