#!/bin/bash

echo "Creating volume directories."
rm -Rf ./data
mkdir -p data/kibana/data data/kibana/config data/es/data01 data/es/data02
cp kibana.yml data/kibana/config
source .env
sed -i "s~KIBANA_PUBLIC_BASE_URL~${KIBANA_PUBLIC_BASE_URL}~g" data/kibana/config/kibana.yml