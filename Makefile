BOX_FILE=package.box
MY_NAME=centos7-vbguest

build:
	vagrant up
	vagrant package --base $(MY_NAME)
	vagrant box add --name "arfreitas/${MY_NAME}" $(BOX_FILE)
	sha256sum $(BOX_FILE)
test:
	yamllint -c yamllint.yaml playbooks/*.yaml
	vagrant validate
	ansible-playbook --check playbooks/*.yaml
destroy: clean
	vagrant box remove "arfreitas/${MY_NAME}"
clean:
	rm -fv $(BOX_FILE)
	vagrant destroy --force
