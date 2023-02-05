# Elastic Search in Docker

# Quick start

1. Run the `setup.sh` in a terminal console to create the volume folders.
2. Run the command
```
grep vm.max_map_count /etc/sysctl.conf
```
if the output is empty then run the command
```
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```
If the first command returned a value for the `vm.max_map_count` value, then make sure it is at least `262144`, otherwise edit the `/etc/sysctl.conf` file to modify the value to `262144`.
3. Edit the `.env` file as needed (especially the 2 password lines, and optionally the PORTS)
4. Run `docker-compose up -d`

After a while the stack is up and you can test it on a browser at the URL https://127.0.0.1:9200/_cat/nodes for Elastic Search (or any IP you have configured) and http://127.0.0.1:5601 for Kibana.

## Credentials

Elastic Search credentials:
- Username: elastic
- Password: the `ELASTIC_PASSWORD` from the `.env` file

Kibana credentials:
- Username: admin
- Password: the `ELASTIC_PASSWORD` from the `.env` file (Note: **NOT** the `KIBANA_PASSWORD`)

# Expose via nginx

You can create a configuration in your server to expose Elastic Search and Kibana