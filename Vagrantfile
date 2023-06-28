# -*- mode: ruby -*-
# vi: set ft=ruby :

VIMAGE = "almalinux/8"
#VIMAGE = "centos/7"
#VIMAGE = "debian/bullseye64"
#VIMAGE = "opensuse/Leap-15.4.x86_64"
#VIMAGE = "generic/ubuntu2204"

NODES = 1

Vagrant.configure(2) do |config|

  (1..NODES).each do |machine_id|
    config.vm.define "cobbler-server#{machine_id}" do |machine|

    machine.vm.box = VIMAGE
    machine.vm.hostname = "cobbler-server#{machine_id}.localdomain.example.net"
    machine.vm.network :private_network, ip: "192.168.56.#{55+machine_id}"
    config.ssh.insert_key = false
      #Run provisioning on all machines AFTERWARDS
      if machine_id == NODES
        machine.vm.provision :ansible do |ansible|
          ansible.verbose = "v"
          ansible.playbook = "cobbler_deploy.yml"
          ansible.limit = "cobbler3x_server"
          ansible.inventory_path  = "hosts.ini"
          #ansible.extra_vars = { deploy_some_var: true }
        end
      end

    end
  end
end
