# Farmbot-Web-App quick installation script

Before you start, please install fresh Ubuntu 16.04 Desktop. Then open a
terminal window to execute the installation script as follow:

	cd $HOME
	git clone https://github.com/cyriacr/fwa-quick-install
	./fwa-quick-install/fwacmd.sh install

To start your web frontend and mqtt broker:

	cd $HOME
	./fwa-quick-install/start-from-xwin.sh

This script will open a terminal window for web frontnend, and wait for 60 seconds to open another terminal window for RabbitMQTT broker.
And then you should be able to connect to your farmbot web frondend both locally
and remotely.

For docker version, please check https://github.com/cyriacr/farmbot-docker

# Issues
take-photo not working yet, still checking.

# Attension please
This script is only for development environment, please do not use this for
production.

