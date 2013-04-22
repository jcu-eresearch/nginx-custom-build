#!/bin/sh
pushd ~/rpmbuild/SOURCES
hg clone https://bitbucket.org/davidjb/ngx_http_auth_request_module
wget https://github.com/agentzh/headers-more-nginx-module/archive/v0.19.tar.gz -O headers-more-nginx-module-0.19.tar.gz
tar xvf headers-more-nginx-module-0.19.tar.gz
git clone git://github.com/davidjb/ngx-fancyindex.git
git clone git://github.com/yaoweibin/nginx_ajp_module.git
popd
pushd ~/rpmbuild/SPECS
patch -p1 < nginx-eresearch.patch
spectool -g -R nginx.spec
rpmbuild -ba nginx.spec
#yum install 
