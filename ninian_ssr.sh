#!/bin/bash
rm -f ninian_ssr.sh
web="http://"; 
webs="https://"; 
error="Authorization failure."; 
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH 
clear; 
cd /
# Logo	******************************************************************
CopyrightLogo='
=============================================================

                          欢迎使用
                           
         \033[31m    逆念 SSr + 流控多用户系统 一键脚本 \033[0m
         逆念官网（ninian.cc）  逆念博客（ninian.cc）  
                 逆念VPN官网（vpn.ninian.cc） 	
                           
                    免流交流群：190290021
                     All Rights Reserved                  
                                                                            
=============================================================';
echo -e "$CopyrightLogo";
# VAR	******************************************************************
MirrorHost='https://raw.githubusercontent.com/CrazyEig/ssr/master';
IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
ServerLocation=``;
#==========================================================================
echo 
echo "脚本支持【centos6.x 64位】系统(如遇到卡住，请耐心等待5-7分钟)"
echo 

# ninian.cc
echo -n "请输入数据库密码(默认ninian.cc)： "
read mysqlpass
if [ -z $mysqlpass ]
then
echo  "数据库密码：ninian.cc"
mysqlpass=ninian.cc
else
        echo "数据库密码：$mysqlpass"
        fi
        echo -n "请输入后台登陆账号，请使用邮箱方式(默认y@ycb.hk)： "
read gly
if [ -z $gly ]
then
echo  "后台账号：y@ycb.hk"
gly=y@ycb.hk
else
        echo "后台账号：$gly"
        fi
        
 echo -n "国内服务器请输入1，国外服务器直接回车： "
read dq
       
        echo -n "请输入SSr连接端口，(默认138)： "
read proxy
if [ -z $proxy ]
then
echo  "SSr连接端口：138"
proxy=138
else

        echo "SSr连接端口：$proxy"
        fi
        echo -n "请输入SSr连接密码密码，(默认ninian.cc)： "
read sspass
if [ -z $sspass ]
then
echo  "SSr连接密码：ninian.cc"
sspass=ninian.cc
else
        echo "SSr连接密码：$sspass"
        fi
        sleep 2
echo "正在部署环境..."
yum install -y git redhat-lsb curl gawk tar httpd-devel unzip sharutils sendmail expect
yum install wget tar gcc gcc-c++ openssl openssl-devel pcre-devel python-devel libevent automake autoconf libtool make -y
# ninain.cc
CO='
=============================================================

                          欢迎使用
                           
           逆念 SSr+流控多用户系统 一键脚本 
         逆念官网（ninian.cc）  逆念博客（ninian.cc）
                 逆念VPN官网（vpn.ninian.cc） 
                           
  \033[31m安装被终止，请在Centos6系统上执行操作\033[0m

                    免流交流群：190290021
                     All Rights Reserved                                      
                                                                            
=============================================================';
version=`lsb_release -a | grep -e Release|awk -F ":" '{ print $2 }'|awk -F "." '{ print $1 }'`
if [ $version == "6" ];then
rpm -ivh ${web}${MirrorHost}/epel-release-6-8.noarch.rpm  >/dev/null 2>&1
rpm -ivh ${web}${MirrorHost}/remi-release-6.rpm  >/dev/null 2>&1
fi
if [ $version == "7" ];then
echo 
    echo "安装被终止，请在Centos6系统上执行操作..."
	echo -e "$CO";
exit
fi
if [ ! $version ];then
    echo 
    echo "安装被终止，请在Centos系统上执行操作..."
	echo -e "$CO";
exit
fi
sleep 1
yum update -y
yum intall -y git
# SSR Installing ****************************************************************************
echo "配置网络环境..."
sleep 3
iptables -F >/dev/null 2>&1
service iptables save >/dev/null 2>&1
service iptables restart >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 3389 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 3306 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 138 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 137 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 9999 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 1194 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 60880 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 3399 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 80 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 22 -j ACCEPT >/dev/null 2>&1
service iptables save
service iptables stop
chkconfig iptables off
# SSR Installing ****************************************************************************
echo "开始安装LAMP环境" 
yum -y install httpd 
chkconfig httpd on
/etc/init.d/httpd start
yum remove -y mysql*
yum --enablerepo=remi install -y mysql mysql-server mysql-devel
chkconfig mysqld on 
service mysqld start
yum remove -y php*
yum install -y --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof php-bcmath php-cli php-common  php-devel php-fpm    php-gd php-imap  php-ldap php-mysql  php-odbc  php-pdo  php-pear  php-pecl-igbinary  php-xml php-xmlrpc php-opcache php-intl php-pecl-memcache
service php-fpm start
service httpd restart
cd /var/www/html
echo "正在下载lamp环境源..."
wget ${web}${MirrorHost}/phpmyadmin.zip  >/dev/null 2>&1
unzip phpmyadmin.zip 
rm -f phpmyadmin.zip
service php-fpm restart
service httpd restart
service mysqld restart
rm -rf /bin/lamp
echo "#!/bin/sh
echo 正在重启lamp服务...
service mysqld restart 
service php-fpm restart 
service httpd restart
echo 服务已启动
exit 0;
" >/bin/lamp
		chmod 0777 /bin/lamp
		service sendmail restart
# SSR Installing libsodium****************************************************************************
cd /root
wget --no-check-certificate -O libsodium-1.0.10.tar.gz http://${MirrorHost}/libsodium-1.0.10.tar.gz >/dev/null 2>&1
tar zxf libsodium-1.0.10.tar.gz
cd libsodium-1.0.10
./configure && make && make install
echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf
ldconfig
# SSR Installing ssr****************************************************************************
cd /root
yum -y install m2crypto python-setuptools

if [[ "$dq" == "1" ]]
then 
wget ${web}${MirrorHost}/pip-1.5.4.tar.gz >/dev/null 2>&1
tar -xzvf pip-1.5.4.tar.gz >/dev/null 2>&1
cd pip-1.5.4 >/dev/null 2>&1
python setup.py install >/dev/null 2>&1
pip install web.py -i http://pypi.mirrors.ustc.edu.cn/simple >/dev/null 2>&1
else
easy_install pip
fi

pip install cymysql
cd /root
wget ${web}${MirrorHost}/SSR.zip  >/dev/null 2>&1
unzip SSR.zip >/dev/null 2>&1
cd shadowsocks 
cp apiconfig.py userapiconfig.py
cp mysql.json usermysql.json
cp config.json user-config.json
sed -i "5s/123456/$mysqlpass/" /root/shadowsocks/usermysql.json >/dev/null 2>&1
cd /root
mysqladmin -u root password $mysqlpass 
mysql -uroot -p$mysqlpass -e"CREATE DATABASE shadowsocks;" 
cd /var/www/html
wget ${web}${MirrorHost}/ss-panel.zip >/dev/null 2>&1
unzip ss-panel.zip >/dev/null 2>&1
rm -rf ss-panel.zip
cd lib/
cp config-simple.php config.php
sed -i "16s/password/$mysqlpass/" /var/www/html/lib/config.php >/dev/null 2>&1
sed -i "33s/first@blood.com/$gly/" /var/www/html/sql/user.sql
sed -i "33s/LoveFish/$sspass/" /var/www/html/sql/user.sql
sed -i "33s/10000/$proxy/" /var/www/html/sql/user.sql
cd /var/www/html/sql
mysql -uroot -p$mysqlpass shadowsocks < invite_code.sql
mysql -uroot -p$mysqlpass shadowsocks < ss_node.sql
mysql -uroot -p$mysqlpass shadowsocks < ss_reset_pwd.sql
mysql -uroot -p$mysqlpass shadowsocks < ss_user_admin.sql
mysql -uroot -p$mysqlpass shadowsocks < user.sql
echo "正在启动SSR服务" 
sleep 1
cd /root/shadowsocks/tests/ >/dev/null 2>&1
bash test.sh >/dev/null 2>&1
cd /root/shadowsocks >/dev/null 2>&1 
chmod +x *.sh >/dev/null 2>&1
./logrun.sh >/dev/null 2>&1
chmod +x /etc/rc.d/rc.local >/dev/null 2>&1
chmod +x /root/shadowsocks/tests/ >/dev/null 2>&1
echo "/root/shadowsocks/run.sh" >/etc/rc.d/rc.local
#rm -rf /bin/SSR >/dev/null 2>&1
#rm -rf /root/shadowsocks/tests/test.sh >/dev/null 2>&1
rm -rf /root/SSR.zip >/dev/null 2>&1
rm -rf /root/libsodium-1.0.10.tar.gz >/dev/null 2>&1
rm -rf /root/libsodium-1.0.10 >/dev/null 2>&1
rm -rf /root/pip-1.5.4.tar.gz >/dev/null 2>&1
rm -rf /root/pip-1.5.4 >/dev/null 2>&1
echo "#!/bin/sh
echo 正在重启SSR服务...
/root/shadowsocks/stop.sh
/root/shadowsocks/run.sh
echo 服务已启动
exit 0;
" >/bin/SSR
		chmod 0777 /bin/SSR
# SSR Installing ****************************************************************************
echo 
echo '=============================================='
echo
echo 用户地址：http://$IPAddress/
echo
echo 管理后台：http://$IPAddress/admin
echo 
echo 你的后台账号：$gly
echo
echo 你的后台密码：ninian.cc
echo
echo 数据库地址：http://$IPAddress/phpmyadmin
echo 
echo 你的数据库账号：root
echo
echo 你的数据库密码：$mysqlpass
echo
echo 连接端口：$proxy
echo
echo 连接密码：$sspass
echo
echo 本地端口：1080
echo
echo 加密方式: chacha20
echo
echo   协 议 : auth_sha1 
echo
echo 混淆方式: http_simple
echo
echo 混淆参数:     
echo        	 例如下面移动的三个混淆参数，用一个即可
echo						   1. wap.10086.cn
echo							 2. wap.10086.cn/r/nX-Online-Host:wap.10086.cn
echo							 3. wap.10086.cn
echo									X-Online-Host:wap.10086.cn
echo
echo lamp快捷重启命令：lamp
echo 
echo SSR快捷重启命令：SSR
echo 
echo 您的IP是：$IPAddress 
echo
echo -e "\033[31mSSR: 理论全网通\033[0m"
echo -e "\033[31m他的功能跟SS差不多,也可以通过代理137,138达到节流的效果\033[0m"
echo -e "\033[31m不过最重要是用来添加伪装，达到全网通的地步\033[0m"
echo -e "\033[31m混淆参数是填伪装，比如你那里wap.10086.cn可以免流，你就直接填上去，就可以了。联通电信同理。\033[0m"
echo -e "\033[31m具体大家自己测试吧,或者加群交流！\033[0m"
echo
echo -e "\033[为了添加端口方便，系统未启用防火墙功能\033[0m"
echo -e "\033[另外，SSR流控对于云免来说，没啥用\033[0m"
echo -e "\033[最多看某个端口用了多少流量，因为免流也是靠端口\033[0m"
echo -e "\033[而SSR的端口就相当于登录的账号，只能对端口限制\033[0m"
echo
Client='
=============================================================

                          欢迎使用
                           
         逆念官网（ninian.cc）  逆念博客（ninian.cc）
                 逆念VPN官网（vpn.ninian.cc） 	
                           
                \033[31mSSr + 流控多用户系统 安装完毕\033[0m

                    免流交流群：190290021
                     All Rights Reserved                        
                                                                            
=============================================================';
echo -e "$Client";
exit 0;
# SSR Installation Complete ****************************************************************************