server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	server_name ncc-paas.qsncc.com;
	root /var/code/ncc-paas.qsncc.com;

	# SSL
	ssl_certificate /etc/letsencrypt/live/ncc-paas.qsncc.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/ncc-paas.qsncc.com/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/ncc-paas.qsncc.com/chain.pem;

	# security
	include nginxconfig.io/security.conf;

	# logging
	access_log /var/log/nginx/ncc-paas.qsncc.com.access.log;
	error_log /var/log/nginx/ncc-paas.qsncc.com.error.log warn;

	# index.html fallback
	location / {
		try_files $uri $uri/ /index.html;
	}

	# reverse proxy
	location /ess/ {
		proxy_pass http://10.0.0.26/nccwebapp/ess7.0/;
		include nginxconfig.io/proxy.conf;
	}

	# additional config
	include nginxconfig.io/general.conf;
}

# subdomains redirect
server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	server_name ncc-paas.qsncc.com;

	# SSL
	#ssl_certificate /var/cert/live/ncc-paas.qsncc.com/fullchain.pem;
	#ssl_certificate_key /var/cert/live/ncc-paas.qsncc.com/privkey.pem;
	#ssl_trusted_certificate /var/cert/live/ncc-paas.qsncc.com/chain.pem;
        ssl_certificate /var/cert/live/ncc-paas.qsncc.com/fullchain.pem;
        ssl_certificate_key /var/cert/live/ncc-paas.qsncc.com/privkey.pem;


	return 301 https://ncc-paas.qsncc.com$request_uri;
}

# HTTP redirect
server {
	listen 80;
	listen [::]:80;

	server_name ncc-paas.qsncc.com;

	include nginxconfig.io/letsencrypt.conf;

	location / {
		return 301 https://ncc-paas.qsncc.com$request_uri;
	}
}
