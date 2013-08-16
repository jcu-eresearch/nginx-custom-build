#!/bin/sh
sudo mkdir -p ~/rpmbuild/SPECS
sudo rsync --no-relative -vahu /vagrant/*.patch ~/rpmbuild/SPECS/
