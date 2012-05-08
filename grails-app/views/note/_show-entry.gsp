<g:if test="${!entry.key.startsWith('_') && entry.key != 'type'}">

	<g:set var="plainFieldLabel" value="${message(code: "couchnote.${typedef.type_name}.${entry.key}.label", default: entry.key)}" />
	<g:set var="preFieldLabel" value="${message(code: "couchnote.${typedef.type_name}.${preLabelKey}.label", default: preLabelKey)}" />
	<g:set var="fieldLabel" value="${(preFieldLabel ? (preFieldLabel + '/') : '') + plainFieldLabel}" />

	<li class="fieldcontain">
		    <g:if test="${entry.value instanceof Map}">
		    
			    <g:if test="${entry.value?.attachment?.link}">
					<span id="${entry.key}-label" class="property-label">${fieldLabel}</span>
			        <span class="property-value" aria-labelledby="${key}-label">
			        	<g:render template="show-value" model="['value':entry.value]" />
			        </span>
			        
				</g:if>
				<g:else>
				    <g:each var="innerEntry" in="${entry.value.entrySet()}">
				        <g:render template="show-entry" model="['typedef':typedef, 'entry':innerEntry, 'preLabelKey':entry.key]" />
				    </g:each>
				</g:else>
		    </g:if>
		    <g:elseif test="${entry.value instanceof List}">
				<span id="${entry.key}-label" class="property-label">${fieldLabel}</span>
				<span class="property-value" aria-labelledby="${entry.key}-label">
			    <g:each var="innerValue" in="${entry.value}" status="index">
					
					<g:set var="separator" value="${index < entry.value.size() - 1 ? ", " : ""}" />
			    
				    <g:if test="${innerValue instanceof Map && innerValue?.attachment?.link}">
				        <g:render template="show-value" model="['value':innerValue, 'index':index + 1]" />${separator}
				    </g:if>
				    <g:else>
				    	${(innerValue as String) + separator}
				    </g:else>
			    </g:each>
			    </span>
		    </g:elseif>
		    <g:else>
				<span id="${entry.key}-label" class="property-label">${fieldLabel}</span>
			    <span class="property-value" aria-labelledby="${entry.key}-label">
			    	<g:render template="show-value" model="['value':entry.value]" />
			    </span>
		    </g:else>
	</li>
</g:if>
