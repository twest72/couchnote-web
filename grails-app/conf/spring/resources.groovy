import de.aonnet.couchnote.CouchNoteSetup;
import de.aonnet.couchnote.CouchNoteTypedef;
import de.aonnet.gcouch.GroovyCouchDb;

// Place your Spring DSL code here
beans = {
	couchDb(GroovyCouchDb) {
		host = grailsApplication.config.couchnote.couchdb.connection.host
		dbName = grailsApplication.config.couchnote.couchdb.connection.dbName
	}
	
	couchNoteTypedef(CouchNoteTypedef, couchDb) {
	}
}
