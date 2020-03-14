package tables

import com.github.tminglei.slickpg._
import com.github.tminglei.slickpg.trgm.PgTrgmSupport
import slick.basic.Capability
import slick.jdbc.JdbcCapabilities

// scalastyle:off
trait DBProfile
    extends ExPostgresProfile
    with PgArraySupport
    with PgPlayJsonSupport
    with PgSearchSupport
    with PgTrgmSupport {

  override def pgjson = "json"

  override protected def computeCapabilities: Set[Capability] =
    super.computeCapabilities + JdbcCapabilities.insertOrUpdate

  override val api = DBAPI

  object DBAPI
      extends API
      with ArrayImplicits
      with JsonImplicits
      with SearchImplicits
      with SearchAssistants
      with SimpleArrayPlainImplicits
      with PgTrgmImplicits

}

object DBProfile extends DBProfile
// scalastyle:on
