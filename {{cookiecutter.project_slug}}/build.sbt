/**
  * Organization:
  */
organization     := "{{cookiecutter.organization}}"
organizationName := "{{cookiecutter.organizationName}}"

/**
  * Library Meta:
  */
name := "{{cookiecutter.project_slug}}"

/**
  * Scala:
  */
scalaVersion := "{{cookiecutter.scala_version}}"

/**
  * Java:
  */
javacOptions ++= Seq("-source", "1.8", "-target", "1.8")
javaOptions  ++= Seq("-Xms512M", "-Xmx2048M", "-XX:MaxPermSize=2048M", "-XX:+CMSClassUnloadingEnabled")

/**
  * Play:
  */
enablePlugins(PlayScala)

/**
  * Kamon:
  */
enablePlugins(JavaAppPackaging)
enablePlugins(JavaAgent)
javaAgents += "org.aspectj" % "aspectjweaver" % "1.8.13"
javaOptions in Universal += "-Dorg.aspectj.tracing.factory=default"

/**
  * Scala-Async Feature:
  */
libraryDependencies += "org.scala-lang.modules" %% "scala-async"   % "0.10.0"
libraryDependencies += "org.scala-lang"          % "scala-reflect" % scalaVersion.value % Provided

/**
  * Library Dependencies:
  */

// Versions:
val H2Version                  = "1.4.199"
val KamonVersion               = "1.1.0"
val MockitoVersion             = "2.20.0"
val PlayJsonVersion            = "2.7.3"
val PostgreSqlVersion          = "42.2.5"
val ScalaGuiceVersion          = "4.2.3"
val ScalaJava8CompatVersion    = "0.9.0"
val ScalaTestVersion           = "3.0.5"
val ScalaTestPlayVersion       = "3.1.2"
val ScalaCheckVersion          = "1.14.0"
val SlickVersion               = "3.3.0"
val SlickPgVersion             = "0.18.1"
val SlickPlayVersion           = "4.0.1"
val TestContainersScalaVersion = "0.14.0"

// Language Dependencies:
val scalaJava8Compat = "org.scala-lang.modules" %% "scala-java8-compat" % ScalaJava8CompatVersion

// Test Dependencies:
val scalaTest           = "org.scalatest"          %% "scalatest"            % ScalaTestVersion           % "test"
val scalaTestPlay       = "org.scalatestplus.play" %% "scalatestplus-play"   % ScalaTestPlayVersion       % "test"
val scalaCheck          = "org.scalacheck"         %% "scalacheck"           % ScalaCheckVersion          % "test"
val mockito             = "org.mockito"             % "mockito-core"         % MockitoVersion             % "test"
val testContainersScala = "com.dimafeng"           %% "testcontainers-scala" % TestContainersScalaVersion % "test"

// Other Dependencies:
val h2                  = "com.h2database"       % "h2"                    % H2Version
val kamon               = "io.kamon"            %% "kamon-core"            % KamonVersion
val playJsonJoda        = "com.typesafe.play"   %% "play-json-joda"        % PlayJsonVersion
val postgreSql          = "org.postgresql"       % "postgresql"            % PostgreSqlVersion
val scalaGuice          = "net.codingwell"      %% "scala-guice"           % ScalaGuiceVersion
val slick               = "com.typesafe.slick"  %% "slick"                 % SlickVersion
val slickPg             = "com.github.tminglei" %% "slick-pg"              % SlickPgVersion
val slickPgJson         = "com.github.tminglei" %% "slick-pg_play-json"    % SlickPgVersion
val slickPlay           = "com.typesafe.play"   %% "play-slick"            % SlickPlayVersion
val slickPlayEvolutions = "com.typesafe.play"   %% "play-slick-evolutions" % SlickPlayVersion

