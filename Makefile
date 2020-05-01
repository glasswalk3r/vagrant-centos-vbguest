build:
		vagrant up
		vagrant halt
		vagrant package --base centos7-vbguest
		vagrant box add --name arfreitas/centos7-vbguest package.box
		rm -fv package.box
test:
		yamllint -c yamllint.yaml playbooks/*.yaml
		vagrant validate
		ansible-playbook --check playbooks/*.yaml
destroy:
		vagrant destroy --force
		vagrant box remove arfreitas/centos7-vbguest
