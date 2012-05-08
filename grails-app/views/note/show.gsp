<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: "couchnote.${typedef.type_name}.label", default: typedef.type_name)}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-type" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" mapping="typeMapping" params="${ [type:typeName] }" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" mapping="typeMapping" params="${ [type:typeName] }" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-type" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list type">

				<g:each var="entry" in="${typeInstance.entrySet()}">			
				    <g:render template="show-entry" model="['typedef':typedef, 'entry':entry, 'preLabel':'']" />
				</g:each>
			
			</ol>
			<g:form mapping="typeMapping" params="${ [type:typeName] }">
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${typeInstance?._id}" />
					<g:hiddenField name="version" value="${typeInstance?._rev}" />
					<g:link class="edit" mapping="typeMapping" params="${ [type:typeName] }" action="edit" id="${typeInstance?._id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
