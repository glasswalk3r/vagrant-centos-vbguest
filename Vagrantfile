# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

# forcing shutdown because Vagrant will fail to do it itself since the SSH
# credential will be different
def insecure_pub_key
  <<~SHELL
    /usr/bin/wget -c https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
    cat vagrant.pub > ~/.ssh/authorized_keys
    rm -rf vagrant.pub
    sudo shutdown -h now
  SHELL
end

def basic_packages
  <<~SHELL
    /usr/bin/yum clean all
    /usr/bin/yum makecache fast
    /usr/bin/yum update -y
    /usr/bin/yum install -y centos-release-ansible-29
    /usr/bin/yum makecache fast
    /usr/bin/yum install -y ansible
  SHELL
end

def vb_custom(virtual_box)
  # Display the VirtualBox GUI when booting the machine
  virtual_box.gui = false
  # Customize the amount of memory on the VM:
  virtual_box.memory = '4096'
  virtual_box.cpus = 2
  virtual_box.name = 'centos7-vbguest'
  virtual_box.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
  virtual_box.customize ['modifyvm', :id, '--boot1', 'disk']
  virtual_box.customize ['modifyvm', :id, '--boot2', 'dvd']
  virtual_box.customize ['modifyvm', :id, '--boot3', 'none']
  virtual_box.customize ['modifyvm', :id, '--vram', 9] # minimum value accepted
end

Vagrant.configure('2') do |config|
  # config.vbguest.auto_update = false if Vagrant.has_plugin?('vagrant-vbguest')
  # config.vbguest.installer_options = { allow_kernel_upgrade: true }
  # config.vbguest.installer_hooks[:before_install] = [
  #   'yum clean all',
  #   'yum makecache fast',
  #   'yum update -y'
  # ]

  config.vm.box = 'centos/7'
  config.vm.box_check_update = true
  config.vm.synced_folder './playbooks', '/vagrant'
  config.vm.provider 'virtualbox' do |vb|
    vb_custom(vb)
  end

  # Faster than using Ansible
  config.vm.provision 'shell', inline: basic_packages
  playbooks = ['packages.yaml', 'sysctl.yaml']

  playbooks.each do |playbook_file|
    config.vm.provision 'ansible_local' do |ans|
      ans.playbook = playbook_file
      ans.compatibility_mode = '2.0'
      ans.install = false
    end
  end

  # cleaning up
  config.vm.provision 'shell', inline: <<~SHELL
    /usr/bin/yum makecache fast
    /usr/bin/yum update -y
    /usr/bin/yum clean all
    # uname -r
    # rpm -q kernel
    /usr/bin/yum remove -y centos-release-ansible-29 ansible
  SHELL
  config.vm.provision 'shell',
                      inline: insecure_pub_key,
                      privileged: false
end
