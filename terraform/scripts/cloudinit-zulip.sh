#!/bin/bash

# https://zulip.readthedocs.io/en/stable/production/install.html

INSTALL_DIR=$(mktemp -d)

git clone http://gitlab+deploy-token-1:<token>@<ip>/sites/zulip.git "$INSTALL_DIR"

cd "$INSTALL_DIR"/scripts || return

su -c "./setup/install --self-signed-cert --email=${email} --hostname=${domain}
          --postgresql-database-name=${db_name} --postgresql-database-user=${db_user} --no-init-db"

service postgresql stop
update-rc.d postgresql disable

cat <<EOT >> /etc/zulip/settings.py

REMOTE_POSTGRES_HOST = "postgres.local.lan"
REMOTE_POSTGRES_PORT = "5432"

REDIS_HOST = "redis.local.lan"
REDIS_PORT = 6379

EMAIL_HOST_USER = "<address>"
EMAIL_HOST = "mail.local.lan"
EMAIL_PORT = 10025
EMAIL_USE_TLS = True
NOREPLY_EMAIL_ADDRESS = "<address>"
ADD_TOKENS_TO_NOREPLY_ADDRESS = False

PUSH_NOTIFICATION_BOUNCER_URL = "https://push.zulipchat.com"
EOT

su zulip -c '/home/zulip/deployments/current/scripts/restart-server'

exit 0