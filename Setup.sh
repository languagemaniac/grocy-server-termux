#!/data/data/com.termux/files/usr/bin/bash

# Create necessary folders
mkdir $PREFIX/etc/nginx/conf.d
mkdir $PREFIX/etc/nginx/sites-enabled
mkdir $PREFIX/etc/nginx/snippets

# Create and edit fastcgi-params file
cat <<EOF > $PREFIX/etc/nginx/conf.d/fastcgi-params
include fastcgi_params;
fastcgi_split_path_info ^(.+?\.php)(|/.*)$;
fastcgi_pass unix:/data/data/com.termux/files/usr/var/run/php-fpm.sock;
EOF

# Create and edit default site config file
cat <<EOF > $PREFIX/etc/nginx/sites-enabled/default
server {
    listen 8080 default_server;
    root /data/data/com.termux/files/usr/var/www/html/public;
    index index.html;
    server_name localhost;

    location / {
        try_files \$uri /index.php;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/data/data/com.termux/files/usr/var/run/php-fpm.sock;
    }
}
EOF

# Create and edit fastcgi-php.conf file
cat <<EOF > $PREFIX/etc/nginx/snippets/fastcgi-php.conf
fastcgi_split_path_info ^(.+?\.php)(/.*)$;
try_files \$fastcgi_script_name =404;
set \$path_info \$fastcgi_path_info;
fastcgi_param PATH_INFO \$path_info;
fastcgi_index index.php;
include fastcgi.conf;
EOF

# Replace entire server block in nginx.conf file
sed -i '/^server {/,/^}/d' $PREFIX/etc/nginx/nginx.conf
cat <<EOF >> $PREFIX/etc/nginx/nginx.conf
include conf.d/*.conf;
include sites-enabled/*;
EOF

# Install grocy
wget https://releases.grocy.info/latest
mkdir -p $PREFIX/var/www/html
unzip -q latest -d $PREFIX/var/www/html
cp $PREFIX/var/www/html/config-dist.php $PREFIX/var/www/html/data/config.php

# Enable php-fpm and nginx services
sv-enable php-fpm
sv-enable nginx
