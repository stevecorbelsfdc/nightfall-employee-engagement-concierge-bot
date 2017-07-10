({
	replaceAll : function(str, find, replace, helper) {
		
 
  return str.replace(new RegExp(helper.escapeRegExp(find), 'g'), replace);

        
        
	},
    
    escapeRegExp : function(str) {
    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
},
    
    locateDevice : function(cmp, event, helper){
        
     
    if (navigator.geolocation) {
        window.cmp = cmp;
        window.helper = helper;
        navigator.geolocation.getCurrentPosition(helper.showPosition);
    } else {
        x.innerHTML = "Geolocation is not supported by this browser.";
    }
},
    
    showPosition : function(position){
      cmp = window.cmp;
        helper = window.helper;
    // console.log(position);
      var geocoder = L.mapbox.geocoder('mapbox.places');
  	//cmp.set("v.newLocationLon", position.coords.longitude);
    //      	cmp.set("v.newLocationLat", position.coords.latitude);
        var map = window.gogomap;
var featureLayer    =     window._featureLauer;
        console.log('number features:');
        if(featureLayer.getLayers().length == 0){
            var store1 = L.marker([position.coords.latitude + 0.20, position.coords.longitude + 0.10], {
    icon: L.mapbox.marker.icon({
        'marker-size': 'large',
        'marker-symbol': 'building',
        'marker-color': '#f44'
    }), title: 'Store'
});
                    var store2 = L.marker([position.coords.latitude - 0.15, position.coords.longitude + 0.08], {
    icon: L.mapbox.marker.icon({
        'marker-size': 'large',
        'marker-symbol': 'building',
        'marker-color': '#f44'
    }), title : 'Store'
});
            
            featureLayer.addLayer(store1);
            featureLayer.addLayer(store2);
        }
        var marker = L.marker([position.coords.latitude, position.coords.longitude]);
        featureLayer.addLayer(marker);
        map.fitBounds(featureLayer.getBounds());          
        //geocoder.reverseQuery([position.coords.longitude, position.coords.latitude], helper.geoResult);
        
    },
})