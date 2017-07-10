({
	
    
    
    doInit : function(cmp) {
        if(cmp.get("v.component") == null){return;}
        console.log(cmp.getReference("v.popupdetailid"));
        $A.createComponent(
            cmp.get("v.component"),
            {
               
                popupdetailid : cmp.getReference("v.popupdetailid")
            },
            function(newButton, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newButton);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
    },

    handlePress : function(cmp) {
        console.log("button pressed");
    },
    
    showDetail : function(component, event, helper){
  console.log(event);      
        
  component.set("v.popupdetailid", event.target.id);
        
      
    }
})