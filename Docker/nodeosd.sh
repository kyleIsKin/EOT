#!/bin/sh
cd /opt/eotio/bin

if [ -f '/opt/eotio/bin/data-dir/config.ini' ]; then
    echo
  else
    cp /config.ini /opt/eotio/bin/data-dir
fi

if [ -d '/opt/eotio/bin/data-dir/contracts' ]; then
    echo
  else
    cp -r /contracts /opt/eotio/bin/data-dir
fi

while :; do
    case $1 in
        --config-dir=?*)
            CONFIG_DIR=${1#*=}
            ;;
        *)
            break
    esac
    shift
done

if [ ! "$CONFIG_DIR" ]; then
    CONFIG_DIR="--config-dir=/opt/eotio/bin/data-dir"
else
    CONFIG_DIR=""
fi

exec /opt/eotio/bin/nodeot $CONFIG_DIR $@
