#
# 获取当前脚本所在路径
run_dir=$(cd $(dirname $0) && pwd)

output_dir=$run_dir/output/

php_name=php-5.6.31
php_dir=$run_dir/$php_name/

prefix_dir=/home/work/gateway/php/

# tar
tar -zxvf php-5.6.31.tar.gz

# build nginx
cd $php_dir
./configure --prefix=$prefix_dir --with-mysqli  --enable-libxml --enable-xml --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --enable-opcache --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext -enable-session --with-curl --enable-ctype

make 

make install 

cd $run_dir

# cp files
rm -rf $output_dir

mv $prefix_dir $output_dir

# copy conf files
cp $php_dir/php.ini-production  $output_dir/php.ini
cp $output_dir/etc/php-fpm.conf.default $output_dir/etc/php-fpm.conf

# copy 执行脚本
cp $php_dir/sapi/fpm/init.d.php-fpm $output_dir/php-fpm.sh
chmod +x $output_dir/php-fpm

# remove tmp files
rm -rf $php_dir

# 启动命令
# $output_dir/php-fpm start
# $output_dir/php-fpm stop

# 如果启动所在目录不是上面指定的目录,即$prefix_dir
# 则需要修改如下文件中的路径：
# 1) $output_dir/php-fpm.sh ：prefix=
# 2) $output_dir/etc/php-fpm.conf : error_log =


# 配置修改
# vim /app/php/etc/php-fpm.conf
# user = www
# group = www
# pid = run/php-fpm.pid

# vim /app/php/etc/php.ini 
# disable_functions = passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,escapeshellcmd,dll,popen,disk_free_space,checkdnsrr,checkdnsrr,getservbyname,getservbyport,disk_total_space,posix_ctermid,posix_get_last_error,posix_getcwd, posix_getegid,posix_geteuid,posix_getgid, posix_getgrgid,posix_getgrnam,posix_getgroups,posix_getlogin,posix_getpgid,posix_getpgrp,posix_getpid, posix_getppid,posix_getpwnam,posix_getpwuid, posix_getrlimit, posix_getsid,posix_getuid,posix_isatty, posix_kill,posix_mkfifo,posix_setegid,posix_seteuid,posix_setgid, posix_setpgid,posix_setsid,posix_setuid,posix_strerror,posix_times,posix_ttyname,posix_uname    #列出PHP可以禁用的函数，如果某些程序需要用到这个函数，可以删除，取消禁用。
# date.timezone = PRC   #设置时区
#expose_php = Off      #禁止显示php版本的信息
#short_open_tag = ON   #支持php短标签
#opcache.enable=1      #php支持opcode缓存
#opcache.enable_cli=1  #php支持opcode缓存
#zend_extension=opcache.so   #文末添加此行，开启opcode缓存功能

# 添加NGINX转发
# vim /app/nginx/conf/nginx.conf
#    user  www www;   #首行user去掉注释,修改Nginx运行组为www www；必须与/usr/local/php/etc/php-fpm.conf中的user,group配置相同，否则php运行出错
#        location / {
#            root   html;
#            index  index.html index.htm index.php;   #添加index.php
#        }
#        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
#        #取消FastCGI server部分location的注释,
#        location ~ \.php$ {
#            root           html;
#            fastcgi_pass   127.0.0.1:9000;
#            fastcgi_index  index.php;
#            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;   #fastcgi_param行的参数,改为$document_root$fastcgi_script_name,或者使用绝对路径
#            include        fastcgi_params;
#        } 
