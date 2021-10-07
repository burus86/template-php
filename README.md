# template-php

1. [About project](#about-project)
1. [Set up project](#set-up-project)
   * [Installation](#installation)
   * [Execute project](#execute-project)
   * [Execute all tests](#execute-all-tests)
1. [Unit Tests](#unit-tests)
   * [PHP Unit](#php-unit)
1. [Functional Tests](#functional-tests)
    * [Behat](#behat)
1. [Code Quality Checker Tools](#code-quality-checker-tools)
   * [PHP_CodeSniffer](#php_codesniffer)
   * [PHPStan](#phpstan)
   * [PHP Mess Detector](#php-mess-detector)
   * [PHP Magic Number Detector](#php-magic-number-detector)
   * [PHP Copy Paste Detector](#php-copy-paste-detector)
   * [Churn-php](#churn-php)
   * [PhpDeprecationDetector](#PhpDeprecationDetector)
1. [Code Analysis Tools](#code-analysis-tools)
   * [Deptrac](#deptrac)

## About project
- [x] PHP 8
- [x] Docker
- [x] Makefile
- [x] Unit tests: PHP Unit
- [x] Functional tests: Behat
- [x] Code Quality Checker Tools: PHP_CodeSniffer, PHPStan, PHP Mess Detector, PHP Magic Number Detector, PHP Copy Paste Detector, Churn-php, PhpDeprecationDetector
- [x] Code Analysis Tools: Deptrac

## Set up project

### Installation

Clone repository:

    git clone https://github.com/burus86/template-php.git
    cd template-php

Build and up docker containers:

    make start

Install composer dependencies:

    make install

### Execute project

Open in your favorite web browser the website [http://localhost:8080/](http://localhost:8080/).

![Captura](public/images/phpinfo.png)

### Execute all tests

To run all the tests (unit tests, functional tests, code quality checker tools and code analysis tools), just execute the command `make test` with [option -i or --ignore-errors](https://www.gnu.org/software/make/manual/make.html#Options-Summary):

    make test -i

If you prefer, it's also possible to run each individual test following the instructions below.

## Unit Tests

### [PHP Unit](https://github.com/sebastianbergmann/phpunit)

    docker exec -it template-php bin/phpunit

## Functional Tests

### [Behat](https://github.com/Behat/Behat)

    docker exec -it template-php bin/behat

## Code Quality Checker Tools

### [PHP_CodeSniffer](https://github.com/squizlabs/php_codesniffer)

    docker exec -it template-php bin/phpcs src/ tests/
    docker exec -it template-php bin/phpcbf src/ tests/

### [PHPStan](https://github.com/phpstan/phpstan)

    docker exec -it template-php bin/phpstan analyse -c phpstan.neon

### [PHP Mess Detector](https://github.com/phpmd/phpmd)

    docker exec -it template-php bin/phpmd src/ text phpmd.xml

### [PHP Magic Number Detector](https://github.com/povils/phpmnd)

    docker exec -it template-php bin/phpmnd src tests --progress --extensions=all

### [PHP Copy Paste Detector](https://github.com/sebastianbergmann/phpcpd)

    docker exec -it template-php bin/phpcpd ./ --exclude=var --exclude=vendor --fuzzy --min-lines=5

### [Churn-php](https://github.com/bmitch/churn-php)

`churn-php` is a package that helps you identify php files in your project that could be good candidates for refactoring.

    docker exec -it template-php bin/churn run --configuration=churn.yml

### [PhpDeprecationDetector](https://github.com/wapmorgan/PhpDeprecationDetector)

    docker exec -it template-php bin/phpdd src/ tests/

## Code Analysis Tools

### [Deptrac](https://github.com/qossmic/deptrac)

    docker exec -it template-php bin/deptrac analyse
