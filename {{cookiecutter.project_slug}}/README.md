# {{cookiecutter.project}}

{{cookiecutter.description}}

## Build

1. This project is managed with [Docker](https://www.docker.com/) and [sbt](https://www.scala-sbt.org/).
2. Useful project commands are `make` targets.
3. Any of the `make` targets can be executed to initialize the Docker environment.

### Makefile

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

### Default Recommended Libraries

- **Play 2**: https://www.playframework.com/ - Web Application Framework
- **ScalaTest**: https://github.com/scalatest/scalatest - Scala Testing Framework
- **ScalaCheck**: https://github.com/rickynils/scalacheck - Property-Based Testing
- **Mockito**: https://github.com/mockito/mockito - Mocking Framework
- **Testcontainers**: https://github.com/testcontainers/testcontainers-scala - Docker-Based Testing
- **Scala Guice**: https://github.com/codingwell/scala-guice - Dependency Injection
- **Kamon**: https://github.com/kamon-io/kamon-play - Metrics
- **Slick**: http://slick.lightbend.com/ - JDBC
- **PostgreSQL**: https://www.postgresql.org/ - Disk RDBMS
- **H2**: http://www.h2database.com/ - Memory RDBMS
- **Caffeine**: https://github.com/ben-manes/caffeine/ - Cache

## Credits

This package was created with [Cookiecutter](https://github.com/audreyr/cookiecutter) and the [jparkie//cookiecutter-scala-play](https://github.com/jparkie/cookiecutter-scala-play) project template.
