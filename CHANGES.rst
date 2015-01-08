Changes
=======

1.6.2-1 (2015-01-08)
--------------------

* **Backwards incompatibility**: replace patched auth request module with
  Shibboleth module for Nginx
  (https://github.com/nginx-shib/nginx-http-shibboleth).  Nginx configurations
  must be adjusted to suit this new version!
* Update to Nginx 1.6.2-2.

1.6.0-1 (2014-04-30)
--------------------

* Update Vagrant configuration for CentOS 6.5.
  [davidjb]
* Update to Nginx 1.6:

  + Update patch for Nginx specfile
  + Update auth-request-module patch for Nginx 1.5.4+ (module is now part of
    Nginx core)
  + Update HTML XSLT parser patch for Nginx 1.6.0

1.4.x (2014-03-19)
------------------

* Add LDAP authentication module for Nginx.
  [davidjb]
