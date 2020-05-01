# vagrant-centos-vbguest

A Vagrant box based on CentOS for Virtualbox, with Virtualbox Guest Additions
already included in the kernel.

## Introduction

This project can be used to create an CentOS Vagrant box to use with
[Virtualbox](https://www.virtualbox.org/).

Virtualbox provides the
[Guest Additions](https://www.virtualbox.org/manual/ch04.html#guestadd-intro)
for some operational systems (including Linux), which provides additional
features.

Installing it requires recompiling the Linux kernel in the
VM, which will require the kernel source, headers and compilation tools to be
installed.

Besides the additional software to be downloaded and installed,
compiling the kernel can be time consuming, depending on the VM configuration
and underline host.

The Vagrant plugin
[vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) helps to
automatically detect if the Guest Additions is installed (or outdated) and
takes care of installing everything to have it available. But, of course, that
still requires additional time to install.

## Automation

This project was created to take care of installing the Guest Additions besides
with updates for CentOS and making it available at
[Vagrant Cloud](https://app.vagrantup.com/boxes/search?utf8=%E2%9C%93&sort=downloads&provider=virtualbox&q=centos)
for download.

Using that image, instead of the official one, will make things faster.

All the automation is done with [Vagrant](https://www.vagrantup.com/) and
[Ansible](https://www.ansible.com/).

## Software included

After installing the Guest Additions, the automation in this project takes
care of removing the kernel source, headers and compile tools, to make the
VM smaller again.

Also, some additional software is installed (and others removed), all of them
small utilities. You can check what in the file `playbooks/packages.yaml`.

Also, IPv6 is disable in the VM. See `playbooks/sysctl.yaml`

## How to use it

Check the `Makefile` available.
