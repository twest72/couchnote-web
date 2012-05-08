class UrlMappings {

	static mappings = {
		name typeMapping: "/type/$action/$type/$id?"(controller:'note')
		
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		'/'(view:'/index')
		'500'(view:'/error')
	}
}
