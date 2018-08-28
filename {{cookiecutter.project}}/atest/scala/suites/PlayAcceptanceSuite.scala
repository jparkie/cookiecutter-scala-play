package suites

import com.dimafeng.testcontainers.ForAllTestContainer
import org.scalatest.GivenWhenThen
import org.scalatestplus.play.WsScalaTestClient
import org.scalatestplus.play.guice.GuiceOneAppPerSuite
import play.api.test.Injecting

/**
  * A test class to extend when writing acceptance tests with Play.
  * - Provides Docker containers through the use of testcontainer-scala.
  *
  * @see [[https://github.com/testcontainers/testcontainers-scala]].
  */
abstract class PlayAcceptanceSuite extends BaseSuiteLike
  with WsScalaTestClient
  with GuiceOneAppPerSuite
  with Injecting
  with ForAllTestContainer
  with GivenWhenThen
