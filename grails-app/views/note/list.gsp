<%@page import="org.apache.commons.lang.StringUtils"%>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: "couchnote.${typedef.type_name}.label", default: typedef.type_name)}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-type" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" mapping="typeMapping" params="${ [type:typeName] }" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-type" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
						<g:each var="field" in="${typedef.fields.entrySet()}">
							<g:render template="table-header-cell" model="['type_name':typedef.type_name, 'field':field]" />
						</g:each>
					</tr>
				</thead>
				<tbody>
				<g:each in="${typeInstanceList}" status="i" var="typeInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<g:each var="field" in="${typedef.fields.entrySet()}" status="index">
							<g:render template="table-cell" model="['index':index, 'field':field, 'type_name':typedef.type_name, 'typeInstance':typeInstance]" />
						</g:each>					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginateWithMapping mapping="typeMapping" mappingParams="${ [type:typeName] }" total="${ typeInstanceTotal }" />
			</div>
		</div>
	</body>
</html>
