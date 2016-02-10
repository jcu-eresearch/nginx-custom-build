#!/bin/bash

#Clean up old nginx builds
sudo rm -rf ~/rpmbuild/RPMS/*/nginx-*.rpm

#Install required packages for building
sudo yum groupinstall -y 'Development tools'
sudo yum install -y \
    rpm-build \
    rpmdevtools \
    yum-utils \
    mercurial \
    git \
    wget


#Install source RPM for Nginx
pushd ~
echo """[nginx-source]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/6/SRPMS/
gpgcheck=0
enabled=1""" > nginx.repo
sudo mv nginx.repo /etc/yum.repos.d/
rm -rf nginx*.src.rpm
yumdownloader --source nginx

if ! [ $? -eq 0 ]; then
    echo "Couldn't download Nginx source RPM. Aborting build."
    exit 1
fi

sudo rpm -ihv nginx*.src.rpm
popd


#Get various add-on modules for Nginx
#XXX git clone -b [tag] isn't supported on git 1.7 (RHEL 6)
pushd ~/rpmbuild/SOURCES

    #Headers More module
    git clone https://github.com/openresty/headers-more-nginx-module
    pushd headers-more-nginx-module
    git checkout v0.29
    popd

    #Fancy Index module
    git clone https://github.com/aperezdc/ngx-fancyindex.git
    pushd ngx-fancyindex
    git checkout 80db501
    popd

    #AJP module
    git clone https://github.com/yaoweibin/nginx_ajp_module.git
    pushd nginx_ajp_module
    git checkout bf6cd93
    popd

    #LDAP authentication module
    git clone https://github.com/kvspb/nginx-auth-ldap.git
    pushd nginx-auth-ldap
    git checkout d0f2f82
    popd

    #Shibboleth module
    git clone https://github.com/nginx-shib/nginx-http-shibboleth.git

popd

# Obtain a location for the patches, either from /vagrant
# or cloned from GitHub (if run stand-alone).
if [ -d '/vagrant' ]; then
    patch_dir='/vagrant'
else
    patch_dir=$(mktemp)
    git clone https://github.com/jcu-eresearch/nginx-custom-build.git "$patch_dir"
fi
cp "$patch_dir/nginx-eresearch.patch" ~/rpmbuild/SPECS/
cp "$patch_dir/nginx-xslt-html-parser.patch" ~/rpmbuild/SOURCES/
# Remove temp directory if not Vagrant
if ! [ -d '/vagrant' ]; then
    rm -rf "$patch_dir"
fi

#Prep and patch the Nginx specfile for the RPMs
pushd ~/rpmbuild/SPECS
patch -p1 < nginx-eresearch.patch
spectool -g -R nginx.spec
yum-builddep -y nginx.spec
rpmbuild -ba nginx.spec

if ! [ $? -eq 0 ]; then
    echo "RPM build failed. See the output above to establish why."
    exit 1
fi

#Test installation and check output
sudo yum remove -y nginx nginx-debug
sudo yum install -y ~/rpmbuild/RPMS/*/nginx-*.rpm
nginx -V
