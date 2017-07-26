#!/bin/sh
set -e

DRUID_HOME=/usr/share/druid

# Run as broker if needed
if [ "${1:0:1}" = '' ]; then
    set -- broker "$@"
fi

if [ "$DRUID_XMX" != "-" ]; then
    sed -ri 's/Xmx.*/Xmx'${DRUID_XMX}'/g' ${DRUID_HOME}/conf/druid/$1/jvm.config
fi

if [ "$DRUID_XMS" != "-" ]; then
    sed -ri 's/Xms.*/Xms'${DRUID_XMS}'/g' ${DRUID_HOME}/conf/druid/$1/jvm.config
fi

if [ "$DRUID_MAXNEWSIZE" != "-" ]; then
    sed -ri 's/MaxNewSize=.*/MaxNewSize='${DRUID_MAXNEWSIZE}'/g' ${DRUID_HOME}/conf/druid/$1/jvm.config
fi

if [ "$DRUID_NEWSIZE" != "-" ]; then
    sed -ri 's/NewSize=.*/NewSize='${DRUID_NEWSIZE}'/g' ${DRUID_HOME}/conf/druid/$1/jvm.config
fi

if [ "$DRUID_HOSTNAME" != "-" ]; then
    sed -ri 's/druid.host=.*/druid.host='${DRUID_HOSTNAME}'/g' ${DRUID_HOME}/conf/druid/$1/runtime.properties
fi

if [ "$DRUID_LOGLEVEL" != "-" ]; then
    sed -ri 's/druid.emitter.logging.logLevel=.*/druid.emitter.logging.logLevel='${DRUID_LOGLEVEL}'/g' ${DRUID_HOME}/conf/druid/_common/common.runtime.properties
fi

if [ "$DRUID_USE_CONTAINER_IP" != "-" ]; then
    ipaddress=`ip a|grep "global eth0"|awk '{print $2}'|awk -F '\/' '{print $1}'`
    sed -ri 's/druid.host=.*/druid.host='${ipaddress}'/g' ${DRUID_HOME}/conf/druid/$1/runtime.properties
fi

java `cat ${DRUID_HOME}/conf/druid/$1/jvm.config | xargs` -cp ${DRUID_HOME}/conf/druid/_common:${DRUID_HOME}/conf/druid/$1:${DRUID_HOME}/lib/* io.druid.cli.Main server $@
