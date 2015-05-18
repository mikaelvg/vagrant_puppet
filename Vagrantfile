# -*- mode: ruby -*-
# vi: set ft=ruby :

#
v_domain = 'mylocalservers.com'


# Select the specific operating system listed in http://www.vagrantbox.es/. In this example, We will use Ubuntu 14.10 
# For faster provisioning of VM servers. Download the box file locally then replace the value of v_boxsource below.

#v_boxsource = '/C/Users/mikael/Downloads/utopic-server-cloudimg-amd64-vagrant-disk1.box' # Use this intead. # SAMPLE
#v_boxsource = 'https://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-amd64-vagrant-disk1.box'
v_boxname = 'ubuntu-14.10'

puppet_nodes = [
  {:hostname => 'puppet',  :ip => '192.101.21.10', :box => v_boxname, :forward_host => 8140, :forward_guest => 8140, :ram => 1024},
  {:hostname => 'client1', :ip => '192.101.21.11', :box => v_boxname},
  # To add more servers, simply copy the line above and modify the values. Ex. {:hostname => 'client2', :ip => '192.101.20.13', :box => v_boxname, :ram => 256},
]

Vagrant.configure("2") do |config|

  puppet_nodes.each do |puppet_node|
    config.vm.define puppet_node[:hostname] do |node_config|
      node_config.vm.box = puppet_node[:box]
      node_config.vm.hostname = puppet_node[:hostname] + '.' + v_domain
      node_config.vm.network :public_network, ip: puppet_node[:ip]

      # This code is responsible for ensuring your local code changes is sync real time with the puppet master.
      if puppet_node[:hostname] == 'puppet'
        node_config.vm.synced_folder "manifests", "/etc/puppet/manifests"
        node_config.vm.synced_folder "modules", "/etc/puppet/modules"        
      end
      
      # Port Forwaring allows you to access vagrant provisioned servers from your desktop.
      # You may read http://docs.vagrantup.com/v2/getting-started/networking.html for more details
      if puppet_node[:forward_host]
        node_config.vm.network :forwarded_port, guest: puppet_node[:forward_guest], host: puppet_node[:forward_host]
      end      

      memory = puppet_node[:ram] ? puppet_node[:ram] : 512;
      node_config.vm.provider :virtualbox do |virtualbox|
        virtualbox.customize [
          'modifyvm', :id,
          '--name', puppet_node[:hostname],
          '--memory', memory.to_s
        ]
      end

      # Manages the connection between servers.
      node_config.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'provision/manifests'
        puppet.module_path = 'provision/modules'
      end
    end
  end
end
