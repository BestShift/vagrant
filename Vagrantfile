# -*- mode: ruby -*-
# vi: set ft=ruby :
# 
unless Vagrant.has_plugin?("vagrant-vbguest")
    raise Vagrant::Errors::VagrantError.new, "Plugin missing: vagrant-vbguest"
end

Vagrant.configure("2") do |config|

  # Number of nodes to provision
  # Please note that you will need to create a new Shared-Node folder
  # if you want to add more nodes
  numNodes = 4 

  # IP Address Base for private network
  ipAddrPrefix = "192.168.148.10"

  # Define Number of RAM for each node
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  # Provision the server with neccessary packages
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "default.pp"
    puppet.module_path = "modules"
  end

  # Download the initial the box with good old Debian
  # config.vm.box_url = "https://atlas.hashicorp.com/debian/boxes/jessie64/versions/8.2.2/providers/virtualbox.box"

  # An SSH-Agent is never a bad idea
  config.ssh.forward_agent = true

  # Provision Config for each of the nodes
  1.upto(numNodes) do |num|
    nodeName = ("bs-node" + num.to_s).to_sym
    config.vm.define nodeName do |node|
      node.vm.box = "debian/jessie64"
      node.vm.hostname = "bestshift-node" + num.to_s + ".dev"
      #node.vm.synced_folder ".", "/var/www", {:mount_options => ['dmode=777','fmode=777']}
      node.vm.network :private_network, ip: ipAddrPrefix + num.to_s
      node.vm.provider "virtualbox" do |v|
        v.name = "BestShift Server Node " + num.to_s
      end
    end
  end
end