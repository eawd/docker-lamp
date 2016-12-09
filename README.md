# docker-lamp
Containerized LAMP stack with configurable PHP version for test purposes.

## Installation/Usage

Install [docker](https://www.docker.com/products/docker) and [docker-compose](https://docs.docker.com/compose/install/).

Clone the repo by entering `git clone https://github.com/comando4ever/docker-lamp.git ./server`.

Enter the directory of the cloned repo `cd ./server`

Run `docker-compose build` and `docker-compose up -d` then you should have a running web server on port 80.

You can add your application files in `src` directory.

To shutdown the server use `docker-compose down` or Ctrl+C if you didn't use the `-d` option.

## Configuration

Change PHP version by changing `PHP_VERSION` in docker-compose.yml file the default version is "5.3.29".

Change MySQL password by changing `MYSQL_ROOT_PASSWORD` the default password is "root".

To change the configurations of Apache, MySQL or PHP mount a volume pointing to the configuration files you need to change.

* The php image uses phpbrew to manage version so you may need to figure out the php.ini file location depending on your version usually in `/root/.phpbrew/php/php-$VERSION/etc` changing $VERSION to your installed version.
* MySQL uses a separate image so you may want to add the volume to its image in `docker-compose.yml`.
