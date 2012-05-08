import org.codehaus.groovy.grails.commons.GrailsApplication;

import de.aonnet.couchnote.CouchNoteSetup

class BootStrap {
	
	GrailsApplication grailsApplication
	
    def init = { servletContext ->
		CouchNoteSetup setup = new CouchNoteSetup(grailsApplication.config.couchnote)
		setup.prepareDb()
        //new File('/home/westphal/tmp/evernote/20120417.enex').withInputStream { InputStream from ->
		//	setup.importData(from, 'note')
		//}
    }
	
    def destroy = {
    }
}
