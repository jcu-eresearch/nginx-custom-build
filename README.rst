About this Nginx
================

.. image:: https://travis-ci.org/jcu-eresearch/nginx-custom-build.svg?branch=master
   :target: https://travis-ci.org/jcu-eresearch/nginx-custom-build

.. important::
   This Nginx build currently supports version 1.10.0+.  Please see the
   tags within this repository for previously supported versions
   (``v1.4.x``, ``v1.6.3``, ``v1.8.x``, etc).

This version of Nginx is customised in a number of different ways:

* Adds support for Shibboleth authentication for applications served
  by Nginx using the `nginx-http-shibboleth
  <https://github.com/nginx-shib/nginx-http-shibboleth>`_ module. This
  requires a Shibboleth SP built with FastCGI support and correctly
  configured.

  This is built as a dynamic module and deployable using its own RPM package.
* Adds LDAP authentication for Nginx using `nginx-ldap-auth
  <https://github.com/kvspb/nginx-auth-ldap>`_.
* Has custom HTML XSLT transformation built in. This allows 
  transformation of HTML documents on-the-fly via XSL (eg that which
  comes from `Diazo <http://diazo.org>`_ for theming).  Help support
  the `patch being merged <https://trac.nginx.org/nginx/ticket/609>`_
  into Nginx's core.
* Has the ``ngx-fancyindex`` module for folder listings.
* Has the ``ngx_ajp_module`` module for talking to AJP backends.
* Has HTTP/2 support built
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
on your own EL 6 machine.  The script will automatically clone the latest
patches from this GitHub repository.

This Vagrant configuration in ``master`` will always build the **latest
stable** version of Nginx.  Occasionally, mainline compatible versions will be
present; consult available branches.

It is also possible to select a specific version of Nginx to build against by
setting the environment variable `_NGINX_VERSION` (such as
``export _NGINX_VERSION=1.9.13``).



Credits
=======

* Thanks to `Luca Bruno <https://github.com/lucab>`_ for taking my Shibboleth
  work and creating a full Nginx module.
* Thanks to Laurence Rowe for the patches for making HTML transformations
  possible at https://bitbucket.org/lrowe/nginx-xslt-html-parser
