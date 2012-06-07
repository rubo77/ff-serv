// Utility functions for node lists / node view
const listZoom = 14;
const singleNodeZoom = 16;
const worldZoom = 4;
/**
Focus node maper on an Map (Parameter: Latitude, Longitude)
*/
function focusNodeMarker(lat,lng){
	var pos = new L.LatLng(lat,lng);
	this.nodeMarker.setLatLng(pos);
	this.setView(pos,this.getZoom());
}

/**
Creates a new Node map
Options: 
* zoom (of view)
* scrollWheelZoom (use screel wheel - DISABLE for LISTS! )
( Wrapper for L.Map (from leavlet) for displaying node-data )
**/
function createNodeMap(element,options){
	// Default-zoom is 18
	var zoom = (options && options.zoom) ? options.zoom : 4;
	
	// Map may be moved by scrool-weehl
	var scrollWheelZoom = options && options.scrollWheelZoom;
	
	// Init Leaflet-Map
	var map = new L.Map(element,{maxZoom: 18,scrollWheelZoom: scrollWheelZoom});
	
	var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
	var osmAttrib='Map data © OpenStreetMap contributors';
	var osm = new L.TileLayer(osmUrl, {minZoom: 1, maxZoom: 18, attribution: osmAttrib});		

	if(options && options.lat && options.lng){
		var lat = options.lat;
		var lng = options.lng;
		this.map.setView(new L.LatLng(lat,lng));
	}
	map.addLayer(osm);
	map.addNodeMarker = addNodeMarker;
	map.updateLatitudeLongitude = updateLatitudeLongitude;
	map.focusNodeMarker = focusNodeMarker;
	map.setView(new L.LatLng(51.3, 0.7),zoom);
	return map;
}

/**
	Add a node marker for a map
	options: 
	* lat (Latitude) 
	* lng (Longtitude)
	* text (text of popup)
	* showText (display popup)
	* draggable (pointer may be dragged)
	* dragCallback (called on Pointer drags)
**/

function addNodeMarker(options){
	if(!options){
		return;
	}
	var lat = options.lat;
	var lng = options.lng;
	var text = options.text;
	var showText = options.showText;
	var draggable = options.draggable;
	var dragCallback = options.dragCallback;

	var pos = new L.LatLng(lat,lng);
	var marker = new L.Marker(pos,{draggable: draggable});
	
	//If markers can be dragged, updating their position should be possible
	if(dragCallback){
		marker.on('dragend', function(e) {
			dragCallback(marker.getLatLng())
		});
		marker.on('drag', function(e) {
			dragCallback(marker.getLatLng())
		});
	}
	//Text and show text?
	if(text){
		marker.bindPopup(text)
	}
	
	if(showText){
		marker.openPopup()
	
	}
	this.setView(pos,this.getZoom());
	this.addLayer(marker);
	return marker;
}

