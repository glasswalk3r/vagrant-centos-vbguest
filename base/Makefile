BOX_FILE=package.box
MY_NAME=centos/8-vbguest-base

image:
	vagrant up
	vagrant package
	vagrant box add --name $(MY_NAME) $(BOX_FILE)
test:
	vagrant validate
destroy: clean
	vagrant box remove $(MY_NAME) --force
clean:
	rm -fv $(BOX_FILE)
	vagrant destroy --force
