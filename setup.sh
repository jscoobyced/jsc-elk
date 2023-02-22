#!/bin/bash

DATA_ROOT="${PWD}/data"

if [ "${DATA_ROOT}" = "/data" ];
then
    echo "Not allowed to work from the root of the drive."
fi

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
mkdir -p ${DATA_ROOT}/kibana/data ${DATA_ROOT}/kibana/config \
    ${DATA_ROOT}/logstash/config ${DATA_ROOT}/es/data01 \
    ${DATA_ROOT}/es/data02 ${DATA_ROOT}/filebeat/config 

pushd docker/server > /dev/null
source .env

echo "Updating the kibana configuration."
cp ../conf/kibana.yml ${DATA_ROOT}/kibana/config
sed -i "s~KIBANA_PUBLIC_BASE_URL~${KIBANA_PUBLIC_BASE_URL}~g" ${DATA_ROOT}/kibana/config/kibana.yml

popd > /dev/null
pushd docker/capture > /dev/null
source .env

echo "Updating the logstash configuration."
cp ../conf/logstash.conf ${DATA_ROOT}/logstash/config
sed -i "s~ES_PASSWORD~${ES_PASSWORD}~g" ${DATA_ROOT}/logstash/config/logstash.conf
sed -i "s~ES_HOST~${ES_HOST}~g" ${DATA_ROOT}/logstash/config/logstash.conf

echo "Updating the filebeat configuration."
cp ../conf/filebeat.yml ${DATA_ROOT}/filebeat/config
chmod go-w ${DATA_ROOT}/filebeat/config/filebeat.yml
sudo chown root:root ${DATA_ROOT}/filebeat/config/filebeat.yml

popd > /dev/null

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