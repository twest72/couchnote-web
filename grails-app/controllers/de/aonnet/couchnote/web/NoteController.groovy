package de.aonnet.couchnote.web

import groovy.json.JsonOutput
import groovy.util.logging.Commons

import java.text.DateFormat
import java.text.ParseException;
import java.text.SimpleDateFormat


import de.aonnet.couchnote.CouchNote
import de.aonnet.couchnote.CouchNoteTypedef
import de.aonnet.gcouch.GroovyCouchDb

@Commons
class NoteController {

	DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssX")
	
	GroovyCouchDb couchDb
	CouchNoteTypedef couchNoteTypedef
	
	def index() {
		
		// TODO list all types
		if (!params.type) {
			params.type = 'note'
		}
		redirect(mapping: 'typeMapping', action: 'list', params: params)
	}

	def list() {
		String typeName = params.type.toUpperCase()
		
		Map<String, Object> noteTypedef = couchNoteTypedef.typedefs[typeName]

		// fill the pagination params
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		params.offset = params.offset ?: 0

		// map the pagination
		Map viewOptions = [limit: params.max, skip: params.offset]

		// map the sort order
		viewOptions.put('descending', params.order == 'desc' ? 'true' : 'false')

		// map the sort by criteria: switch to the right view
		String view
		if (params.sort && noteTypedef.fields.containsKey(params.sort)) {
			view = couchNoteTypedef.createTypeViewName typeName, params.sort
		} else {
			view = couchNoteTypedef.createTypeViewName typeName
		}

		Map viewResult = couchDb.view(CouchNote.DESIGN_DOC_ALL, view, viewOptions)

		[typeName: typeName, typedef: noteTypedef, typeInstanceList: viewResult.rows, typeInstanceTotal: viewResult.total_rows]
	}

	def create() {
		String typeName = params.type.toUpperCase()
		println typeName
		Map<String, Object> noteTypedef = couchNoteTypedef.typedefs[typeName]
		println noteTypedef
		[typeName: typeName, typedef: noteTypedef, typeInstance: [:]]
	}

	def save() {
		String typeName = params.type.toUpperCase()
		
		Map<String, Object> noteTypedef = couchNoteTypedef.typedefs[typeName]
		
		String type = noteTypedef.type_name
		Map newType = [type: type]
		copyFields(typeName, params, newType)

		def result = couchDb.create(newType)
		def typeInstance = couchDb.read(result.id)

		println "typeInstance: $typeInstance"

		if (!typeInstance) {
			render(view: 'create', model: [typedef: noteTypedef, typeInstance: typeInstance])
			return
		}

		flash.message = message(code: 'default.created.message', args: [
			getTypeNameLabel(typeName),
			typeInstance._id
		])
		redirect(mapping: 'typeMapping', params:[type:typeName], action: 'show', id: typeInstance._id)
	}

	def show() {
		String typeName = params.type.toUpperCase()

		Map<String, Object> noteTypedef = couchNoteTypedef.typedefs[typeName]
		
		def typeInstance = couchDb.read(params.id)
		if (!typeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [getTypeNameLabel(typeName), params.id])
			redirect(mapping: 'typeMapping', params:[type:typeName], action: 'list')
			return
		}
		
		log.debug("TypeInstance orginal: $typeInstance")
		typeInstance = couchNoteTypedef.transformTypeInstance(typeName, typeInstance._id, typeInstance)
		log.debug("TypeInstance transformed: $typeInstance")
		
		[typeName: typeName, typedef: noteTypedef, typeInstance: typeInstance]
	}
	
	def edit() {
		String typeName = params.type.toUpperCase()
		
		Map<String, Object> noteTypedef = couchNoteTypedef.typedefs[typeName]
		
		def typeInstance = couchDb.read(params.id)
		if (!typeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [
				getTypeNameLabel(typeName),
				params.id
			])
			redirect(mapping: 'typeMapping', params:[type:typeName], action: 'list')
			return
		}

		println "typeInstance: $typeInstance"
		println "noteTypedef: $noteTypedef"
		[typeName: typeName, typedef: noteTypedef, typeInstance: typeInstance]
	}

	def update() {
		String typeName = params.type.toUpperCase()
		
		Map<String, Object> noteTypedef = couchNoteTypedef.typedefs[typeName]
		
		def typeInstance = loadTypeInstanceAndFailureRedirect(typeName, params.id)
		if (!typeInstance) {
			return
		}

		if (params.version) {
			def version = params.version
			if (typeInstance._rev != version) {
				typeInstance.errors.rejectValue('version', 'default.optimistic.locking.failure',
						  [getTypeNameLabel(typeName)] as Object[],
						  'Another user has updated this Type while you were editing')
				render(view: 'edit', model: [typedef: noteTypedef, typeInstance: typeInstance])
				return
			}
		}
		
		copyFields(typeName, params, typeInstance)

		def result = couchDb.update(typeInstance._id, typeInstance)

		if (!result.id || !result.rev) {
			render(view: 'edit', model: [typedef: noteTypedef, typeInstance: typeInstance])
			return
		}

		flash.message = message(code: 'default.updated.message', args: [getTypeNameLabel(typeName), typeInstance._id])
		redirect(mapping: 'typeMapping', params:[type:typeName], action: 'show', id: typeInstance._id)
	}

	def delete() {
		String typeName = params.type.toUpperCase()
		
		Map<String, Object> noteTypedef = couchNoteTypedef.typedefs[typeName]
		
		def result = couchDb.delete(params.id, params.version)
		
		if(true) {
			flash.message = message(code: 'default.deleted.message', args: [getTypeNameLabel(typeName), params.id])
			redirect(mapping: 'typeMapping', params:[type:typeName], action: 'list')
		} else {
			flash.message = message(code: 'default.not.deleted.message', args: [getTypeNameLabel(typeName), params.id])
			redirect(mapping: 'typeMapping', params:[type:typeName], action: 'show', id: params.id)
		}
	}

	private Map loadTypeInstanceAndFailureRedirect(String typeName, String id) {
		
		def typeInstance = couchDb.read(id)
		
		if (!typeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [getTypeNameLabel(typeName), id])
			redirect(mapping: 'typeMapping', params:[type:typeName], action: 'list')
		}
		
		return typeInstance
	}
		
	private copyFields(String typeName, Map sourceType, Map targetType) {
		Map<String, Object> noteTypedef = couchNoteTypedef.typedefs[typeName]
		
		noteTypedef.fields.each { String fieldName, Map fieldValue ->
			
			if(sourceType.containsKey(fieldName)) {
				targetType.put(fieldName, sourceType.get(fieldName))
			}
		}
	}

	private getTypeNameLabel(String typeName) {
		Map<String, Object> noteTypedef = couchNoteTypedef.typedefs[typeName]
		message(code: "couchnote.${noteTypedef.type_name}.label", default: noteTypedef.type_name)
	}
}
