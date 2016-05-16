#!/bin/bash
echo "Hizli kullanim : $0 domain.com \"kullaniciadi\" \"sifre\" "
echo "user pass kisminda tirnaklari unutmayiniz, copy paste sorunu olabileceginden manuel yazmaniz tercih edilir. !!!!"
echo "mkpasswd ile olusturulan sifre kullanilabilir"

if [$1 = '']; then
echo "Cikmak icin [Enter]"
printf "\033[0;33m domain.com \033[0m seklinde domain ismi:"
read -r domainname

if [$domainname = '']; then
exit 0
fi

echo "Kullanici Adi :"
read -r username

printf "Sifre \033[0;33m (makepasswd ile olusturulmus)\033[0m:"
read -r password

else
domainname = $1
username = $2
password = $3
fi

mkdir /var/www/$domainname
mkdir /var/www/$domainname/public_html
printf "\n [/var/www/$domainname/public_html dizini olusturuldu]"
cp /root/index.html /var/www/$domainname/public_html/index.html
chown -R $username:ftp /var/www/$domainname/public_html/index.html
chmod -R 755 /var/www/$domainname/public_html/index.html

chmod -R 555 /var/www/$domainname
chmod -R 755 /var/www/$domainname/public_html
printf "\n [klasor izinleri ayarlandi]"

echo 192.168.1.1 $domainname $( echo $domainname | sed -e "s/\.com//g" ) >> /etc/hosts
printf "\n [domain hosts dosyasina eklendi]"

sed -e "s/template\.com\.tr/$domainname/g" /etc/apache2/sites-available/template.com.tr.conf > /etc/apache2/sites-available/$domainname.conf

a2ensite $domainname

service apache2 restart

useradd -g ftp $username -p $password
usermod -d /var/www/$domainname $username
service vsftpd restart
chown -R $username:ftp /var/www/$domainname
chmod a-w /var/www/$domainname

printf "\n domain : \033[0;37m $domainname \033[0m \n kullanici : \033[0;37m $username \033[0m \n Sifre :"
echo $password

################################################
# 192.168.1.1                              #
# IP adresini kendinize göre değiştirin        #
#                                              #
# !! userdel -r kullaniciadi ile kullanici ve  #
# dizini silinebilir.                          #
# sonra sites-available ve sites-enabled       #
# altindaki conf dosyalari silinmeli           #
# yaptiginiz iyilestirmeleri lutfen            #
# eren@kesdi.com adresine gonderiniz           #
#                                              #
################################################
