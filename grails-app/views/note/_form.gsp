<g:each var="field" in="${fields.entrySet()}">

	<g:set var="required" value="${field.value.required}" />
	<g:set var="fieldLabel" value="${message(code: "couchnote.${type_name}.${field.key}.label", default: field.key)}" />

	<div class="fieldcontain ${required ? 'required' : ''} ">
		<label for="${field.key}">${fieldLabel}</label>
		<g:if test="${required}">
			<g:textField name="${field.key}" value="${typeInstance?.getAt(field.key)}" required=""/>
		</g:if>
		<g:else>
			<g:textField name="${field.key}" value="${typeInstance?.getAt(field.key)}"/>
		</g:else>
	</div>
</g:each>
