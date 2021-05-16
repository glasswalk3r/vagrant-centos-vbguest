BOX_FILE=package.box
MY_NAME=centos8-vbguest
FULL_NAME=arfreitas/centos8-vbguest
VIRTUALENV=$(shell basename $$PWD)

init:
	if ![-e .python-version]; then pyenv virtualenv ${VIRTUALENV} && pyenv local ${VIRTUALENV}; fi
	pip install -U pip wheel setuptools
	pip install -U ansible
	vagrant box update
image:
	vagrant up --no-provision
	vagrant vbguest --auto-reboot --do install
	vagrant reload
	vagrant package --base $(MY_NAME)
	vagrant box add --name $(FULL_NAME) $(BOX_FILE)
test:
	yamllint -c yamllint.yaml playbooks/*.yaml
	vagrant validate
	ansible-playbook --check playbooks/*.yaml
destroy: clean
	vagrant box remove $(FULL_NAME)
clean:
	rm -fv $(BOX_FILE)
	vagrant destroy --force
	vagrant box remove "arfreitas/${MY_NAME}" --all --force
