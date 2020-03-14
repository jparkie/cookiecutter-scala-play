#if ((${PACKAGE_NAME} && ${PACKAGE_NAME} != ""))package ${PACKAGE_NAME} #end
#parse("File Header.java")

import com.google.inject.{ImplementedBy, Inject, Singleton}
import models.{${NAME.replaceAll("Repository", "")}}
import play.api.db.slick.{DatabaseConfigProvider, HasDatabaseConfigProvider}
import play.db.NamedDatabase
import tables.DBProfile.api._
import tables.{${NAME.replaceAll("Repository", "")}Table, DBProfile}

import scala.async.Async.{async, await}
import scala.concurrent.{ExecutionContext, Future}

@ImplementedBy(classOf[${NAME.replaceAll("Repository", "")}Repository.DefaultRepository])
trait ${NAME.replaceAll("Repository", "")}Repository
    extends ${NAME.replaceAll("Repository", "")}Repository.${NAME.replaceAll("Repository", "")}Action[Future]
    
object ${NAME.replaceAll("Repository", "")}Repository {
    
    trait ${NAME.replaceAll("Repository", "")}Action[C[_]] {
        
        def upsert(value: ${NAME.replaceAll("Repository", "")}): C[Int]
        
        def delete(id: Int): C[Int]
        
        def readAll(): C[Seq[${NAME.replaceAll("Repository", "")}]]
        
        def read(id: Int): C[${NAME.replaceAll("Repository", "")}]
        
    }
    
    class ${NAME.replaceAll("Repository", "")}DBIO()(implicit executionContext: ExecutionContext)
        extends ${NAME.replaceAll("Repository", "")}Action[DBIO] {
        
        private val query: TableQuery[${NAME.replaceAll("Repository", "")}Table] =
            TableQuery[${NAME.replaceAll("Repository", "")}Table]
            
        override def upsert(value: ${NAME.replaceAll("Repository", "")}): DBIO[Int] = {
            query.insertOrUpdate(value)
        }
        
        override def delete(id: Int): DBIO[Int] = {
            query
                .filter(row => row.id === id)
                .delete
        }
        
        override def readAll(): DBIO[Seq[${NAME.replaceAll("Repository", "")}]] = {
            query
                .result
        }
        
        override def read(id: Int): DBIO[${NAME.replaceAll("Repository", "")}] = {
            query
                .filter(row => row.id === id)
                .take(1)
                .result
                .head
        }
        
    }
    
    @Singleton
    class DefaultRepository @Inject()(
        @NamedDatabase("{{cookiecutter.project_slug}}") protected val dbConfigProvider: DatabaseConfigProvider
    )(implicit executionContext: ExecutionContext)
        extends HasDatabaseConfigProvider[DalloPostgresProfile]
        with ${NAME.replaceAll("Repository", "")}Repository {
        
        private val queryDBIO = new ${NAME.replaceAll("Repository", "")}DBIO()
        
        override def upsert(value: ${NAME.replaceAll("Repository", "")}): Future[Int] = {
            db.run {
                queryDBIO.upsert(value)
            }
        }
        
        override def delete(id: Int): Future[Int] = {
            db.run {
                queryDBIO.delete(id)
            }
        }
        
        override def readAll(): Future[Seq[${NAME.replaceAll("Repository", "")}]] = {
            db.run {
                queryDBIO.readAll()
            }
        }
        
        override def read(id: Int): Future[${NAME.replaceAll("Repository", "")}] = {
            db.run {
                queryDBIO.read(id)
            }
        }
        
    }
    
}
