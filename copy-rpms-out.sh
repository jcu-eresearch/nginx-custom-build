#!/bin/sh

#Copy the RPMs out and back to the shared folder
cd /vagrant
rsync --no-relative -vahu ~/rpmbuild/RPMS ~/rpmbuild/SRPMS .

