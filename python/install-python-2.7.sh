# Installing python 2.7 locally from source on a HPC
mkdir ~/soft

## Install OpenSSL
cd ~/soft
wget https://www.openssl.org/source/openssl-1.1.1b.tar.gz
tar -xzvf openssl-1.1.1b.tar.gz
mv openssl-1.1.1b openssl-1.1.1b-src
cd openssl-1.1.1b-src
./config --prefix=/home/jmonlong/soft/openssl-1.1.1b --openssldir=/home/jmonlong/soft/openssl-1.1.1b
make
make test
make install

## Install zlib (in the end not needed)
# cd ~/soft
# wget https://www.zlib.net/zlib-1.2.11.tar.gz
# tar -xzvf zlib-1.2.11.tar.gz
# mv zlib-1.2.11 zlib-1.2.11-src
# mkdir zlib-1.2.11
# cd zlib-1.2.11-src/
# ./configure
# make test
# make install prefix=/home/jmonlong/soft/zlib-1.2.11

## Install Python
cd ~/soft
wget https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tgz
tar -xzvf Python-2.7.16.tgz
mv Python-2.7.16 Python-2.7.16-src
mkdir Python-2.7.16
cd Python-2.7.16-src
export LDFLAGS="-L/home/jmonlong/soft/openssl-1.1.1b/lib/ -L/home/jmonlong/soft/openssl-1.1.1b/lib64/"
export LD_LIBRARY_PATH="/home/jmonlong/soft/openssl-1.1.1b/lib/:/home/jmonlong/soft/openssl-1.1.1b/lib64/"
export CPPFLAGS="-I/home/jmonlong/soft/openssl-1.1.1b/include -I/home/jmonlong/soft/openssl-1.1.1b/include/openssl"
./configure --prefix=/home/jmonlong/soft/Python-2.7.16 --enable-shared --enable-unicode=ucs4 --enable-optimizations
# –with-zlib=/home/jmonlong/soft/zlib-1.2.11 # if zlib was needed
make
make install

## Install pip
cd ~/soft
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py

