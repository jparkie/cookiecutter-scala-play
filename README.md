# cookiecutter-scala-play

Cookiecutter template for a Scala Play 2 application.

## Requirements

### cookiecutter

Please follow instructions at https://cookiecutter.readthedocs.io/en/latest/installation.html.

#### pip

```
> pip install cookiecutter
```

#### Homebrew (macOS)

```
> brew install cookiecutter
```
#### Ubuntu

```
> sudo apt-get install cookiecutter
```

## Installation

Please execute the following command to create a new Scala Play 2 project.

```
> cookiecutter git@github.com:jparkie/cookiecutter-scala-play.git
```

### Configurations

```
> cookiecutter git@github.com:jparkie/cookiecutter-scala-play.git
project [example]:
version [0.1.0-SNAPSHOT]:
organization [com.github.jparkie]:
organizationName [jparkie]:
description [TODO]:
scala_version [2.12.8]:
play_version [2.7.2]:
```

## Features

### Dockerfile + Makefile + Jenkinsfile

- A Dockerfile with Java 8, Scala 2.12, and sbt 1.1, scalafmt 1.5.1, scalastyle 1.0.0, and pre-commit is provided to self-contain the project.
- A Makefile is provided to execute various project commands within a Docker container.
- A Jenkinsfile is provided with the following stages: Checkout, Pre-Commit, Clean, Build, Unit Test, Integration Test, Acceptance Test, Coverage, and Docker Publish.

#### Makefile

```
> make help
Welcome to {{cookiecutter.project}}!

This project is preferably managed with Docker. Please have Docker installed.

Otherwise, please install pre-commit, sbt, scalafmt, and scalastyle.

Please source project/use-local-sbt.sh if you want the Makefile to use the local sbt
Please source project/use-docker-sbt.sh if you want the Makefile to use the Docker sbt

    uninstall-docker
        Remove Docker image sbt_environment_12
    init
        Initialize project directory
    docker
        Start an interactive, Dockerized bash session
    clean
        Clean the Scala project
    compile
        Compile the Scala project
    coverage-report
        Generate test coverage reports
        See https://github.com/scoverage/sbt-scoverage for more information
    dependency-tree
        Generate an ASCII tree of the Scala project's dependencies
        See https://github.com/jrudolph/sbt-dependency-graph for more information
    docker-stage
        Generate a directory with the Dockerfile and environment prepared for creating a Docker image
        See https://sbt-native-packager.readthedocs.io/en/v1.3.7/formats/docker.html#tasks for more information
    docker-publish-local
        Build an image using the local Docker server
        See https://sbt-native-packager.readthedocs.io/en/v1.3.7/formats/docker.html#tasks for more information
    format
        Format the Scala project's code
        See https://scalameta.org/scalafmt/ for more information
    lint
        Lint the Scala project's code
        See http://www.scalastyle.org/sbt.html for more information
    pre-commit
        Execute pre-commit hooks
        See https://pre-commit.com/ for more information
    release
        Verify the Scala project to version and release the code to git
        See https://github.com/sbt/sbt-release for more information
    run-dev
        Run the Play application in development mode
        See https://www.playframework.com/documentation/2.6.x/PlayConsole for more information
    run-prod
        Run the Play application in production mode
        See https://www.playframework.com/documentation/2.6.x/Deploying for more information
    test-all
        Execute all of the tests in the Scala project
    test-*-only TEST_ONLY=**
        Execute only the unit/integration/acceptance tests that match the wildcard in TEST_ONLY
    test-unit
        Execute the tests in the Scala project
    test-integration
        Execute the itests in the Scala project
    test-acceptance
        Execute the atests in the Scala project
```

### Testing Classes

To promote good testing practices, the project provides the following classes.
- [BaseSuiteLike.scala](https://github.com/jparkie/cookiecutter-scala-play/blob/master/%7B%7Bcookiecutter.project%7D%7D/test/scala/suites/BaseSuiteLike.scala)
- [PlayUnitSuite.scala](https://github.com/jparkie/cookiecutter-scala-play/blob/master/%7B%7Bcookiecutter.project%7D%7D/test/scala/suites/PlayUnitSuite.scala)
- [PlayIntegrationSuite.scala](https://github.com/jparkie/cookiecutter-scala-play/blob/master/%7B%7Bcookiecutter.project%7D%7D/itest/scala/suites/PlayIntegrationSuite.scala)
- [PlayAcceptanceSuite.scala](https://github.com/jparkie/cookiecutter-scala-play/blob/master/%7B%7Bcookiecutter.project%7D%7D/atest/scala/suites/PlayAcceptanceSuite.scala)
- [GlobalFixtures.scala](https://github.com/jparkie/cookiecutter-scala-play/blob/master/%7B%7Bcookiecutter.project%7D%7D/test/scala/fixtures/GlobalFixtures.scala)

### Project Structure

The SBT project is organized with `app` for code, `test/scala` for unit tests, `itest/scala` for integration tests and `atest/scala` for acceptance tests.

```
>tree ./
./
├── Dockerfile
├── Jenkinsfile
├── Makefile
├── README.md
├── app
│   ├── controllers
│   │   ├── HomeController.scala
│   │   └── package.scala
│   ├── models
│   │   └── package.scala
│   ├── modules
│   │   └── package.scala
│   ├── repositories
│   │   ├── Repository.scala
│   │   └── package.scala
│   ├── util
│   │   └── package.scala
│   └── views
│       ├── index.scala.html
│       ├── main.scala.html
│       └── package.scala
├── atest
│   ├── resources
│   │   └── TODO
│   └── scala
│       └── suites
│           └── PlayAcceptanceSuite.scala
├── build.sbt
├── conf
│   ├── application.conf
│   ├── evolutions
│   │   └── {{cookiecutter.project}}
│   │       └── 1.sql
│   ├── logback.xml
│   ├── messages
│   └── routes
├── itest
│   ├── resources
│   │   └── TODO
│   └── scala
│       └── suites
│           └── PlayIntegrationSuite.scala
├── logs
│   └── application.log
├── project
│   ├── build.properties
│   ├── plugins.sbt
│   ├── use-docker-sbt.sh
│   └── use-local-sbt.sh
├── public
│   ├── images
│   │   └── favicon.png
│   ├── javascripts
│   │   └── main.js
│   └── stylesheets
│       └── main.css
├── scalastyle-config.xml
├── test
│   ├── resources
│   │   └── TODO
│   └── scala
│       ├── fixtures
│       │   ├── GlobalFixtures.scala
│       │   └── package.scala
│       ├── suites
│       │   ├── BaseSuiteLike.scala
│       │   ├── PlayUnitSuite.scala
│       │   └── package.scala
│       └── testutil
│           └── package.scala
└── version.sbt

30 directories, 41 files
```
