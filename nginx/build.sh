#
# 获取当前脚本所在路径
run_dir=$(cd $(dirname $0) && pwd)

output_dir=$run_dir/output/

nginx_name=nginx-1.13.1
nginx_dir=$run_dir/$nginx_name/

pcre_name=pcre-8.35
pcre_dir=$run_dir/$pcre_name/

prefix_dir=/home/work/gateway/nginx/

# tar
tar -zxvf nginx-1.13.1.tar.gz

tar -zxvf pcre-8.35.tar.gz

# pcre
cd $pcre_dir
./configure --prefix=$pcre_dir/output

# build nginx
cd $nginx_dir
./configure --prefix=$prefix_dir --with-pcre=$pcre_dir
make

cd $run_dir

# cp files
rm -rf $output_dir
mkdir $output_dir

mkdir -p $output_dir/logs
mkdir -p $output_dir/var
mkdir -p $output_dir/cache
mkdir -p $output_dir/sbin

cp $nginx_dir/objs/nginx $output_dir/sbin
cp -R $nginx_dir/conf/ $output_dir

cp $run_dir/resource/control.sh  $output_dir
cp -R $run_dir/resource/html $output_dir

# 修改过的nginx.conf，覆盖NGINX原始配置.
cp -R $rurn_dir/resource/conf/ $output_dir

# remove tmp files

rm -rf $nginx_dir
rm -rf $pcre_dir


