#!/usr/bin/env bash

IS_CLUSTER="$(snapctl get is-cluster)"
if [ -z "${IS_CLUSTER}" ] || [ "${IS_CLUSTER}" != "true" ]; then
    IS_CLUSTER="false"
fi
snapctl set is-cluster="${IS_CLUSTER}"

# For security measures, daemons should not be run as sudo. Execute valkey as the non-sudo user: snap-daemon.
exec "${SNAP}"/usr/bin/setpriv \
    --clear-groups \
    --reuid snap_daemon \
    --regid snap_daemon \
    -- \
    "${SNAP}"/usr/bin/redis_exporter --is-cluster="${IS_CLUSTER}"