val languageDependencies = Seq(scalaJava8Compat)
val playDependencies     = Seq(caffeine, filters, guice)
val testDependencies     = Seq(scalaTest, scalaTestPlay, scalaCheck, mockito, testContainersScala)
val otherDependencies    = Seq(h2, kamon, playJsonJoda, postgreSql, scalaGuice, slick, slickPg, slickPlay, slickPlayEvolutions)

libraryDependencies ++= (languageDependencies ++ playDependencies ++ testDependencies ++ otherDependencies)
  .map(configureProvidedModuleID)

/**
  * Tests:
  */
// Unit Tests:
parallelExecution in Test := false
fork              in Test := true
scalaSource       in Test := baseDirectory.value / "test" / "scala"
resourceDirectory in Test := baseDirectory.value / "test" / "resources"

// Integration Tests:
lazy val ScalaIntegrationTest = config("itest") extend Test
// Register itest Configuration
configs(ScalaIntegrationTest)
// Initialize itest with Defaults.testSettings
inConfig(ScalaIntegrationTest)(Defaults.testSettings)
// Configure ScalaIntegrationTest:
parallelExecution in ScalaIntegrationTest := false
fork              in ScalaIntegrationTest := true
scalaSource       in ScalaIntegrationTest := baseDirectory.value / "itest" / "scala"
resourceDirectory in ScalaIntegrationTest := baseDirectory.value / "itest" / "resources"

// Acceptance Tests:
lazy val ScalaAcceptanceTest = config("atest") extend Test
// Register atest Configuration
configs(ScalaAcceptanceTest)
// Initialize atest with Defaults.testSettings
inConfig(ScalaAcceptanceTest)(Defaults.testSettings)
// Configure ScalaAcceptanceTest:
parallelExecution in ScalaAcceptanceTest := false
fork              in ScalaAcceptanceTest := true
scalaSource       in ScalaAcceptanceTest := baseDirectory.value / "atest" / "scala"
resourceDirectory in ScalaAcceptanceTest := baseDirectory.value / "atest" / "resources"


/**
  * Coverage:
  */
coverageEnabled in Test := true

coverageEnabled in ScalaIntegrationTest := true

coverageEnabled in ScalaAcceptanceTest := true

/**
  * Swagger:
  */
enablePlugins(SwaggerPlugin)

swaggerV3               := true
swaggerDomainNameSpaces := Seq("controllers", "utils")
swaggerNamingStrategy   := "snake_case"
swaggerPrettyJson       := true

/**
  * Docker:
  */
enablePlugins(DockerPlugin)

// See https://sbt-native-packager.readthedocs.io/en/v1.3.7/formats/docker.html#configuration
// Publish Local as "name:version"
// sbt playGenerateSecret - DO NOT USE DEFAULT HTTP_APPLICATION_SECRET IN DEV/PRODUCTION ; LOCAL USE ONLY!

daemonUser in Docker := name.value
maintainer in Docker := organizationName.value
version    in Docker := version.value

dockerAlias        := DockerAlias(Some("local"), None, name.value, Some("latest"))
dockerBaseImage    := "openjdk:8-jre-slim"
dockerEntrypoint   := Seq("bin/{{cookiecutter.project_slug}}", "-Dpidfile.path=/dev/null")
dockerExposedPorts ++= Seq(9000, 9001)

/**
  * Release:
  */
import ReleaseTransformations._

releaseProcess := Seq[ReleaseStep](
  checkSnapshotDependencies,
  inquireVersions,
  runClean,
  runTest,
  setReleaseVersion,
  commitReleaseVersion,
  tagRelease,
  setNextVersion,
  commitNextVersion
)

/**
  * Hacks:
  */
// Hack #1: Ensure provided dependencies are available in itest and atest.
def configureProvidedModuleID(moduleID: ModuleID): ModuleID = {
  moduleID.configurations match {
    case Some(configurations) if configurations.startsWith("provided")=>
      moduleID.withConfigurations(Some(s"$configurations,${ScalaIntegrationTest.name},${ScalaAcceptanceTest.name}"))
    case _ =>
      moduleID
  }
}