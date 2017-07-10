({
    doInit : function(component, event, helper) {
        window.cmp = component;
        window._cmp = component;   
        window._helper = helper;
        var sampleConversation = [
            "Hi"
            
        ];
        var config = {
            botName: 'fromThem',
            inputs: '#humanInput',
            inputCapabilityListing: true,
            engines: [kbChatEngine()],
            addChatEntryCallback: function(entryDiv, text, origin) {
         
            }
        };
        ChatBot.init(config);
        ChatBot.setBotName("fromThem");
     
        
        ChatBot.addPattern("(?:chat|talk) (.*) (?:agent|human)$", "response", undefined, function (matches) {
            //helper.inlineChat(component, helper);
            component.set("v.prechat" , true);
            helper.addMessage(component, helper, "To give you the best service possible please provide your email address","bot");
            // ChatBot.setHumanName(matches[1]);
        },"Say 'talk to agent' to chat with an agent");
        
        ChatBot.addPattern("(?:my|nearest)*(?:store|bank)$", "response", undefined, function (matches) {
            // helper.startChat(component, helper);
            helper.addMessage(component, helper, "Your nearest store is here","bot", 'c:gogoMap', 'gogomap');
            
        },"Say 'my store' see your closest store");
        
        ChatBot.addPattern("(?:my|open) * (?:case|issue)$", "response", undefined, function (matches) {
            // helper.startChat(component, helper);
            helper.addMessage(component, helper, "Here are your open cases","bot", 'c:OpenCasesWidget', 'opencasewidget');
            
        },"Say 'open cases' to see your open cases");
        
        ChatBot.addPattern("(?:screenshot|xxx)$", "response", undefined, function (matches) {
            // helper.startChat(component, helper);
      helper.screenShot(component, event, helper);
            // helper.addMessage(component, helper, "Here are your open cases","bot", 'c:OpenCasesWidget');
            
        },"Say 'screenshot' to send a screenshot");
        
        ChatBot.addPattern("^hi$", "response", "Howdy, friend", undefined, "Say 'Hi' to be greeted back.");
        ChatBot.addPattern("^bye$", "response", "See you later buddy", undefined, "Say 'Bye' to end the conversation.");
        
        helper.addMessage(component, helper, "How can I help you today?","bot");        
    },
    hideModal : function(component, event, helper) {
        //Toggle CSS styles for hiding Modal
        helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
        helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
    },
    
    scrollDown: function(component, event, helper) {
        console.log('changeload');
        console.log(component.get("v.messloaded"));
        if(component.get("v.messloaded") == true){
            
            var focusBottom = document.getElementById("adobewordpress");
            console.log(focusBottom);
            //  focusBottom.scrollTop = focusBottom.scrollHeight - focusBottom.clientHeight;
            
            console.log('finished');
        }
        
        // var focusBottom = document.getElementById("adobewordpress");
        //    focusBottom.scrollTop = focusBottom.scrollHeight;
        
    },
    
    
    
    showDetail : function(component, event, helper){
        console.log(event);      
        
        component.set("v.popupdetailid", event.target.id);
        helper.toggleClass(component,'backdrop','slds-backdrop--');
        helper.toggleClass(component,'modaldialog','slds-fade-in-');
    },
    
    showMod : function(component, event, helper){
        
        helper.toggleClass(component,'backdrop','slds-backdrop--');
        helper.toggleClass(component,'modaldialog','slds-fade-in-');
        //slds-is-open
    },
    
    toggleChatbot : function(component, event, helper){
        $A.util.toggleClass(component.find('chatbotwindow').getElement(),'slds-is-open');
        $A.util.toggleClass(component.find('chatform').getElement(),'toggle');
        //slds-is-open
    },
    
    startChat : function(component, event, helper){
        helper.inlineChat(component, helper);
    }
})