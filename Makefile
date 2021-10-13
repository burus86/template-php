## see:
## 		https://www.gnu.org/software/make/manual/html_node/index.html
## 		https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
## 		https://docs.php.earth/interop/make/

# variables
.DEFAULT_GOAL := help
.PHONY : help start stop install update require bash logs test
CONTAINERS = template-php
CONTAINER_NAME = template-php
CONTAINER_OPTIONS = -it
RUN = docker exec $(CONTAINER_OPTIONS) $(CONTAINER_NAME)
#PHPUNIT_FILE = phpunit.xml.dist
PHPMD_FILE = phpmd.xml
PHPSTAN_FILE = phpstan.neon
CHURN_FILE = churn.yml
COLOR_RESET = \033[0m
COLOR_INFO = \033[32m
COLOR_COMMENT = \033[33m


## Help
help:
	@printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	@printf " make [target]\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Start docker containers
start:
	@echo "Starting docker containers"
	@echo "---------------------------"
	@echo
	docker-compose -f docker/docker-compose.yml up -d --build --remove-orphans
	@echo

## Stop docker containers
stop:
	@echo "Stopping docker containers"
	@echo "---------------------------"
	@echo
	docker stop $(CONTAINERS)
	@echo

## Install PHP dependencies
install: start composer.json $(wildcard composer.lock)
	@echo "Installing PHP dependencies"
	@echo "---------------------------"
	@echo
	$(RUN) composer install
	@echo

## Update PHP dependencies
update: start composer.json $(wildcard composer.lock)
	@echo "Updating PHP dependencies"
	@echo "---------------------------"
	@echo
	$(RUN) composer update
	@echo

## Require new PHP dependencies. Example: make require PACKAGE=phpstan/phpstan ENV=--dev
require: start composer.json
	@echo "Require new PHP dependencies:"
	@echo "---------------------------"
	@echo
	$(RUN) composer require $(ENV) $(PACKAGE)
	@echo

## Access docker container bash
bash: start
	@echo "Access docker container bash"
	@echo "---------------------------"
	@echo
	$(RUN) bash

## Show docker container logs
logs: start
	@echo "Show docker container logs"
	@echo "---------------------------"
	@echo
	docker logs -f -n20 $(CONTAINER_NAME)

## Run all tests (PHP Unit, Behat, PHP_CodeSniffer, PHPStan, PHP Mess Detector, Deptrac, ...)
test: start vendor test-phpunit test-behat test-phpcs test-phpstan test-phpmd test-phpmnd test-phpcpd test-churn test-phpdd test-deptrac

## Run PHP Unit Tests
test-phpunit: start bin/phpunit
	@echo "Run PHP Unit Tests"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpunit
	@echo

## Run Behat Tests
test-behat: start bin/behat
	@echo "Run Behat Tests"
	@echo "---------------------------"
	@echo
	$(RUN) bin/behat
	@echo

## Run PHP_CodeSniffer and detect violations of a defined coding standard
test-phpcs: start bin/phpcs
	@echo "Run PHP_CodeSniffer: phpcs"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpcs src/ tests/
	@echo

## Run PHP_CodeSniffer and automatically correct coding standard violations
test-phpcbf: start bin/phpcbf
	@echo "Run PHP_CodeSniffer: phpcbf"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpcbf src/ tests/
	@echo

## Run PHPStan
test-phpstan: start bin/phpstan
	@echo "Run PHPStan"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpstan analyse -c $(PHPSTAN_FILE)
	@echo

## Run PHP Mess Detector
test-phpmd: start bin/phpmd
	@echo "Run PHP Mess Detector"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpmd src/ text $(PHPMD_FILE)
	@echo

## Run PHP Magic Number Detector
test-phpmnd: start bin/phpmnd
	@echo "Run PHP Magic Number Detector"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpmnd src tests --progress --extensions=all
	@echo

## Run PHP Copy Paste Detector
test-phpcpd: start bin/phpcpd
	@echo "Run PHP Copy Paste Detector"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpcpd ./ --exclude=var --exclude=vendor --fuzzy --min-lines=5
	@echo

## Run Churn-php
test-churn: start bin/churn
	@echo "Run Churn-php"
	@echo "---------------------------"
	@echo
	$(RUN) bin/churn run --configuration=$(CHURN_FILE)
	@echo

## Run PhpDeprecationDetector
test-phpdd: start bin/phpdd
	@echo "Run PhpDeprecationDetector"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpdd src/ tests/
	@echo

## Run Deptrac
test-deptrac: start bin/deptrac
	@echo "Run Deptrac"
	@echo "---------------------------"
	@echo
	$(RUN) bin/deptrac analyse
	@echo
