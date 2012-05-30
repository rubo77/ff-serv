var map;
var ajaxRequest;
var plotlist;
var plotlayers=[];

function initmap(elem,latitude, longitude,zoom) {
	// set up the map
	map = new L.Map(elem,{maxZoom: 18});

	// create the tile layer with correct attribution
	var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
	var osmAttrib='Map data © OpenStreetMap contributors';
	var osm = new L.TileLayer(osmUrl, {minZoom: 1, maxZoom: 18, attribution: osmAttrib});		

	// start the map in South-East England
	map.setView(new L.LatLng(51.3, 0.7),4);
	map.addLayer(osm);
	
	if(latitude != null && longitude != null){
		focusPointer(latitude,longitude,false,zoom);
	}
}

function initmapAutoComplete(field){
	$( field ).autocomplete({
				minLength: 5,
				delay: 750,
				source: 'lookup.json',
				select: function(event, ui) { focusPointer(ui.item.data.lat,ui.item.data.long,true,16) },
				search: function(event, ui) { showAjaxSpinner(true);},
				open: function(event, ui) { showAjaxSpinner(false);}
	});
}
function focusPointer(lat,lng,showPopup,zoom){
	var marker;
	var markerLocation = new L.LatLng(lat,lng);
	if(marker == null){
		marker = new L.Marker(markerLocation,{draggable: true});
		marker.on('dragend', function(e) {
			updateLatitudeLongitude(marker.getLatLng())
		});
		marker.on('drag', function(e) {
			updateLatitudeLongitude(marker.getLatLng())
		});
	}else{
		marker.setLatLng(markerLocation);
	}
	map.setView(markerLocation,zoom);
	map.addLayer(marker);
	if(showPopup){
		marker.bindPopup("<b> Bitte bewege mich!</b><br />Ziehe den Marker zum Aufstellort.").openPopup();
	}
	updateLatitudeLongitude(marker.getLatLng())	

}

function updateLatitudeLongitude(latlng){
	$('#node_registration_latitude').val(latlng.lat)
	$('#node_registration_longitude').val(latlng.lng)	
}

function showAjaxSpinner(show){
	if(show){
		$('#ajax-loader').show();
	}else{
		$('#ajax-loader').hide();
	}
}