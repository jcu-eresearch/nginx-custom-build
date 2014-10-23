About this Nginx
================

.. important::
   This Nginx build currently supports version 1.6.x.  Please see the
   tags within this repository for previously supported versions
   (``1.4.x``).

This version of Nginx is customised in a number of different ways:

* Has SPDY support built (depends on OpenSSL 1.0.1 being installed)
* Adds LDAP authentication for Nginx using `nginx-ldap-auth
  <https://github.com/kvspb/nginx-auth-ldap>`_.
* Has custom HTML XSLT transformation built in. This allows 
  transformation of HTML documents on-the-fly via XSL (eg that which
  comes from `Diazo <http://diazo.org>`_ for theming).
* Has a custom version of ``ngx_http_auth_request_module`` that supports 
  a flavour of FastCGI "authorizer" that passes authorizer headers to
  as incoming headers to an upstream backend (proxy, uWGSI, FastCGI, etc).
* Has the ``ngx-fancyindex`` module for folder listings.
* Has the ``ngx_ajp_module`` module for talking to AJP backends.
* Has XLST support built.

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


Testing and debugging the Authorizer patch
==========================================

The following Nginx configuration is best placed in your ``/etc/nginx/nginx.conf``
file, replacing anything that's already there.  The configuration configures
Nginx for debugging, and when ``nginx.debug`` (from the ``nginx-debug`` package
I/you have built) is run, will cascade all debug messages into the console.

If you're specifically interested in the authorizer module, watch the output
for comments consisting of ``auth request authorizer`` (and ``auth request``
in general.  Using the configuration below, you can make a simple request 
to make the auth request authorizer work::

    curl -i http://localhost/

``nginx.conf``::

   worker_processes 1;
   daemon off;
   master_process off;
   error_log stderr debug;
   
   events {
       worker_connections 1024;
   }
   
   server {
               listen 80 default_server;
    
               location / {
                  # Swap these lines around to test.
                   auth_request /noauth authorizer=on;
                   #auth_request /noauth-redir authorizer=on;
                   #auth_request /auth authorizer=on;
               }
               location /auth {
                   more_set_headers "Variable-Email: david@example.org";
                   more_set_headers "Variable-Cn: davidjb";
                   return 200 'Authenticated';
               }
               location /noauth {
                   return 401 'Not authenticated';
               }
               location /noauth-redir {
                   return 301 http://davidjb.com;
               }
   }
   

Tests
-----

#. With the ``/noauth`` line used, a 401 **must** be returned.
#. With the ``/noauth-dir`` line used, the correct 301 **must** be returned.
#. With the final ``/auth`` line used, a 404 will correctly result.
   Check the console output from ``nginx.debug`` and make sure you see lines
   stating ``auth request authorizer copied header:``.
   
If any of the above don't behave exactly like this, the patch probably needs
to be updated!


Credits
=======

* Thanks to Laurence Rowe for the patches for making HTML transformations
  possible at https://bitbucket.org/lrowe/nginx-xslt-html-parser

