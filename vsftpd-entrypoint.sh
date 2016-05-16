#!/bin/sh
set -e

PWD_FILE_PATH="/etc/vsftpd/vsftpd.passwd"
GLOBAL_CONF_PATH="/etc/vsftpd/vsftpd.conf"
ADMIN_CONF_PATH="/etc/vsftpd/users/admin"

if [ -z "$ADMIN_PWD" ]; then
    echo >&2 'error: missing ADMIN_PWD environment variables'
    exit 1
fi

if [ ! -e $GLOBAL_CONF_PATH ]; then
  echo "VSFTP conf: No $GLOBAL_CONF_PATH found. Copy a default one"
  cp /templates$GLOBAL_CONF_PATH $GLOBAL_CONF_PATH
fi

if [ ! -e $PWD_FILE_PATH ]; then
  echo "PWD conf: No $PWD_FILE_PATH found. Create a default one"
  touch $PWD_FILE_PATH
fi

# Update admin password
if [ ! -e $ADMIN_CONF_PATH ]; then
  echo "ADMIN conf: No $ADMIN_CONF_PATH found. Copy a default one"
  cp /templates$ADMIN_CONF_PATH $ADMIN_CONF_PATH
fi

htpasswd -bB $PWD_FILE_PATH admin $ADMIN_PWD

exec "$@"
