About this Nginx
================

This version of Nginx is customised in a number of different ways:

* *New*: adds LDAP authentication for Nginx using `nginx-ldap-auth
  <https://github.com/davidjb/nginx-auth-ldap>`_ (custom fork featuring
  signficant authentication fix).
* Has custom HTML XSLT transformation built in. This allows 
  transformation of HTML documents on-the-fly via XSL (eg that which
  comes from `Diazo <http://diazo.org>`_ for theming).
* Has a custom version of ``ngx_http_auth_request_module`` that supports 
  a flavour of FastCGI "authorizer" that passes authorizer headers to
  as incoming headers to an upstream backend (proxy, uWGSI, FastCGI, etc).
* Has the ``ngx-fancyindex`` module for folder listings.
* Has the ``ngx_ajp_module`` module for talking to AJP backends.
* Has XLST support built.
* Has SPDY support built (depends on OpenSSL 1.0.1e being installed). TBA.

See the build script for details of where these dependencies live.

Building Nginx
==============

#. Ensure Vagrant is installed.

#. Run the following::

       git clone https://github.com/jcu-eresearch/nginx-custom-build.git
       cd nginx-custom-build
       vagrant up; vagrant destroy -f
       ls x86_64

#. Enjoy your new RPMs, available in the current directory.

If you're not into Vagrant, then you can manually run 
https://github.com/jcu-eresearch/nginx-custom-build/blob/master/nginx-build.sh
on your own EL 6 machine, ensuring that you have the ``*.patch`` files
from this repository in your ``~/rpmbuild/SPECS`` directory.

This Vagrant configuration will always build the **latest stable** version
of Nginx.

Credits
=======

* Thanks to Laurence Rowe for the patches for making HTML transformations
  possible at https://bitbucket.org/lrowe/nginx-xslt-html-parser

