# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

# forcing shutdown because Vagrant will fail to do it itself since the SSH
# credential will be different
insecure_pub_key = <<~SCRIPT
  /usr/bin/wget -c https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
  cat vagrant.pub > ~/.ssh/authorized_keys
  rm -rf vagrant.pub
  sudo shutdown -h now
SCRIPT

yum = '/usr/bin/yum makecache fast && /usr/bin/yum upgrade -y'

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'
  config.vm.box_check_update = true
  config.vm.synced_folder './playbooks', '/vagrant'
  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    # Customize the amount of memory on the VM:
    vb.memory = '4096'
    vb.cpus = 2
    vb.name = 'centos7-vbguest'
    vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    vb.customize ['modifyvm', :id, '--boot1', 'disk']
    vb.customize ['modifyvm', :id, '--boot2', 'dvd']
    vb.customize ['modifyvm', :id, '--boot3', 'none']
    vb.customize ['modifyvm', :id, '--vram', 9] # minimum value accepted
  end

  # Faster than using Ansible
  config.vm.provision 'shell', inline: yum
  playbooks = ['packages.yaml', 'sysctl.yaml']

  playbooks.each do |playbook_file|
    config.vm.provision 'ansible_local' do |ans|
      ans.playbook = playbook_file
      ans.compatibility_mode = '2.0'
      ans.install = true
      ans.install_mode = :pip
    end
  end

  config.vm.provision 'shell',
                      inline: insecure_pub_key,
                      privileged: false
end
