# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

def custom_vb(vb_provider)
  vb_provider.gui = false
  vb_provider.memory = '4096'
  vb_provider.cpus = 2
  vb_provider.name = 'centos8-vbguest'
  vb_provider.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
  vb_provider.customize ['modifyvm', :id, '--boot1', 'disk']
  vb_provider.customize ['modifyvm', :id, '--boot2', 'dvd']
  vb_provider.customize ['modifyvm', :id, '--boot3', 'none']
  vb_provider.customize ['modifyvm', :id, '--vram', 9] # minimum value accepted
end

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/8'
  config.vm.box_check_update = true
  config.vbguest.auto_update = true
  config.vm.synced_folder './playbooks', '/vagrant'
  config.vm.provider 'virtualbox' do |vb|
    custom_vb(vb)
  end

  # Faster than using Ansible
  dnf = '/usr/bin/dnf makecache && /usr/bin/dnf upgrade -y'
  config.vm.provision 'shell', inline: dnf
  playbooks = ['packages.yaml', 'sysctl.yaml']

  playbooks.each do |playbook_file|
    config.vm.provision 'ansible_local' do |ans|
      ans.playbook = playbook_file
      ans.compatibility_mode = '2.0'
      ans.install = true
      ans.install_mode = :default
    end
  end

  # forcing shutdown because Vagrant will fail to do it itself since the SSH
  # credential will be different
  insecure_pub_key = <<~SCRIPT

    if ! [ -f /home/vagrant/.ssh_setup_ok ]
    then
      /usr/bin/wget -c https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
      mv -vf vagrant.pub ~/.ssh/authorized_keys
      echo 'Done' > /home/vagrant/.ssh_setup_ok
      sudo shutdown -h now
    fi
  SCRIPT

  config.vm.provision 'shell',
                      inline: insecure_pub_key,
                      privileged: false
end
