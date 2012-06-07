const node_lat_field = '#node_registration_latitude';
const node_lng_field = '#node_registration_longitude';
const reg_autocomplete_field = '#node_registration_standort';
const node_reg_map_div = '#map';
const ajaxField = '#ajax-loader';

// Update fields in Node-Registration
function updateLatitudeLongitude(latlng){
	$( node_lat_field ).val(latlng.lat)
	$( node_lng_field ).val(latlng.lng)	
}

// Map in Node-List

function initMapsInNodeList(mapDivs){
	$(mapDivs).each(function(key,value){
		var elem = $(value);
		var lat = elem.attr("lat");
		var lng = elem.attr("lng");
		var map = createNodeMap(value, {
			zoom: 				listZoom, 
			scrollWheelZoom: 	false
		});
		map.nodeMarker = map.addNodeMarker({
			lat: lat,
			lng: lng,
			text: "",
			showText: false,
			draggable: false
		});
	});
}

// Map in Node-Registration
function initMapInNodeRegistration(options){
	if(!options){
		return;
	}
	// Parse Options
	var lat = options.lat;
	var lng = options.lng;
	var markerDraggable = options.markerDraggable;

	// Additional, dom dependend options
	var mapDiv = $( node_reg_map_div )[0]
	var autoComplField = $( reg_autocomplete_field )[0]
	
	// Build map
	var map = createNodeMap(mapDiv, {
		zoom: 				singleNodeZoom,
		scrollWheelZoom: 	true
	});
	$( autoComplField ).autocomplete({
		minLength: 5,
		delay: 750,
		source: 'lookup.json',
		select: function(event, ui) {
			handleSelect(map,ui.item); 
		},
		search: function(event, ui) { 
			$( ajaxField ).show();
		},
		open: function(event, ui) { 
			$( ajaxField ).hide();
		}
	});
	if(lat && lng){
		map.nodeMarker = map.addNodeMarker({
			lat: lat,
			lng: lng,
			text: "<b> Bitte bewege mich!</b><br />Ziehe den Marker zum Aufstellort.",
			showText: false,
			draggable: markerDraggable,
			dragCallback: updateLatitudeLongitude
		});
		map.setZoom(singleNodeZoom)
	} else {
		map.setZoom(worldZoom)
	}
	return map;
}

/**
 Handle selection in automcomplete
**/
function handleSelect(map,item){
	//Is there a node marker? If not, construct one
	var lat = item.data.lat
	var lng = item.data.long

	if(!map.nodeMarker){
		map.nodeMarker = map.addNodeMarker({
			lat: lat,
			lng: lng,
			text: "<b> Bitte bewege mich!</b><br />Ziehe den Marker zum Aufstellort.",
			showText: true,
			draggable: true,
			dragCallback: updateLatitudeLongitude
		});
		map.setZoom(singleNodeZoom)
	} else {
		map.focusNodeMarker(lat,lng)
		map.nodeMarker.openPopup();
	}
}

function buildNodeMarker(map,showPopup){
	
}