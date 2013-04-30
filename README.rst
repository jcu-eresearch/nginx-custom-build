About this Nginx
================

This version of Nginx is customised in a number of different ways:

* Has a custom version of ``ngx_http_auth_request_module`` that supports 
  FastCGI authorizers.
* Has the ``ngx-fancyindex`` module for folder listings.
* Has the ``ngx_ajp_module`` module for talking to AJP backends.
* Has XLST support built.
* Has SPDY support built (depends on OpenSSL 1.0.1e being installed). TBA.

See the build script for details of where these dependencies live.

Building Nginx for eResearch
============================

* Clone this repository or copy files into ``~/rpmbuild/SPECS``.
* Install Nginx SRPM::

      rpm -ihv http://nginx.org/packages/rhel/6/SRPMS/nginx-1.4.0-1.el6.ngx.src.rpm
* Run ``./nginx-build.sh`` and it will download dependencies and build
  the package accordingly.
* Your RPMs will be produced and will be available within
  ``~/rpmbuild/RPMS/``.
