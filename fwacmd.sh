# How to install FarmBot Web API on a Fresh Ubuntu 17 machine.

function pause() {
    read -n1 -r -p "Press any key to continue..." key
}

function mqtt_start() {
	cd ~/Farmbot-Web-App
	source ~/.rvm/scripts/rvm
	rvm --default use 2.4.2
	RAILS_ENV=test
	rails mqtt:start
	exit
}

function web_start() {
	cd ~/Farmbot-Web-App
	source ~/.rvm/scripts/rvm
	rvm --default use 2.4.2
	cp ~/fwa-quick-install/application.example.yml config/application.yml
	myip=`ip route get 8.8.8.8 | awk '{print $NF; exit}'`
	secret=`rake secret`
	sed -i s/changeme-io/$myip/g config/application.yml
	sed -i s/rake-secret/$secret/g config/application.yml
	RAILS_ENV=test
	rails api:start
	exit
}

function install() {
    # Remove old (possibly broke) docker versions
    sudo apt-get remove docker docker-engine docker.io

    # Install docker
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common --yes
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" --yes
    sudo apt-get update --yes
    sudo apt-get install docker-ce --yes
    sudo docker run hello-world # Should run!

    # Install RVM
    sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    rvm install 2.4.2
    rvm use 2.4.2 --default
    ruby -v

    # Image Magick
    sudo apt-get install imagemagick --yes

    # Install Node
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt-get install -y nodejs --yes

    # Install Yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update && sudo apt-get install yarn

    # Install database deps
    sudo apt-get install libpq-dev postgresql-contrib --yes

    # Install FarmBot Web App
    sudo apt-get install git --yes
    git clone https://github.com/FarmBot/Farmbot-Web-App --depth=10
    cd Farmbot-Web-App
    source ~/.rvm/scripts/rvm
    rvm --default use 2.4.2
    gem install bundler
    npm install yarn
    bundle install
    yarn install
    cp config/database.example.yml config/database.yml    
    cp ~/fwa-quick-install/application.example.yml config/application.yml
    myip=`ip route get 8.8.8.8 | awk '{print $NF; exit}'`
    secret=`rake secret`
    sed -i s/changeme-io/$myip/g config/application.yml
    sed -i s/rake-secret/$secret/g config/application.yml

    # Create postgres user role
    cat << EOF | sudo -u postgres psql
CREATE USER "$USER" WITH SUPERUSER;
\q
EOF

    source ~/.rvm/scripts/rvm
    rvm --default use 2.4.2
    # create database
    rake db:create:all db:migrate db:seed

    # run test
    RAILS_ENV=test rake db:create db:migrate && rspec spec
    npm run test
    
    exit
}

case ${1} in
	"install")
		install
		;;
	"mqtt")
		mqtt_start
		;;
	"web")
		web_start
		;;
	*)
		echo "Usage: ${0} install|mqtt|web"
		;;
esac

