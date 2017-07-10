({
	myAction : function(component, event, helper) {
		
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
    
    doInit : function(cmp, event, helper) {
         window.cmp = cmp;
        window.helper = helper;
        
        var action = cmp.get("c.myAppointment");
         action.setParams({ UserId : '005B0000002iQtU'  });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
console.log('incall');

	            if (state === "SUCCESS") {
                var a = response.getReturnValue();
                    console.log('success');
                    cmp.set("v.points", a.features.length);
                    var arrayLength = a.features.length;
for (var i = 0; i < arrayLength; i++) {
    //alert(myStringArray[i]);
    //Do something
    a.features[i].properties['marker-color'] =  a.features[i].properties.marker_color;
                    a.features[i].properties['marker-size'] =  a.features[i].properties.marker_size;
                    a.features[i].properties['marker-symbol'] =  a.features[i].properties.marker_symbol;
                    a.features[i].properties['marker-color'] =  a.features[i].properties.marker_color;
}
                    /**
                    a.features[0].properties['marker-color'] =  a.features[0].properties.marker_color;
                    a.features[0].properties['marker-size'] =  a.features[0].properties.marker_size;
                    a.features[0].properties['marker-symbol'] =  a.features[0].properties.marker_symbol;
                    a.features[1].properties['marker-color'] =  a.features[1].properties.marker_color;
                    a.features[1].properties['marker-size'] =  a.features[1].properties.marker_size;
                    a.features[1].properties['marker-symbol'] =  a.features[1].properties.marker_symbol;
                    **/
             //   str = JSON.stringify(a);
             //   str = helper.replaceAll(str, "marker_","marker-", helper);
             //   var converted  = JSON.parse(str);
             var converted = a;
                    console.log('converted');
                    L.mapbox.accessToken = 'pk.eyJ1Ijoic2RlbWFuIiwiYSI6ImNpeWNtZnhpMDAwb2kzM283ZTU5YzFpbHAifQ.D282PApQ9lyd1i1HxW8onQ';
  
    var featureLayer = L.mapbox.featureLayer()
    .setGeoJSON(converted);
        console.log('beforemap');
        var map = L.mapbox.map('map', 'mapbox.streets');
        window.gogomap = map;
       window._featureLauer = featureLayer;             
                    
                    
                    helper.locateDevice(cmp, event, helper);
      
         featureLayer.addTo(map);          
    
//});
              //  console.log(response.getReturnValue();)
	                //alert("From server: " + response.getReturnValue());
                   // cmp.set("v.timezone" , response.getReturnValue().TimeZone__c);
                   }
            else {}
        }) ;
         $A.enqueueAction(action); 
		//helper.getterr(cmp, event, helper);
	},
    
    scriptsLoaded : function(cmp, event) {
        
        
      
    }
})