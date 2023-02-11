# Elastic Search in Docker


## Quick start

1. Copy the `.env.example` file to `.env`
2. Edit the `.env` file as needed. In particular:  
- KIBANA_PUBLIC_BASE_URL: set it to the public URL Kibana will be available from
3. Run the `setup.sh` in a terminal console to create the initial environment.
4. Run `docker-compose up -d`

After a while the stack is up and you can test it on a browser at the URL https://127.0.0.1:9200/_cat/nodes for Elastic Search (or any IP you have configured) and http://127.0.0.1:5601 for Kibana.

### Credentials

This setup is intended to run behind an NGINX reverse proxy. The credentials will be managed by NGINX

## Expose via nginx

You can create a configuration in your server to expose Elastic Search and Kibana. For example, here are default setups for nginx.

### Elastic Search
```
server {
	server_name elastic.mydomain.io;
	root /var/www/html;
	index index.html;
	server_tokens off;

	location / {
		auth_basic           "Restricted";
		auth_basic_user_file /etc/nginx/.htpasswd;
		proxy_pass         http://localhost:9200;
		proxy_http_version 1.1;
		proxy_set_header   Upgrade $http_upgrade;
		proxy_set_header   Connection keep-alive;
		proxy_set_header   Host $host;
		proxy_cache_bypass $http_upgrade;
		proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header   X-Forwarded-Proto $scheme;
	}
}
```

### Kibana
```
server {
	server_name kibana.mydomain.io;
	root /var/www/html;
	index index.html;
	server_tokens off;

	location / {
		auth_basic           "Restricted";
		auth_basic_user_file /etc/nginx/.htpasswd;
		proxy_pass         http://localhost:5601;
		proxy_http_version 1.1;
		proxy_set_header   Upgrade $http_upgrade;
		proxy_set_header   Connection keep-alive;
		proxy_set_header   Host $host;
		proxy_cache_bypass $http_upgrade;
		proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header   X-Forwarded-Proto $scheme;
	}
}
```

Remove the `auth_basic` and `auth_basic_user_file` for unrestricted access.

You can use your distro to generate the `.htpasswd` accordingly. On most distro, it will be:
```
sudo htpasswd -c /etc/nginx/.htpasswd my_username
```

If you don't have the `htpasswd` command, install the `apache2-utils` package.