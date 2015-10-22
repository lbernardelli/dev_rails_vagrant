# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential

install libgmp-dev

install Git git
install SQLite sqlite3 libsqlite3-dev
install memcached memcached
install Redis redis-server
install RabbitMQ rabbitmq-server

install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser dev

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install MySQL mysql-server libmysqlclient-dev
mysql -uroot -proot <<SQL
CREATE USER 'dev'@'localhost';
SQL

install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
install 'ExecJS runtime' nodejs

echo 'all set, rock on!'