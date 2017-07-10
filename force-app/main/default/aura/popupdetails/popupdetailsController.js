({
    doInitNew : function(component, event, helper) {},
	doInit : function(component, event, helper) {
        if(component.get("v.sfrecordid") == ''){
            return;
        }
        var action2 = component.get("c.getRecord"); // method in the apex class
        var url = window.location.href;
        action2.setParams({ "sfrecordid" : component.get("v.sfrecordid") , "currenturl" : url });
       // action2.setParams({ });
        console.log("we have this recordid" + component.get("v.sfrecordid") );
        action2.setCallback(this, function(a) {
            var sftypep = a.getReturnValue()[1];
            console.log ('before if found ' + sftypep);
            if(sftypep == 'Recommendation__c'){
                console.log('found' + sftypep);
                helper.getProdRecord(component, a.getReturnValue()[0].Product__c);
            } else {
                console.log('found something else');
            }
            component.set("v.sfrecord", a.getReturnValue()[0]); // variable in the component
            component.set("v.sftype", a.getReturnValue()[1]);
            console.log("received object " + a.getReturnValue()[1]);
            
            console.log(a.getReturnValue());
        })
        $A.enqueueAction(action2);
        
	},
    
    doUpdate : function(component, event, helper) {
		        if(component.get("v.sfrecordid") == ''){
            return;
        }
        var action2 = component.get("c.getRecord"); // method in the apex class
        var url = window.location.href;
        action2.setParams({ "sfrecordid" : component.get("v.sfrecordid"), "currenturl" : url, 'viewedfrom' : component.get("v.viewedfrom") });
        //action2.setParams({ });
        console.log("we have this recordid" + component.get("v.sfrecordid") );
        action2.setCallback(this, function(a) {
            component.set("v.sfrecord", a.getReturnValue()[0]); // variable in the component
            console.log("received object " + a.getReturnValue()[1]);
            component.set("v.sftype", a.getReturnValue()[1]);
            console.log(a.getReturnValue());
            var sftypep = a.getReturnValue()[1];
            if(sftypep == 'Recommendation__c'){
                console.log('found' + sftypep);
                helper.getProdRecord(component, a.getReturnValue()[0].Product__c);
            } else if (sftypep == "shopitem__c"){
                       
             component.set("v.shopitem", a.getReturnValue()[0]);          
                console.log('found product');
            }
            
            
        })
        $A.enqueueAction(action2);
        
	},
    addtocart : function(component, event, helper){
        console.log('see if we are in chat');
        if (typeof liveagent != "undefined") {
                        console.log('send bought');
            liveagent.chasitor.sendCustomEvent('addtocart', component.get("v.shopitem.Name"));

}
    },   
    
    upvote : function(component, event, helper){
        console.log('see if we are in chat');
        helper.saveAction(component, 'Upvote', component.get("v.sfrecord.Id"));
        
        if (typeof liveagent != "undefined") {
                        console.log('upvote');
            liveagent.chasitor.sendCustomEvent('upvote', component.get("v.sfrecord.Title"));

}
    },
 downvote : function(component, event, helper){
        console.log('see if we are in chat');
     helper.saveAction(component, 'downvote', component.get("v.sfrecord.Id"));
        if (typeof liveagent != "undefined") {
                        console.log('send bought');
            liveagent.chasitor.sendCustomEvent('downvote', component.get("v.sfrecord.Title"));
        
}
    }
 
})