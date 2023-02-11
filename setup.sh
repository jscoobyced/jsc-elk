#!/bin/bash

DATA_ROOT="./data"
CREATION_VALUE="Updating"

if [ -d "${DATA_ROOT}" ];
then
    read -p 'Data folder found. Do you want to delete it? [Y/n] ' DELETE_DATA_ROOT
    if [ "${DELETE_DATA_ROOT}" = "" ] || [ "${DELETE_DATA_ROOT}" = "y" ] || [ "${DELETE_DATA_ROOT}" = "Y" ];
    then
        echo "Deleting old configuration and volumes."
        rm -Rf ./data
        CREATION_VALUE="Creating"
    fi
fi

echo "${CREATION_VALUE} volume directories."
mkdir -p ${DATA_ROOT}/kibana/data ${DATA_ROOT}/kibana/config ${DATA_ROOT}/es/data01 ${DATA_ROOT}/es/data02

echo "Updating the kibana configuration."
source .env
cp kibana.yml ${DATA_ROOT}/kibana/config
sed -i "s~KIBANA_PUBLIC_BASE_URL~${KIBANA_PUBLIC_BASE_URL}~g" ${DATA_ROOT}/kibana/config/kibana.yml

echo "Ensuring VM settings are correct"
VM_MAX_MAP_COUNT=$(sysctl -n vm.max_map_count 2>&1)
if [ ${VM_MAX_MAP_COUNT} -ge 262144 ] 2> /dev/null ;
then
    echo "VM settings are good."
else
    echo "Setting is not in /etc/sysctl.conf. Updating it. You might be asked for sudo password."
    echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -w vm.max_map_count=262144
fi