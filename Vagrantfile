# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box     = "centos-64-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  #Build the custom version of Nginx 
  config.vm.provision :shell, :path => "sync-shared-folder.sh"
  config.vm.provision :shell, :path => "nginx-build.sh"
  config.vm.provision :shell, :path => "copy-rpms-out.sh"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "8"]
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

end
