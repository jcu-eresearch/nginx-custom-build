# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  if ENV['TRAVIS'] == "true"
    config.vm.box     = "centos-6.7-i386-jcu"
    config.vm.box_url = "https://www.hpc.jcu.edu.au/boxes/centos-6.7-i386-virtualbox.box"
  else
    config.vm.box     = "centos-6.7-x86_64-jcu"
    config.vm.box_url = "https://www.hpc.jcu.edu.au/boxes/centos-6.7-x86_64-virtualbox.box"
  end

  config.vm.network :private_network, ip: "33.33.33.10"

  #Build the custom version of Nginx 
  config.vm.provision :shell, :path => "nginx-build.sh"
  config.vm.provision :shell, :path => "copy-rpms-out.sh"

  config.vm.provider :virtualbox do |vb|
    vb.name = "vagrant-nginx-custom-build"
    vb.customize ["modifyvm", :id, "--cpus", "1"]
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

end
