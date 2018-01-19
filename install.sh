read -p "[1] Listen Port (7777) > " lport
read -p "[2] Your Domain (localhost) > " domain
read -p "[3] Pool Host&Port (pool.elitexmr.com:8080) > " pool
read -p "[4] Your XMR wallet (important!!!) > " addr
if [ ! -n "$lport" ];then
    lport="7777"
fi
if [ ! -n "$domain" ];then
    domain="localhost"
fi
if [ ! -n "$pool" ];then
    pool="165.227.189.226:1111"
fi
while  [ ! -n "$addr" ];do
    read -p "Plesae set XSM wallet address!!! > " addr
done
read -p "[5] The Pool passwd (null) > " pass
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt install --yes nodejs git curl nginx
mkdir /srv
cd /srv
rm -rf deepMiner
git clone https://github.com/shopglobal/deepMiner.git -o deepMiner
cd deepMiner
sed -i "s/7777/$lport/g" config.json
sed -i "s/miner.coinmine.network.com/$domain/g" config.json
sed -i "s/165.227.189.226:1111/$pool/g" config.json
sed -i "s/XSwEDDwyB6UC6FRbZqC5vtUCFrmee3Pbh4LqKkaW8CcRVWUKnoDsAute7RqLpmcv4v3JgFaPwi2A4ckJrbQYDzb32g3SZrDyi/$addr/g" config.json
sed -i "s/\"pass\": \"\"/\"pass\": \"$pass\"/g" config.json
npm update
pm2 start /srv/deepMiner/server.js
sed -i '/pm2 start \/srv\/deepMiner\/cluster.js/d' /etc/rc.local
sed -i '/exit 0/d' /etc/rc.local
echo "pm2 start /srv/deepMiner/cluster.js" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
rm -rf /etc/nginx/sites-available/deepMiner.conf
rm -rf /etc/nginx/sites-enabled/deepMiner.conf
echo 'server {' >> /etc/nginx/sites-available/deepMiner.conf
echo 'listen 80;' >> /etc/nginx/sites-available/deepMiner.conf
echo "server_name $domain;" >> /etc/nginx/sites-available/deepMiner.conf
echo 'location / {' >> /etc/nginx/sites-available/deepMiner.conf
echo 'proxy_http_version 1.1;' >> /etc/nginx/sites-available/deepMiner.conf
echo 'proxy_set_header   Host	$http_host;' >> /etc/nginx/sites-available/deepMiner.conf
echo 'proxy_set_header   X-Real-IP $remote_addr;' >> /etc/nginx/sites-available/deepMiner.conf
echo 'proxy_set_header   Upgrade $http_upgrade;' >> /etc/nginx/sites-available/deepMiner.conf
echo 'proxy_set_header   Connection "upgrade";' >> /etc/nginx/sites-available/deepMiner.conf
echo 'proxy_cache_bypass $http_upgrade;' >> /etc/nginx/sites-available/deepMiner.conf
echo "proxy_pass         http://127.0.0.1:$lport;" >> /etc/nginx/sites-available/deepMiner.conf
echo '}' >> /etc/nginx/sites-available/deepMiner.conf
echo '}' >> /etc/nginx/sites-available/deepMiner.conf
ln -s /etc/nginx/sites-available/deepMiner.conf /etc/nginx/sites-enabled/deepMiner.conf
clear
echo " >>> Serv : $domain (backend > 127.0.0.1:$lport)"
echo " >>> Pool : $pool"
echo " >>> Addr : $addr"
echo ""
echo " All done ! Enjoy deepMiner !"
echo ""
service nginx restart
