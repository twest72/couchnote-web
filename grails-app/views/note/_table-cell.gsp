<g:set var="show" value="${field.value.data_type != 'Attachment' && field.value.data_type != 'AttachmentList'}" />

<g:if test="${show}">
	<g:if test="${index == 0}">
		<td><g:link mapping="typeMapping" params="${ [type:type_name] }" action="show" id="${typeInstance.id}">${typeInstance.value."$field.key"}</g:link></td>
	</g:if>
	<g:else>
		<td>${typeInstance.value."$field.key"}</td>
	</g:else>
</g:if>

