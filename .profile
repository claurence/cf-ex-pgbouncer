set -e

# change `elephantsql` to the name of your Postgres Provider
#   Ex:  `.elephantsql[].credentials.uri` for ElephantSQL
#        `.["user-provided"][].credentials.uri` for a user provided service
#        `.somepgprovider[].credentials.uri` for some ficticious Postgres provider
DBS=$(echo "$VCAP_SERVICES" | jq -r '.elephantsql[].credentials.uri' | sed 's|^postgres:\/\/\(.*\):\(.*\)@\(.*\):\(.*\)\/\(.*\)$|\5 = host=\3 port=\4 user=\1 password=\2|')

# updates pgbouncer.ini to include the connection strings
sed -i.bak "s|#PGBOUNCER_DB_STRING|$DBS|" pgbouncer.ini

# add service to be run at app start
PROCS="/home/vcap/deps/org.cloudfoundry.php-web/php-web/procs.yml"
EXISTS=$(grep -E '^pgbouncer' "$PROCS" || true)
if [ "$EXISTS" == "" ]; then
    echo '  pgbouncer:' >> "$PROCS"
    echo '    command: /home/vcap/deps/buildpack.0/layer/apt/usr/sbin/pgbouncer' >> "$PROCS"
    echo '    args:' >> "$PROCS"
    echo '    - -v' >> "$PROCS"
    echo '    - "/app/pgbouncer.ini"' >> "$PROCS"
fi