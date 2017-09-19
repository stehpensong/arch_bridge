#!/bin/bash

workdir=`dirname $0`
cd ${workdir}
workdir=`pwd`

nginx=${workdir}/sbin/nginx
nginx_prefix=${workdir}
nginx_conf=${workdir}/conf/nginx.conf

action=$1

export LD_LIBRARY_PATH=${workdir}/sbin:$LD_LIBRARY_PATH

if [ "${action}" == "start" ]; then
    ${nginx} -p ${nginx_prefix} -c ${nginx_conf} 
fi

if [ "${action}" == "stop" ]; then
    ${nginx} -p ${nginx_prefix} -c ${nginx_conf} -s stop
fi

if [ "${action}" == "reload" ]; then
    ${nginx} -p ${nginx_prefix} -c ${nginx_conf} -s reload
fi

