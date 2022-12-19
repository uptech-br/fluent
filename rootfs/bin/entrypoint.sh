#!/usr/bin/dumb-init /bin/sh

uid=${FLUENT_UID:-1000}

# check if a old fluent user exists and delete it
cat /etc/passwd | grep fluent
if [ $? -eq 0 ]; then
    deluser fluent
fi

# (re)add the fluent user with $FLUENT_UID
adduser -D -g '' -u ${uid} -h /home/fluent fluent

#source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    source $DEFAULT
    set +o allexport
fi

# chown home and data folder
chown -R fluent /home/fluent
chown -R fluent /fluentd

MONGODB_URI='mongodb://'${MONGODB_USERNAME-dev}':'${MONGODB_PASSWORD-1234567890}'@'${MONGODB_HOST-mongo}':'${MONGODB_PORT-27017}'/'${MONGODB_DB-dev}'?authSource=admin'
REPLACE=$(printf '%s\n' "$MONGODB_URI" | sed -e 's/[\/&]/\\&/g')
sed -i -e 's/MONGODB_URI/'"${REPLACE}"'/g' /fluentd/etc/fluent.conf

exec su-exec fluent "$@"