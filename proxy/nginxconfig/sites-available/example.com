server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	server_name "~^(.*?)\.example\.com";
	
	# SSL
	ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/example.com/chain.pem;
	# security
	include conf.d/nginxconfig.io/security.conf;
	# reverse proxy
	location / {
                resolver 127.0.0.11 valid=15s;
                proxy_pass http://$1$uri$is_args$args;
        	include conf.d/nginxconfig.io/proxy.conf;
	}
}

# HTTP redirect
server {
	listen 80;
	listen [::]:80;

	server_name ~(.*\.example\.com);

	include conf.d/nginxconfig.io/letsencrypt.conf;

	location / {
		return 301 https://$1$request_uri;
	}
}
