#!/bin/sh

#Clean up old nginx builds
sudo rm -rf ~/rpmbuild/RPMS/*/nginx-*.rpm

#Install required packages for building
sudo yum install -y \
    rpm-build \
    rpmdevtools \
    yum-utils \
    mercurial \
    git \
    wget


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

#Headers More module
git clone https://github.com/agentzh/headers-more-nginx-module.git -b v0.25

#Fancy Index module
git clone https://github.com/aperezdc/ngx-fancyindex.git -b v0.3.4

#AJP module
git clone https://github.com/yaoweibin/nginx_ajp_module.git -b v0.3.0

#LDAP authentication module
git clone https://github.com/kvspb/nginx-auth-ldap.git

#Shibboleth module
git clone https://github.com/nginx-shib/nginx-http-shibboleth.git

popd

#Prep and patch the Nginx specfile for the RPMs
#Note: expects to have the repository contents located in ~/rpmbuild/SPECS/
#      or located at /vagrant 
pushd ~/rpmbuild/SPECS
if [ -d "/vagrant" ]; then
    cp /vagrant/nginx-eresearch.patch ~/rpmbuild/SPECS/
    cp /vagrant/nginx-xslt-html-parser.patch ~/rpmbuild/SOURCES/
fi
patch -p1 < nginx-eresearch.patch
spectool -g -R nginx.spec
yum-builddep -y nginx.spec
rpmbuild -ba nginx.spec

#Test installation and check output
sudo yum remove -y nginx nginx-devel
sudo yum install -y ~/rpmbuild/RPMS/*/nginx-*.rpm
nginx -V
