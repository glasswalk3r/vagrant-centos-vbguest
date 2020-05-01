BOX_FILE=package.box

build:
		vagrant up
		vagrant halt
		vagrant package --base centos7-vbguest
		vagrant box add --name arfreitas/centos7-vbguest $(BOX_FILE)
test:
		yamllint -c yamllint.yaml playbooks/*.yaml
		vagrant validate
		ansible-playbook --check playbooks/*.yaml
destroy: clean
		vagrant destroy --force
		vagrant box remove arfreitas/centos7-vbguest
clean:
		rm -fv $(BOX_FILE)
