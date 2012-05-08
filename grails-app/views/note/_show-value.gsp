<g:if test="${value instanceof Map && value?.attachment?.link}">
	<g:set var="label" value="${index ? "Link " + index : "Link"}" />
	<g:link url="${value.attachment.link}">${label}</g:link>
</g:if>
<g:elseif test="${value instanceof String && value.startsWith('http://')}">
	<g:link url="${value}">${value}</g:link>
</g:elseif>
<g:elseif test="${value instanceof java.util.Date}">
<%--	<g:datePicker name="ss" value="${value}" disabled="${true}"/>--%>
	<g:formatDate date="${value}"/>
</g:elseif>
<g:else>
	${value}
</g:else>
