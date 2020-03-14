#if ((${PACKAGE_NAME} && ${PACKAGE_NAME} != ""))package ${PACKAGE_NAME} #end
#parse("File Header.java")

import models.{${NAME.replaceAll("Table", "")}}
import tables.DBProfile.api._

// scalastyle:off
class ${NAME.replaceAll("Table", "")}Table(tag: Tag) extends Table[${NAME.replaceAll("Table", "")}](tag, "${NAME.replaceAll("Table", "")}") {

    def id =
        column[Int]("id", O.AutoInc)
        
    def * =
        (
            id,
            // TODO: Insert column representations.
        ).mapTo[${NAME.replaceAll("Table", "")}]

    def pk =
        primaryKey(/* TODO: Replace pk. */"pk", id)

    def idFk =
        foreignKey(
            /* TODO: Replace idFk. */"id_fk",
            id,
            TableQuery[???]
        )(otherRow => otherRow.id)

    def idUIndex =
        index(/* TODO: Replace idUIndex. */"id_uindex", id, unique = true)

}
// scalastyle:on
