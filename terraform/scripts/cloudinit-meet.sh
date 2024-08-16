
curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install jitsi-meet

sudo apt -y install gnupg2 nginx-full
sudo apt update
sudo apt install apt-transport-https
sudo apt-add-repository universe
sudo apt update

sudo hostnamectl set-hostname <hostname>

cat <<EOT >> /etc/hosts
127.0.0.1 localhost
<ip> <hostname>
EOT

echo deb http://packages.prosody.im/debian $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list
wget https://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -
sudo apt install lua5.2

curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null

sudo apt update

sudo apt install jitsi-meet

# install acme certificate
/usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh <email>
