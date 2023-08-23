#! /bin/bash
apt install nfs-common -y
sudo /opt/bitnami/ctlscript.sh stop
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_dns}:/ /opt/bitnami/wordpress
/opt/bitnami/ctlscript.sh start
