#!/bin/sh

#Install required packages for building
sudo yum install -y \
	rpm-build \
        rpmdevtools \
	yum-utils \
	mercurial \
	git \
	wget

#Install dependencies for Nginx and associated modules
sudo yum install -y \
        libxslt-devel \
        pcre-devel

#Install source RPM for Nginx
pushd ~
echo """[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/6/SRPMS/
gpgcheck=0
enabled=1""" >> nginx.repo
sudo cp nginx.repo /etc/yum.repos.d/
yumdownloader --source nginx
sudo rpm -ihv nginx*.src.rpm
popd


#Get various add-on modules for Nginx
pushd ~/rpmbuild/SOURCES
hg clone https://bitbucket.org/davidjb/ngx_http_auth_request_module
wget https://github.com/agentzh/headers-more-nginx-module/archive/v0.19.tar.gz -O headers-more-nginx-module-0.19.tar.gz
tar xvf headers-more-nginx-module-0.19.tar.gz
git clone https://github.com/aperezdc/ngx-fancyindex.git
git clone https://github.com/yaoweibin/nginx_ajp_module.git
popd

#Prep and patch the Nginx specfile for the RPMs
#Note: expects to have the repository contents located in ~/rpmbuild/SPECS/
#      or located at /vagrant 
pushd ~/rpmbuild/SPECS
if [ -d "/vagrant" ]; then
    rsync --no-relative -vahu /vagrant/* ~/rpmbuild/SPECS/
fi
patch -p1 < nginx-eresearch.patch
spectool -g -R nginx.spec
rpmbuild -ba nginx.spec

#Test installation and check output
sudo yum remove -y nginx nginx-devel
sudo yum install -y ~/rpmbuild/RPMS/*/nginx-*.rpm
nginx -V
