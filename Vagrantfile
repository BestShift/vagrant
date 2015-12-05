# -*- mode: ruby -*-
# vi: set ft=ruby :

MANIFEST_LOCATION = "./puppet/manifest"
MODULE_LOCATION = "./puppet/modules"
SCRIPT_LOCATION = "./scripts"

unless Vagrant.has_plugin?("vagrant-vbguest")
    raise Vagrant::Errors::VagrantError.new, "Plugin missing: vagrant-vbguest - please install via vagrant plugin install"
end

if ARGV[0] == "up" && !ARGV[1]
  puts "Welcome to the BestShift CPOS - initializing...."
end

Vagrant.configure("2") do |config|

    # Create the box based on good old Debian 8
    config.vm.box = "debian/wheezy64"

    # Setting the hostname
    config.vm.hostname = "bestshift.dev"

    # Oh you wonderful SSH
    # config.ssh.private_key_path = "~/.ssh/id_rsa"  # If you want to use your own key, uncomment
    config.ssh.forward_agent = true

    # Configure RAM used and enable the DNS Resolver
    config.vm.provider "virtualbox" do |v|
        v.name = "BestShift CPOS"
        v.customize ["modifyvm", :id, "--ioapic", "on"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 512]
    end
        
    
    # Forward a port from the guest to the host, which allows for outside
    # computers to access the VM, whereas host only networking does not.
    config.vm.network "forwarded_port", guest: 80, host: 8080
    
    # Share an additional folder to the guest VM. The first argument is
    # the path on the guest to mount the folder, and the second is the 
    # path on the host to the actual folder.
    config.vm.synced_folder "shared", "/vagrant"
    config.vm.synced_folder "data", "/vagrant-data"
    
    # Enable provisioning with a shell script.
    #config.vm.provision :shell, :path => "bootstrap.sh"
    
    # Install puppet if necessary (sometimes Vagrant doesn't install it)
    config.vm.provision "shell", path: "./scripts/puppet.sh"

    # Install our required packages
    config.vm.provision :shell do |shell|
        shell.inline = "puppet module install puppetlabs/stdlib --force --modulepath '/vagrant/puppet/modules'"
        shell.inline = "puppet module install puppetlabs/concat --force --modulepath '/vagrant/puppet/modules'"
        shell.inline = "puppet module install puppetlabs/apt --force --modulepath '/vagrant/puppet/modules'"
        shell.inline = "puppet module install puppetlabs/vcsrepo --force --modulepath '/vagrant/puppet/modules'"
        shell.inline = "puppet module install jfryman/nginx --force --modulepath '/vagrant/puppet/modules'"
        shell.inline = "puppet module install daenney/pyenv --force --modulepath '/vagrant/puppet/modules'"
        shell.inline = "puppet module install jlondon/couchbase --force --modulepath '/vagrant/puppet/modules'"
        shell.inline = "puppet module install puppetlabs/postgresql --force --modulepath '/vagrant/puppet/modules'"
    end

    # Provision to the point of the base system
    config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = MANIFEST_LOCATION  
      puppet.module_path = MODULE_LOCATION
      puppet.manifest_file = "default.pp"
      puppet.options="--verbose --debug"   # For debugging, disable once in production
    end
end