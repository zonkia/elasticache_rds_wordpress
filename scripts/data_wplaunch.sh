#! /bin/bash
apt install nfs-common -y

cat << EOF >/opt/bitnami/wordpress/wp-config.php
<?php
define('WP_CACHE', true);
define( 'DB_NAME', '${db_name}' );
define( 'DB_USER', '${db_user}' );
define( 'DB_PASSWORD', '${db_pass}' );
define( 'DB_HOST', '${mysql_endpoint}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );


\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
define( 'FS_METHOD', 'direct' );

if ( defined( 'WP_CLI' ) ) {
        \$_SERVER['HTTP_HOST'] = '127.0.0.1';
}

define( 'WP_HOME', 'http://' . \$_SERVER['HTTP_HOST'] . '/' );
define( 'WP_SITEURL', 'http://' . \$_SERVER['HTTP_HOST'] . '/' );
define( 'WP_AUTO_UPDATE_CORE', 'minor' );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';

if ( !defined( 'WP_CLI' ) ) {
        // remove x-pingback HTTP header
        add_filter("wp_headers", function(\$headers) {
                unset(\$headers["X-Pingback"]);
                return \$headers;
        });
        // disable pingbacks
        add_filter( "xmlrpc_methods", function( \$methods ) {
                unset( \$methods["pingback.ping"] );
                return \$methods;
        });
}
EOF


#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' /opt/bitnami/wordpress/wp-config.php

echo "export MYSQL_HOST=${mysql_endpoint}" >> /etc/profile
source /etc/profile

/opt/bitnami/mysql/bin/mysql --user=${mysql_user} --password=${mysql_pass} --database=${db_name} --execute="CREATE USER '${db_user}' IDENTIFIED BY '${db_pass}'; GRANT ALL PRIVILEGES ON ${db_user}.* TO ${db_user};FLUSH PRIVILEGES;"

/opt/bitnami/ctlscript.sh stop

cp -r /opt/bitnami/wordpress /opt/bitnami/wordpress_temp

mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns}:/ /opt/bitnami/wordpress
mv /opt/bitnami/wordpress_temp/* /opt/bitnami/wordpress
find /opt/bitnami/wordpress -type d -exec chmod 777 {} \;
find /opt/bitnami/wordpress -type f -exec chmod 777 {} \;
rm -r /opt/bitnami/wordpress_temp
/opt/bitnami/ctlscript.sh start

sudo sleep 2m
sudo shutdown now







