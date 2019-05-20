package suites

import org.scalatestplus.play.WsScalaTestClient
import org.scalatestplus.play.guice.GuiceOneAppPerTest
import play.api.test.Injecting

/**
  * A test class to extend when writing integration tests with Play.
  */
abstract class PlayIntegrationSuite
    extends BaseSuiteLike
    with WsScalaTestClient
    with GuiceOneAppPerTest
    with Injecting
