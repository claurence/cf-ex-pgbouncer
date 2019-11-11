set -e

# change `elephantsql` to the name of your Postgres Provider
#   Ex:  `.elephantsql[].credentials.uri` for ElephantSQL
#        `.somepgprovider[].credentials.uri` for some ficticious Postgres provider
DBS=$(echo "$VCAP_SERVICES" | jq -r '.elephantsql[].credentials.uri' | sed 's|^postgres:\/\/\(.*\):\(.*\)@\(.*\):\(.*\)\/\(.*\)$|\5 = host=\3 port=\4 user=\1 password=\2|')

# updates pgbouncer.ini to include the connection strings
sed -i.bak "s|#PGBOUNCER_DB_STRING|$DBS|" pgbouncer.ini

# add service to be run at app start
EXISTS=$(grep -E '^pgbouncer' "$HOME/.procs" || true)
if [ "$EXISTS" == "" ]; then
    echo 'pgbouncer: /home/vcap/deps/0/apt/usr/sbin/pgbouncer -v "$HOME/pgbouncer.ini"' >> "$HOME/.procs"
fi