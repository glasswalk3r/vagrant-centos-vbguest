# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = true
  config.vm.synced_folder './playbooks', '/vagrant'
  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    # Customize the amount of memory on the VM:
    vb.memory = '4096'
    vb.cpus = 2
    vb.name = 'centos7-vbguest'
  end

  # Faster than using Ansible
  config.vm.provision 'shell', inline: '/usr/bin/yum makecache fast'
  config.vm.provision 'shell', inline: '/usr/bin/yum upgrade -y'

  playbooks = ['packages.yaml', 'sysctl.yaml']

  playbooks.each do |playbook_file|
    config.vm.provision 'ansible_local' do |ans|
      ans.playbook = playbook_file
      ans.compatibility_mode = '2.0'
      ans.install = true
      ans.install_mode = :default
    end
  end

  insecure_pub_key = 'https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub'
  script = <<~SCRIPT
    /usr/bin/wget -c #{insecure_pub_key}
    cat vagrant.pub > ~/.ssh/authorized_keys
    rm -rf vagrant.pub
  SCRIPT

  config.vm.provision 'shell',
                      inline: script,
                      privileged: false
end
