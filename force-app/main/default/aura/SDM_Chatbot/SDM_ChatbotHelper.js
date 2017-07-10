({
    helperMethod : function() {
        
    },
    toggleClass: function(component,componentId,className) {
        console.log('in helper toggle');
        var modal = component.find(componentId);
        $A.util.removeClass(modal.getElement(),className+'hide');
        $A.util.addClass(modal.getElement(),className+'open');
    },
    
    toggleClassInverse: function(component,componentId,className) {
        var modal = component.find(componentId);
        $A.util.addClass(modal.getElement(),className+'hide');
        $A.util.removeClass(modal.getElement(),className+'open');
    },
    
    clientSendLa : function(component, helper, text){
        
        var sequence = component.get("v.sequence");
        sequence = sequence + 1;
        component.set("v.sequence", sequence);
        //sendLAMessage(String key, String affinity, String text, Integer sequence)
        var action2 = component.get("c.sendLAMessage"); // method in the apex class
        console.log(component.get("v.lasessionid"));
        action2.setParams({ key : component.get("v.lasessionid").key, affinity : component.get("v.lasessionid").affinityToken, text: text, sequence : ''+sequence+'' });
        
        
        action2.setCallback(this, function(a) {
            console.log(a.getReturnValue());
            component.set("v.waiting", false);
            helper.getLAmessage(component,helper);
        })
        $A.enqueueAction(action2);        
        
        
    },
    
    react : function(query, component, helper){
        // ChatBot.addChatEntry('KBEngine in Helper', "bot");
        
        if(component.get("v.inLA") == true){
            component.set("v.waiting", true);   
            helper.clientSendLa(component, helper, query);
            ChatBot.thinking(false);
        }  else if(component.get("v.prechat") == true){
        

            component.set("v.prechat", false);
            helper.inlineChat(component, helper, query);
             ChatBot.thinking(false);
        }  else {
            
            helper.searchKB(query, component, helper);
            ChatBot.thinking(false);
        }
    },
    searchKB : function(query, component, helper) {
        
        //searchForPage(String searchstring, String currenturl){
        var action2 = component.get("c.searchForPage"); // method in the apex class
        var url = window.location.href;
        action2.setParams({ "searchstring" : query , "currenturl" : url });
        // action2.setParams({ });
        // console.log("we have this recordid" + component.get("v.sfrecordid") );
        action2.setCallback(this, function(a) {
            
            var returnkav = a.getReturnValue();
            var arrayLength = returnkav.length;
            if(arrayLength > 0 ){
                //           ChatBot.addChatEntry('Maybe this can help:', "bot");
                //           
                helper.addMessage(component, helper,"Maybe this helps:", "bot", null, null);                
                
                
            } else {
                helper.addMessage(component, helper,"Hmmm, I don't know, want to talk to a human?", "bot", null, null);
                component.set("v.offerChat", true);                
            }
            var messages=component.get("v.messages");
            
            
            for (var i = 0; i < arrayLength && i < 3; i++) {
                // alert(myStringArray[i]);
                //  ChatBot.addChatEntry(returnkav[i].snippet , "bot");   
                var text  = '<i>' + returnkav[i].kav.Summary +'</i><p/>'   + returnkav[i].snippet    
                var message = {id : returnkav[i].kav.Id,  from : 'fromThem', link : returnkav[i].kav.Title, text : text, avatar:  $A.get('$Resource.sdm_astro')
                              };
                messages.push(message);
                //Do something
            }
            component.set("v.messages", messages);
            //   ChatBot.addChatEntry('In callback', "bot");
            
            console.log(a.getReturnValue());
            //   var focusBottom = document.getElementById("adobewordpress");
            //   focusBottom.scrollTop = focusBottom.scrollHeight - focusBottom.clientHeight;
            
        })
        $A.enqueueAction(action2);
        $A.run(function(){console.log('hi')});
    },
    
    inlineChat : function(component, helper, email){
        
        var action2 = component.get("c.startLASession"); // method in the apex class
        
        action2.setParams({email: email });
        
        
        action2.setCallback(this, function(a) {
            var sessionid = a.getReturnValue();
            //console.log ('before if found ' + sftypep);
            console.log(a.getReturnValue());
            component.set("v.lasessionid", a.getReturnValue()); // variable in the component
            $A.run(function(){console.log('hi')});
            component.set("v.inLA", true);
            helper.getLAmessage(component,helper);
            
            
            
        })
        $A.enqueueAction(action2);        
        $A.run(function(){console.log('hi')});
    },
    
    getLAmessage : function(component, helper){
        console.log('getting messages');
        if(component.get("v.waiting") == true || component.get("v.inLA") == false){
            //console.log('false message');
            return;
        }
        var action2 = component.get("c.LAMessages"); // method in the apex class
        
        console.log(component.get("v.lasessionid"));
        action2.setParams({ key : component.get("v.lasessionid").key, affinity : component.get("v.lasessionid").affinityToken });
        
        
        action2.setCallback(this, function(a) {
            //console.log('in callback get messages');
            var messagestring = a.getReturnValue();
            
            if(messagestring != null){
                var messages = JSON.parse(messagestring);
                //console.log(messages);
                
                if(messages.messages.length > 0){
                    
                    
                    var arrayLength = messages.messages.length;
                    for (var i = 0; i < arrayLength; i++) {
                        var tm = messages.messages[i];
                        if(tm.type == 'ChatMessage'){
                            helper.addMessage(component, helper, tm.message.text, 'agent');
                        } else if(tm.type == 'ChatRequestSuccess'){
                            
                            helper.addMessage(component,helper, 'Waiting for Agent', 'bot');
                        } else if(tm.type == 'ChatEstablished'){
                            helper.addMessage(component,helper, 'Connected to ' + tm.message.name, 'bot');
                            
                            
                        } else if(tm.type == 'ChatEnded'){
                            helper.addMessage(component,helper, 'Chat ended by ' + tm.message.reason, 'bot');
                            helper.addMessage(component,helper, 'How would you rate the chat?', 'bot', 'c:ratechat' , 'ratethischat');
                            component.set("v.inLA", false);
                        }
                        
                    }
                    
                }}
            if(component.get("v.inLA") == true){
                helper.getLAmessage(component,helper);
            }
            
        })
        console.log('before enqueded message');
        $A.enqueueAction(action2);  
        //console.log('enqueded message');
        // $A.run(function(){console.log('hi')});
    },
    screenShot : function(component, event, helper){
        
            html2canvas(document.body, {
      onrendered: function(canvas) {
        console.log(canvas.toDataURL().length);
      }
    });
    },
    
    showDetail : function(component, event, helper){
        //console.log(event);      
        //        cmp.set("v.popupdetail")
    },
    
    addMessage : function(component, helper, text, sender, componentrender, id){
        component = window._cmp;
        if(sender == 'bot'){
            from = 'fromThem';
            avatar=  $A.get('$Resource.sdm_astro');
        } else if(sender == 'agent'){
            from = 'fromThem';
            avatar = component.get("v.SmallPhotoUrl");
        }else {
            from='myMessage';
        }
        
        
        var messages=component.get("v.messages");
        var message = {from : from, text : text, component : componentrender, id : id, avatar : avatar
                      };
        messages.push(message);
        component.set("v.messages", messages);
        //    var focusBottom = document.getElementById("adobewordpress");
        //focusBottom.scrollTop = focusBottom.scrollHeight;
    }
    
    
})