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
apt install --yes nodejs git curl
mkdir /srv
cd /srv
rm -rf deepMiner
git clone https://github.com/AltcoinCoop/deepMiner.git -o deepMiner
cd deepMiner
sed -i "s/7777/$lport/g" config.json
sed -i "s/miner.coinmine.network.com/$domain/g" config.json
sed -i "s/165.227.189.226:1111/$pool/g" config.json
sed -i "s/XSwiLJUPxqv4hbFsvvV5BgVFqWiWmfzyXKWFQb9ZWuUJhKFhSYJUGSB6cmRn2qo2J5Vwsi1bfg8AYfyx9JKc2GdY2CiE1RrG8/$addr/g" config.json
sed -i "s/\"pass\": \"\"/\"pass\": \"$pass\"/g" config.json
npm update
pm2 start /srv/deepMiner/server.js
sed -i '/pm2 start \/srv\/deepMiner\/cluster.js/d' /etc/rc.local
sed -i '/exit 0/d' /etc/rc.local
echo "pm2 start /srv/deepMiner/cluster.js" >> /etc/rc.local
echo " >>> Serv : $domain (backend > 127.0.0.1:$lport)"
echo " >>> Pool : $pool"
echo " >>> Addr : $addr"
echo ""
echo " All done ! Enjoy deepMiner !"
echo ""
