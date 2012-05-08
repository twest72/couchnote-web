<g:set var="fieldLabel" value="${message(code: "couchnote.${type_name}.${field.key}.label", default: field.key)}" />
<g:set var="sorted" value="${field.value.sort}" />
<g:set var="show" value="${field.value.data_type != 'Attachment' && field.value.data_type != 'AttachmentList'}" />

<g:if test="${show}">
	<g:if test="${sorted}">
		<g:sortableColumnWithMapping mapping="typeMapping" mappingParams="${[type:type_name]}" property="${field.key}" title="${fieldLabel}" />
	</g:if>
	<g:else>
		<th>${fieldLabel}</th>
	</g:else>
</g:if>

