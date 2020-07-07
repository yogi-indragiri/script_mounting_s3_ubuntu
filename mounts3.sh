#!/bin/bash

read -p "Bucket name : " bucket_name;
read -p "Access Key : " access_key;
read -p "Secret Key : " secret_key;
read -p "Region : " region;

sudo apt-get update

sudo apt-get install -y automake autotools-dev fuse g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config

git clone https://github.com/s3fs-fuse/s3fs-fuse.git

cd s3fs-fuse
./autogen.sh
./configure --prefix=/usr --with-openssl
make
sudo make install

echo "is instalation okay ??"

sudo which s3fs

cd

sudo touch /etc/passwd-s3fs

sudo echo $access_key:$secret_key > /etc/passwd-s3fs

sudo chmod 640 /etc/passwd-s3fs

#create bucket folder
sudo mkdir /mys3bucket

sudo s3fs $bucket_name /mys3bucket -o use_cache=/tmp -o allow_other -o uid=1001 -o mp_umask=002 -o multireq_max=5 -o use_path_request_style -o url=https://s3-$region.amazonaws.com

sudo which s3fs /usr/local/bin/s3fs

sudo touch /etc/rc.local

sudo echo "s3fs $bucket_name /mys3bucket -o use_cache=/tmp -o allow_other -o uid=1001 -o mp_umask=002 -o multireq_max=5 -o use_path_request_style -o url=https://s3-$region.amazonaws.com" > /etc/rc.local

#check bucket
df -Th /mys3bucket
