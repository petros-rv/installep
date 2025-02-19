#!/bin/bash
echo  -e "\033[5m\e[1;31mОБНОВЛЯЕМ СИСТЕМУ! \033[0m"
apt-get update
apt-get dist-upgrade -y 
chromiuminstall=" "
echo -e "\e[1;31m "
read -r -p "Устанавливать последнюю версию браузера Chromium GOST (Yes/No): " chromiuminstall
if [[ $chromiuminstall = "Yes" || $chromiuminstall = "Yes" || $chromiuminstall = "Y" || $chromiuminstall = "y" ]];
then
	echo -e "\033[0m "
	apt-get remove chromium chromium-gost-stable -y
	rm -f /tmp/SXG/*.txt
	rm -f /tmp/SXG/*.rpm
    echo "0 . Установка последней версии Chromium GOST"
	sleep 3
	proxyes=" "
	echo -e "\e[1;31m "
	read -r -p "Подключение к интернету осуществляется с помощью proxy сервера (Yes/No): " proxyes
	echo -e "\033[0m "
	if [[ $proxyes = "Yes" || $proxyes = "Yes" || $proxyes = "Y" || $proxyes = "y" ]];
	then
		who > filename.txt
		if grep -q 'tty1' /tmp/SXG/filename.txt;
		then
    	username=$(head -1 filename.txt | cut -d' ' -f1)
        echo "Имя пользователя: $username"
		else
    	echo "Строка tty1 не найдена в файле."
		fi
		proxyname=" "
    	proxyport=" "
	    echo "Введите имя  proxy сервера и пароль в формате proxyname:proxypass"
    	echo "Если пароля нет введите просто имя proxy сервера "
    	read -r -p "Имя  proxy сервера:" proxyname
    	read -r -p "Порт proxy сервера:" proxyport
		echo -e "\033[0m "
        curl --proxy $proxyname:$proxyport https://api.github.com/repos/deemru/Chromium-Gost/releases/latest >> ver.txt
       	grep -E '(github.*rpm)' ver.txt >> verF.txt
		sed -i -e 's|.* ||' verF.txt
		sed -i 's/"//g' verF.txt
       	line=$(head verF.txt)
        echo $line
		sudo -u "$username" wget -e use_proxy=yes -e https_proxy=$proxyname:$proxyport $line
       	rpm -i chromium-gost*linux-amd64.rpm
		echo  -e "\033[5m\e[1;31mУстановка последней версии Chromium-GOST произведена! \033[0m"
	
	else
		curl https://api.github.com/repos/deemru/Chromium-Gost/releases/latest >> ver.txt
        grep -E '(github.*rpm)' ver.txt >> verF.txt
		sed -i -e 's|.* ||' verF.txt
		sed -i 's/"//g' verF.txt
        line=$(head  verF.txt)
		sudo -u "$username" wget $line
        rpm -i /tmp/chromium/chromium-gost*linux-amd64.rpm
		echo  -e "\033[5m\e[1;31mУстановка последней версии Chromium-GOST произведена! \033[0m"
		sleep 3
	fi
else
  echo  -e "\033[5m\e[1;31mУстановка Chromium-GOST не произведена! \033[0m"
  fi
#
echo  "1. Установим предворительный пакет для работы КриптоПро CSP"
apt-get install -y cryptopro-preinstall
mkdir /tmp/cryptopro
cp /tmp/SXG/linux-amd64.tgz /tmp/cryptopro
cd /tmp/cryptopro
tar -xf /tmp/cryptopro/linux-amd64.tgz
echo "2. Установим пакеты КриптоПро CSP"
sleep 3
cd /tmp/cryptopro/linux-amd64/
apt-get install -y cprocsp-curl* lsb-cprocsp-base* lsb-cprocsp-capilite* lsb-cprocsp-kc1-64* lsb-cprocsp-rdr-64* cprocsp-rdr-gui-gtk* cprocsp-rdr-rutoken* cprocsp-rdr-pcsc* lsb-cprocsp-pkcs11* pcsc-lite-rutokens pcsc-lite-ccid cprocsp-rdr-cryptoki* 
apt-get install cprocsp-cptools*.rpm
echo "Установим сертификаты Головного удостоверяющего центра"
sleep 3
apt-get install -y lsb-cprocsp-ca-certs*
echo "3. Запускаем интерфейс PCSC"
sleep 3
systemctl start pcscd
systemctl enable pcscd
echo "Загружаем и устанавливаем КриптоПро ЭЦП Browser plug-in"
sleep 3
wget -P /tmp/chromium/ -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36' https://cryptopro.ru/products/cades/plugin/get_2_0
cd /tmp/chromium/
tar -xvf /tmp/chromium/get_2_0
apt-get install /tmp/chromium/cades-linux-amd64/cprocsp-pki-cades*.rpm
apt-get install /tmp/chromium/cades-linux-amd64/cprocsp-pki-phpcades*.rpm
apt-get install /tmp/chromium/cades-linux-amd64/cprocsp-pki-plugin*.rpm
echo "Загружаем и устанавливаем плагин для работы на сайте gosuslugi.ru"
sleep 3
wget -P /tmp/plgosuslugi/ -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36' https://ds-plugin.gosuslugi.ru/plugin/upload/assets/distrib/IFCPlugin-x86_64.rpm
cd /tmp/plgosuslugi/ 
apt-get install -y IFCPlugin-x86_64.rpm
echo "Скачиваем и устанавливаем ifcx64.cfg"
sleep 3
sudo -u "$username" wget -P /tmp/SXG/ -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.3' www.cryptopro.ru/sites/default/files/public/faq/ifcx64.cfg
sudo -u "$username" cp /tmp/SXG/ifcx64.cfg /home/$username/ifcx64.cfg -rf
sudo -u "$username" /opt/cprocsp/bin/amd64/csptestf -absorb -certs -autopro
cp /tmp/SXG/ifcx64.cfg /etc/ifc.cfg -rf
cp /etc/opt/chrome/native-messaging-hosts/ru.rtlabs.ifcplugin.json /etc/chromium/native-messaging-hosts
echo  -e "\033[5m\e[1;31mУстановка Криптопро CSP 5.0  произведена! \033[0m"
sleep 3
