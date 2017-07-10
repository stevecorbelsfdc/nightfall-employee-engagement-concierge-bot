({
	getProdRecord : function(component, prodid) {
		var action2 = component.get("c.getRecord"); // method in the apex class
        action2.setParams({ "sfrecordid" : prodid });
        console.log("we have this productid" + prodid );
        action2.setCallback(this, function(a) {
            
         component.set("v.shopitem", a.getReturnValue()[0]);
            console.log("received product " + a.getReturnValue()[1]);
            console.log(a.getReturnValue()[0]);
            
            
        })
       $A.enqueueAction(action2);
    
    },
    
    saveAction : function(component, usetype, recordid){
        
        var action2 = component.get("c.saveArticleAction"); // method in the apex class
        var url = window.location.href;
        action2.setParams({ "recordid" : recordid, "currenturl": url, "UseType": usetype });
        
        action2.setCallback(this, function(a) {
            
         
       console.log('recorded vote');   
            
        })
       $A.enqueueAction(action2);
        
    }
    
    
        
    
    
})