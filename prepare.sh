#!/bin/bash

username='*'
password='*'

useradd $username
echo $username:$password | chpasswd
apt-get install sysstat -y || yum install sysstat -y

for i in 'grep' 'awk' 'sed' 'ifconfig' 'iostat' 'bc' 'free' 'cut' 'netstat';
do
        command -v $i >/dev/null 2>&1 || { echo >&2 "$i required, but it's not installed.  Installing."; apt-get i$
        sudo -u $username $i  >/dev/null 2>&1 || sudo -u $username $i --help >/dev/null 2>&1 || {echo >&2 "$i is not allowed to be executed by $username";}
done

mkdir -p /var/prtg/scripts
wget -O /tmp/scripts.tar.gz https://files.slack.com/files-pri/T03RD89S9-F0RJCSM9B/download/prtg-scripts.tar.gz?pub_secret=9d132d142f
tar -xzf /tmp/scripts.tar.gz --directory /var/prtg/scripts
ln -s /var/prtg/scripts /var/prtg/scriptsxml
chown $username:$username /var/prtg/scripts
chmod --recursive 755 /var/prtg/
chmod ug+x,o-rwx /var/prtg/scripts/*

for i in 'check_iostat' 'check_memory' 'check_net_io' 'check_cpu_stat';
do
        sudo -u $username /var/prtg/scripts/$i.sh -h 2>&1 >/dev/null || { echo >&2 "$i is not allowed to be executed by $username";}
done

echo 'success'
exit 0;