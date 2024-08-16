#!/bin/bash

apt-get install -y curl openssh-server ca-certificates tzdata perl

cd "$(mktemp -d)" || return

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

GITLAB_ROOT_PASSWORD="initialPasswd" EXTERNAL_URL="http://<domain>" apt-get install gitlab-ce

cat <<EOT >> /etc/gitlab/gitlab.rb

gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "mail.local.lan"
gitlab_rails['smtp_port'] = 10025
gitlab_rails['smtp_user_name'] = "<username>"
gitlab_rails['smtp_password'] = ""
gitlab_rails['smtp_domain'] = "<domain>"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_openssl_verify_mode'] = 'none'

gitlab_rails['gitlab_email_from'] = '<address>'
gitlab_rails['gitlab_email_reply_to'] = '<address>'
EOT

gitlab-ctl reconfigure
