## see https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html

# variables
.DEFAULT_GOAL := help
.PHONY: help install start stop test
CONTAINER_NAME		= template-php
CONTAINER_OPTIONS	= -it
RUN					= docker exec $(CONTAINER_OPTIONS) $(CONTAINER_NAME)
#PHPUNIT_FILE		= phpunit.xml.dist
PHPMD_FILE			= phpmd.xml
PHPSTAN_FILE		= phpstan.neon
CHURN_FILE			= churn.yml
COLOR_RESET			= \033[0m
COLOR_INFO			= \033[32m
COLOR_COMMENT		= \033[33m


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

## Start PHP application
start:
	@echo "Starting PHP application"
	@echo "---------------------------"
	@echo
	docker-compose -f docker/docker-compose.yml up -d --build --remove-orphans

## Stop PHP application
stop:
	@echo "Stopping PHP application"
	@echo "---------------------------"
	@echo
	docker stop $(CONTAINER_NAME)

## Install PHP dependencies
install: start composer.json $(wildcard composer.lock)
	@echo "Installing PHP dependencies"
	@echo "---------------------------"
	@echo
	$(RUN) composer install

## Update PHP dependencies
update: start composer.json $(wildcard composer.lock)
	@echo "Updating PHP dependencies"
	@echo "---------------------------"
	@echo
	$(RUN) composer update

## Run all tests (unit tests, code style, etc.)
test: start
	@echo "Run PHP Unit Tests"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpunit
	@echo
	@echo "Run Behat Tests"
	@echo "---------------------------"
	@echo
	$(RUN) bin/behat
	@echo
	@echo "Run Behat Tests"
	@echo "---------------------------"
	@echo
	$(RUN) vendor/bin/behat
	@echo
	@echo "Run PHP_CodeSniffer"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpcs src/ tests/
	#$(RUN) bin/phpcbf src/ tests/
	@echo
	@echo "Run PHPStan"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpstan analyse -c $(PHPSTAN_FILE)
	@echo
	@echo "Run PHP Mess Detector"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpmd src/ text $(PHPMD_FILE)
	@echo
	@echo "Run PHP Magic Number Detector"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpmnd src tests --progress --extensions=all
	@echo
	@echo "Run PHP Copy Paste Detector"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpcpd ./ --exclude=var --exclude=vendor --fuzzy --min-lines=5
	@echo
	@echo "Run Churn-php"
	@echo "---------------------------"
	@echo
	$(RUN) bin/churn run --configuration=$(CHURN_FILE)
	@echo
	@echo "Run PhpDeprecationDetector"
	@echo "---------------------------"
	@echo
	$(RUN) bin/phpdd src/ tests/
	@echo
	@echo "Run Deptrac"
	@echo "---------------------------"
	@echo
	$(RUN) bin/deptrac analyse
	@echo
