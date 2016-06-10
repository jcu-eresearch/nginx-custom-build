About this nginx
================

.. image:: https://travis-ci.org/jcu-eresearch/nginx-custom-build.svg?branch=master
   :target: https://travis-ci.org/jcu-eresearch/nginx-custom-build

.. important::
   This nginx build currently supports version 1.10.0+.  Please see the
   tags within this repository for previously supported versions
   (``v1.4.x``, ``v1.6.3``, ``v1.8.x``, etc).

This version of nginx is customised in a number of different ways:

* Adds support for Shibboleth authentication for applications served
  by nginx using the `nginx-http-shibboleth
  <https://github.com/nginx-shib/nginx-http-shibboleth>`_ module. This
  requires a Shibboleth SP built with FastCGI support and correctly
  configured.

  This is built as a dynamic module and deployable using its own RPM package.
* Adds LDAP authentication for nginx using `nginx-ldap-auth
  <https://github.com/kvspb/nginx-auth-ldap>`_.
* Has custom HTML XSLT transformation built in. This allows 
  transformation of HTML documents on-the-fly via XSL (eg that which
  comes from `Diazo <http://diazo.org>`_ for theming).  Help support
  the `patch being merged <https://trac.nginx.org/nginx/ticket/609>`_
  into nginx's core.
* Has the ``ngx-fancyindex`` module for folder listings.
* Has the ``ngx_ajp_module`` module for talking to AJP backends.
* Has HTTP/2 support built
* Has XLST support built.

See the build script for details of where these dependencies live.

Building nginx
==============

#. Ensure `Docker <https://docs.docker.com/>`_ and `Docker Compose
   <https://docs.docker.com/compose>`_ are installed.

#. Run the following::

       git clone https://github.com/jcu-eresearch/nginx-custom-build.git
       cd nginx-custom-build
       docker-compose up

#. Enjoy your new RPMs, available in the `build/` directory.

If you're not into Docker, then you can manually run
https://github.com/jcu-eresearch/nginx-custom-build/blob/master/nginx-build.sh
on your own EL 6 machine, ensuring that you set up your build environment
first. You can follow the `Dockerfile
<https://github.com/jcu-eresearch/nginx-custom-build/blob/master/Dockerfile>`_
and its ``RUN`` commands.  Otherwise, the build script is self-contained and
will automatically clone the latest patches from this GitHub repository.

The configuration in ``master`` will always build the **latest
stable** version of nginx.  Occasionally, mainline compatible versions will be
present; consult available branches.

It is also possible to select a specific version of nginx to build against by
setting the environment variable `_NGINX_VERSION` (such as
``export _NGINX_VERSION=1.9.13``), which is used within the build script.
From Docker Compose, you can use the following::

    docker-compose run -e _NGINX_VERSION=1.8.1 nginx-custom-build

Credits
=======

* Thanks to `Luca Bruno <https://github.com/lucab>`_ for taking my Shibboleth
  work and creating a full nginx module.
* Thanks to Laurence Rowe for the patches for making HTML transformations
  possible at https://bitbucket.org/lrowe/nginx-xslt-html-parser
