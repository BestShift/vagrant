# -*- mode: ruby -*-
# vi: set ft=ruby :

unless Vagrant.has_plugin?("vagrant-vbguest")
    raise Vagrant::Errors::VagrantError.new, "Plugin missing: vagrant-vbguest"
end

Vagrant.configure("2") do |config|

    # Create the box based on good old Debian 8
    config.vm.box = "debian/wheezy64"

    # Setting the hostname
    config.vm.hostname = "bestshift.dev"

    # An SSH Agend is never wrong
    config.ssh.forward_agent = true

    # Configure RAM used and enable the DNS Resolver
    config.vm.provider "virtualbox" do |v|
        v.name = "BestShift CPOS"
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 512]
    end
        
    
    # Forward a port from the guest to the host, which allows for outside
    # computers to access the VM, whereas host only networking does not.
    config.vm.network "forwarded_port", guest: 80, host: 8080
    
    # Share an additional folder to the guest VM. The first argument is
    # an identifier, the second is the path on the guest to mount the
    # folder, and the third is the path on the host to the actual folder.
    config.vm.synced_folder "data", "/vagrant"
    
    # Enable provisioning with a shell script.
    config.vm.provision :shell, :path => "bootstrap.sh"
end