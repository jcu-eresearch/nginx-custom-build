Changes
=======

1.10.x (unreleased)
------------------

* Fix capitalisation of nginx.
* Simplify Docker configuration with Docker Compose.
* Switch to Docker for builds.
* Moved and refactored some of the build script to Docker's RUN layers.
* Change nginx shib module's version to feature nginx's main version.
* Update for nginx 1.10.1.
* Update for nginx 1.9.13.
* Build nginx-http-shibboleth module dynamically into its own RPM package.
* Update all modules to latest compatible versions.

1.6.3-1 (2015-04-09)
--------------------

* Update for Nginx 1.6.3.  Change the way we patch the spec file to avoid
  continuous patch clashes with upstream adding extra SOURCEs.

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
