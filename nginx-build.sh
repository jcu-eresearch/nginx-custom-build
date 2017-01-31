#!/bin/bash

# Create directories if not already present
mkdir -p ~/rpmbuild/{SPECS,SOURCES}

# Obtain a location for the patches, either from /app (Docker)
# or cloned from GitHub (if run stand-alone).
if [ -d '/app' ]; then
    patch_dir='/app'
else
    patch_dir=$(mktemp)
    git clone https://github.com/jcu-eresearch/nginx-custom-build.git "$patch_dir"
fi
cp "$patch_dir/nginx-centos-6.repo" /etc/yum.repos.d/
cp "$patch_dir/nginx-eresearch.patch" ~/rpmbuild/SPECS/
cp "$patch_dir/nginx-xslt-html-parser.patch" ~/rpmbuild/SOURCES/
# Remove temp directory if not Docker
if ! [ -d '/app' ]; then
    rm -rf "$patch_dir"
fi

# Download specific nginx version or just the latest version
if [ "$_NGINX_VERSION" ]; then
    yumdownloader --source "nginx-$_NGINX_VERSION"
else
    yumdownloader --source nginx
fi
if ! [ $? -eq 0 ]; then
    echo "Couldn't download nginx source RPM. Aborting build."
    exit 1
fi

sudo rpm -ihv nginx*.src.rpm

#Get various add-on modules for nginx
#XXX git clone -b [tag] isn't supported on git 1.7 (RHEL 6)
pushd ~/rpmbuild/SOURCES

    #Headers More module
    git clone https://github.com/openresty/headers-more-nginx-module
    pushd headers-more-nginx-module
    git checkout v0.30rc1
    popd

    #Fancy Index module
    git clone https://github.com/aperezdc/ngx-fancyindex.git
    pushd ngx-fancyindex
    git checkout ba8b4ec
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
    pushd nginx-http-shibboleth
    git checkout development
    popd

    #PAM module
    git clone https://github.com/stogh/ngx_http_auth_pam_module.git
    pushd ngx_http_auth_pam_module
    git checkout f5d706a
    popd

popd

#Prep and patch the nginx specfile for the RPMs
pushd ~/rpmbuild/SPECS
    patch -p1 < nginx-eresearch.patch
    spectool -g -R nginx.spec
    yum-builddep -y nginx.spec
    rpmbuild -ba nginx.spec

    if ! [ $? -eq 0 ]; then
        echo "RPM build failed. See the output above to establish why."
        exit 1
    fi
popd
