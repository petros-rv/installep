#!/bin/bash
#Определяем пользователя
		who > filename.txt
		if grep -q 'tty1' /tmp/SXG/filename.txt;
		then
    	username=$(head -1 filename.txt | cut -d' ' -f1)
        echo -e "Имя пользователя: $username"
		else
    	echo "Строка tty1 не найдена в файле."
		fi
# Определяем наличие proxy сервера
read -r -p "Подключение к интернету осуществляется с помощью proxy сервера (Yes/No): " proxyes
echo -e "\033[0m "
if [[ $proxyes = "Yes" || $proxyes = "Yes" || $proxyes = "Y" || $proxyes = "y" ]];
then
	    echo "Введите имя  proxy сервера и пароль в формате proxyname:proxypass"
    	echo "Если пароля нет введите просто имя proxy сервера "
    	echo " "
		read -r -p "Имя  proxy сервера:" proxyname
    	read -r -p "Порт proxy сервера:" proxyport
		echo -e "\033[0m "
		echo -e "\e[1;36m "
		echo " "
		read -r -p "Устанавливать последнюю версию браузера Chromium GOST (Yes/No): " chromiuminstall
		if [[ $chromiuminstall = "Yes" || $chromiuminstall = "Yes" || $chromiuminstall = "Y" || $chromiuminstall = "y" ]];
		then
			apt-get remove chromium chromium-gost-stable -y
			rm -f /tmp/SXG/*.txt
			rm -f /tmp/SXG/*.rpm
    		echo " "
			echo -e "\e[1;36m0. Производится установка Chromium GOST"
			echo " "
			sleep 3
			curl --proxy $proxyname:$proxyport https://api.github.com/repos/deemru/Chromium-Gost/releases/latest >> ver.txt
       		grep -E '(github.*rpm)' ver.txt >> verF.txt
			sed -i -e 's|.* ||' verF.txt
			sed -i 's/"//g' verF.txt
        	line=$(head  verF.txt)
			echo $line
			echo -e "Имя прокси сервера: $proxyname"
			echo -e "Порт прокси сервера: $proxyport"
			sleep 3
			mkdir /tmp/SXG/chromium
		    wget use_proxy=yes -e https_proxy=$proxyname:$proxyport -P /tmp/SXG/chromium -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.3' https://github.com/deemru/Chromium-Gost/releases/download/133.0.6943.98/chromium-gost-133.0.6943.98-linux-amd64.rpm
		   	rpm -i /tmp/SXG/chromium/chromium-gost*linux-amd64.rpm
			echo -e "\e[1;36m0. Установка Chromium GOST произведена!"
		else
			echo  -e "\033[5m\e[1;31mУстановка Chromium-GOST не произведена! \033[0m"
  		fi
		echo -e "\033[0m "
		echo " "
		echo  "1. Установим КриптоПро CSP"
		echo " "
		sleep 3
		apt-get install -y cryptopro-preinstall
		mkdir /tmp/SXG/cryptopro
		cp /tmp/SXG/linux-amd64.tgz /tmp/SXG/cryptopro
		cd /tmp/SXG/cryptopro/
		tar -xf /tmp/SXG/cryptopro/linux-amd64.tgz
		echo " "
		echo "2. Установим пакеты КриптоПро CSP"
		echo " "
		sleep 3
		cd /tmp/SXG/cryptopro/linux-amd64/
		apt-get install -y cprocsp-curl* lsb-cprocsp-base* lsb-cprocsp-capilite* lsb-cprocsp-kc1-64* lsb-cprocsp-rdr-64* cprocsp-rdr-gui-gtk* cprocsp-rdr-rutoken* cprocsp-rdr-pcsc* lsb-cprocsp-pkcs11* pcsc-lite-rutokens pcsc-lite-ccid cprocsp-rdr-cryptoki* 
		apt-get install cprocsp-cptools*.rpm
		echo " "
		echo "3. Установим сертификаты Головного удостоверяющего центра"
		echo " "
		sleep 3
		apt-get install -y lsb-cprocsp-ca-certs*
		echo " "
		echo "4. Запускаем интерфейс PCSC"
		echo " "
		sleep 3
		systemctl start pcscd
		systemctl enable pcscd
		echo " "
		echo "5. Загружаем и устанавливаем КриптоПро ЭЦП Browser plug-in"
		echo " "
		sleep 3
		wget use_proxy=yes -e https_proxy=$proxyname:$proxyport -P /tmp/SXG/cryptopro/ -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36' https://cryptopro.ru/products/cades/plugin/get_2_0
		cd /tmp/SXG/cryptopro/
		tar -xvf /tmp/SXG/cryptopro/get_2_0
		apt-get install /tmp/SXG/cryptopro/cades-linux-amd64/cprocsp-pki-cades*.rpm
		apt-get install /tmp/SXG/cryptopro/cades-linux-amd64/cprocsp-pki-phpcades*.rpm
		apt-get install /tmp/SXG/cryptopro/cades-linux-amd64/cprocsp-pki-plugin*.rpm
		echo " "
		echo "6. Загружаем и устанавливаем плагин для работы на сайте gosuslugi.ru"
		echo " "
		mkdir /tmp/SXG/plgosuslugi
		sleep 3
		wget use_proxy=yes -e https_proxy=proxy.cit23.ru:3128 -P /tmp/SXG/plgosuslugi/ -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36'  https://ds-plugin.gosuslugi.ru/plugin/upload/assets/distrib/IFCPlugin-x86_64.rpm
		cd /tmp/SXG/plgosuslugi/ 
		apt-get install -y IFCPlugin-x86_64.rpm
		echo " "
		echo "7. Скачиваем ifcx64.cfg"
		echo " "
		sleep 3
		mkdir /tmp/SXG/IFCX
		wget use_proxy=yes -e https_proxy=$proxyname:$proxyport -P /tmp/SXG/IFCX -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.3' www.cryptopro.ru/sites/default/files/public/faq/ifcx64.cfg
		linep=(eval echo ~$username) 
		sudo -u "$username" cp /tmp/SXG/IFCX/ifcx64.cfg /$linep/ifcx64.cfg -rf
		sudo -u "$username" /opt/cprocsp/bin/amd64/csptestf -absorb -certs -autopro
		cp /tmp/SXG/IFCX/ifcx64.cfg /etc/ifc.cfg -rf
		cp /etc/opt/chrome/native-messaging-hosts/ru.rtlabs.ifcplugin.json /etc/chromium/native-messaging-hosts
else
		read -r -p "Устанавливать последнюю версию браузера Chromium GOST (Yes/No): " chromiuminstall
		if [[ $chromiuminstall = "Yes" || $chromiuminstall = "Yes" || $chromiuminstall = "Y" || $chromiuminstall = "y" ]];
		then
		apt-get remove chromium chromium-gost-stable -y
    	echo " "
		echo -e "\e[1;36m0. Производится установка Chromium GOST"
		echo " "
		sleep 3
		curl https://api.github.com/repos/deemru/Chromium-Gost/releases/latest >> ver.txt
        grep -E '(github.*rpm)' ver.txt >> verF.txt
		sed -i -e 's|.* ||' verF.txt
		sed -i 's/"//g' verF.txt
        line=$(head  verF.txt)
		echo " wget $line"		
		sudo -u "$username" wget $line
        rpm -i chromium-gost*linux-amd64.rpm
		echo " "
		echo -e "\e[1;36m0. Установка Chromium GOST произведена!"
		echo " "
		sleep 3
		fi
		echo -e "\033[0m "
		echo " "
		echo  "1. Установим предворительный пакет для работы КриптоПро CSP"
		echo " "
		sleep 3
		apt-get install -y cryptopro-preinstall
		mkdir /tmp/cryptopro
		cp /tmp/SXG/linux-amd64.tgz /tmp/cryptopro
		cd /tmp/cryptopro
		tar -xf /tmp/cryptopro/linux-amd64.tgz
		echo " "
		echo "2. Установим пакеты КриптоПро CSP"
		echo " "
		sleep 3
		cd /tmp/cryptopro/linux-amd64/
		apt-get install -y cprocsp-curl* lsb-cprocsp-base* lsb-cprocsp-capilite* lsb-cprocsp-kc1-64* lsb-cprocsp-rdr-64* cprocsp-rdr-gui-gtk* cprocsp-rdr-rutoken* cprocsp-rdr-pcsc* lsb-cprocsp-pkcs11* pcsc-lite-rutokens pcsc-lite-ccid cprocsp-rdr-cryptoki* 
		apt-get install cprocsp-cptools*.rpm
		echo " "
		echo "3. Установим сертификаты Головного удостоверяющего центра"
		echo " "
		sleep 3
		apt-get install -y lsb-cprocsp-ca-certs*
		echo " "
		echo "4. Запускаем интерфейс PCSC"
		echo " "
		sleep 3
		systemctl start pcscd
		systemctl enable pcscd
		echo " "
		echo "5. Загружаем и устанавливаем КриптоПро ЭЦП Browser plug-in"
		echo " "
		sleep 3
		wget -P /tmp/chromium/ -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36' https://cryptopro.ru/products/cades/plugin/get_2_0
		cd /tmp/chromium/
		tar -xvf /tmp/chromium/get_2_0
		apt-get install /tmp/chromium/cades-linux-amd64/cprocsp-pki-cades*.rpm
		apt-get install /tmp/chromium/cades-linux-amd64/cprocsp-pki-phpcades*.rpm
		apt-get install /tmp/chromium/cades-linux-amd64/cprocsp-pki-plugin*.rpm
		echo " "
		echo "6. Загружаем и устанавливаем плагин для работы на сайте gosuslugi.ru"
		echo " "
		sleep 3
		wget -P /tmp/plgosuslugi/ -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36' https://ds-plugin.gosuslugi.ru/plugin/upload/assets/distrib/IFCPlugin-x86_64.rpm
		cd /tmp/plgosuslugi/ 
		apt-get install -y IFCPlugin-x86_64.rpm
		echo " "
		echo "7. Скачиваем ifcx64.cfg"
		echo " "
		sleep 3
		mkdir /tmp/SXG/IFCX
		sudo -u "$username" wget -P /tmp/SXG/IFCX -U 'Mozilla/5.0 (X11; Linux x86_64; Chromium GOST) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.3' www.cryptopro.ru/sites/default/files/public/faq/ifcx64.cfg
		cd /tmp/SXG/IFCX
		linep=(eval echo ~$username) 
		sudo -u "$username" cp /tmp/SXG/IFCX/ifcx64.cfg /$linep/ifcx64.cfg -rf
		sudo -u "$username" /opt/cprocsp/bin/amd64/csptestf -absorb -certs -autopro
		cp /tmp/SXG/ifcx64.cfg /etc/ifc.cfg -rf
		cp /etc/opt/chrome/native-messaging-hosts/ru.rtlabs.ifcplugin.json /etc/chromium/native-messaging-hosts
fi
echo  -e "\033[5m\e[1;31mУстановка Криптопро CSP 5.0 произведена! \033[0m"
sleep 3