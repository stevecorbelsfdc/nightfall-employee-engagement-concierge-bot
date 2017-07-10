public without sharing class SDM_ChatbotController {
    
    @AuraEnabled
    public static string agentPicture(ID userid){
        
        User u = [Select SmallPhotoUrl from User where id=: userid];
        return u.SmallPhotoUrl;
    }
    
    @AuraEnabled
    public static String verifyUser(){
        
        return Auth.SessionManagement.generateVerificationUrl(Auth.VerificationPolicy.HIGH_ASSURANCE, 'please check', '/');
    }
    
    
    @AuraEnabled
    public static String getUSession(){
        
        return Userinfo.getSessionId();
    }
    
    
    
    
    public class RecommendedKnowledge {
        
        @AuraEnabled
        public KnowledgeArticleVersion kav;
        
        @AuraEnabled
        public List<String> basedon;
        
        @AuraEnabled
        public Double score;
        
    }
    
    
    
    
    @AuraEnabled
    public static List<shopitem__c> getShopItemsX(){
        
        List<shopitem__c> si = [Select Id, Name, Name__c, sku__c, product_id__c, specialoffer__c from shopitem__c];
        return si;
        
        
    }
    
    
    
    @AuraEnabled
    public static String myUserName() {
        System.debug('returning username ' + userinfo.getName());
        //return ('nw' + System.Network.getNetworkId());
        System.debug(RestContext.request);
        return UserInfo.getFirstName();
        
    }
    
    @AuraEnabled
    public static List<kavsnippet> searchForPage(String searchstring, String currenturl){
        searchstring = String.escapeSingleQuotes(searchstring);
        String sosl = 'FIND \'' + searchstring + '\' IN ALL FIELDS RETURNING KnowledgeArticleVersion(id, title, summary WHERE PublishStatus = \'Online\' AND Language = \'en_US\') WITH SNIPPET (target_length=200) LIMIT 5';
        System.debug(sosl);
        Search.SearchResults searchResults = Search.find(sosl);
        
        List<Search.SearchResult> articlelist = searchResults.get('KnowledgeArticleVersion');
        System.debug(articlelist);
        List<kavsnippet> lsnip = new List<kavsnippet>();
        
        List<KnowledgeArticleVersion> huh = new List<KnowledgeArticleVersion>();
        
        for (Search.SearchResult searchResult : articleList) { 
            kavsnippet ksnip = new kavsnippet();
            ksnip.kav = (KnowledgeArticleVersion) searchResult.getSObject();
            ksnip.snippet = searchResult.getSnippet();
            lsnip.add(ksnip);
            huh.add((KnowledgeArticleVersion) searchResult.getSObject());
            KnowledgeArticleVersion article = (KnowledgeArticleVersion) searchResult.getSObject(); 
            //System.debug(article.Title); 
            //System.debug(searchResult.getSnippet()); 
        } 
        
        
        //List<List<SObject>> searchList = [FIND 'San Francisco' ];
        //     List<KnowledgeArticleVersion> foundthis = searchList[0];
        system.debug(lsnip);
        List<kwebsitepage__c> webpages = [SELECT ID from kwebsitepage__c where URL__c =: currenturl];
        if(webpages.size() == 0){
            kwebsitepage__c wp = new kwebsitepage__c();
            wp.URL__c = currenturl;
            
            insert wp;
            webpages.add(wp);
            
        }
        User u = [Select ContactId from User where Id =: UserInfo.getUserId()];
        String contactid = u.contactid;
        kwebsitepage_track__c wt = new kwebsitepage_track__c(kwebsitepage__c=webpages[0].Id, UseType__c ='Search', Search_Term__c = searchstring, search_result__c = lsnip.size(), contact__c = contactid, sessionid__c = UserInfo.getSessionId());
        insert wt;
        
        return lsnip;
    }
    
    
    public class kavsnippet{
        @AuraEnabled 
        public KnowledgeArticleVersion kav;
        @AuraEnabled 
        public String snippet;
        
    }
    
    
    
    
    
    @AuraEnabled
    public static void saveArticleAction(String recordid, String currenturl, String UseType){
        currenturl = currenturl.left(255);
        
        Knowledge_Version__c kav;
        List<Knowledge_Version__c> kavs = [SELECT Id from Knowledge_Version__c WHERE KBArticleVersionId__c =:recordid];
        
        if(kavs.size() > 0){
            kav = kavs[0]; 
        } else {
            kav = new Knowledge_Version__c();
            
        }        
        List<kwebsitepage__c> webpages = [SELECT ID from kwebsitepage__c where URL__c =: currenturl];
        if(webpages.size() == 0){
            kwebsitepage__c wp = new kwebsitepage__c();
            wp.URL__c = currenturl;
            
            insert wp;
            webpages.add(wp);
            
        }
        User u = [Select ContactId from User where Id =: UserInfo.getUserId()];
        String contactid = u.contactid;
        kwebsitepage_track__c wt = new kwebsitepage_track__c(kwebsitepage__c=webpages[0].Id, UseType__c =UseType, Knowledge_Version__c = kav.id, contact__c = contactid, sessionid__c = UserInfo.getSessionId());
        insert wt;
        
    }
    
    private static void saveView(String recordid, String title, String currenturl, String viewedfrom){
        
        Knowledge_Version__c kav;
        List<Knowledge_Version__c> kavs = [SELECT Id from Knowledge_Version__c WHERE KBArticleVersionId__c =:recordid];
        
        if(kavs.size() > 0){
            kav = kavs[0]; 
        } else {
            kav = new Knowledge_Version__c();
            
        }
        
        
        List<kwebsitepage__c> webpages = [SELECT ID from kwebsitepage__c where URL__c =: currenturl];
        if(webpages.size() == 0){
            kwebsitepage__c wp = new kwebsitepage__c();
            wp.URL__c = currenturl;
            
            insert wp;
            webpages.add(wp);
            
        }
        String contactid = getContact();
        kwebsitepage_track__c wt = new kwebsitepage_track__c(kwebsitepage__c=webpages[0].Id, UseType__c ='ViewArticle', Knowledge_Version__c = kav.id, viewedfrom__c = viewedfrom, contact__c = contactid, sessionid__c = UserInfo.getSessionId());
        insert wt;
        
    }
    
    public static string getContact(){
        User u = [Select ContactId from User where Id =: UserInfo.getUserId()];
        return u.contactid;
        
    }
    
    @AuraEnabled
    @RemoteAction
    public static  List<Object> getRecord(String sfrecordid, String currenturl, String viewedfrom) {
        currenturl = currenturl.left(255);
        System.debug('the reocrd' + sfrecordid);
        ID recid = (ID)sfrecordid;
        //ID rectypeid = recid.getSobjectType();
        Schema.SObjectType token = recid.getSObjectType();
        
        // Using the token, do a describe 
        // and construct a query dynamically. 
        Schema.DescribeSObjectResult dr = token.getDescribe();
        String objectName = dr.getName();  // modify as needed
        
        
        
        
        String query = 'SELECT';      
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
            query += ' ' + s + ',';
            
        }
        // Manually add related object's fields that are needed.
        //query += 'Account.Name,'; // modify as needed
        
        // Strip off the last comma if it exists.
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }
        
        // Add FROM statement
        query += ' FROM ' + objectName;
        
        // Add on a WHERE/ORDER/LIMIT statement as needed
        query += ' WHERE ID =: recid'; // modify as needed
        sObject sob;
        try {
            sob = database.query(query);
        } catch (QueryException e){
            //perform exception handling
        }
        
        
        //  sObject sob = [SELECT Id, Name from: dr.getName()  LIMIT 1];
        System.debug(sob);
        //sob.put('iam', 'awesome');
        //
        List<Object> snubby = new List<Object>();
        saveView(sob.Id, objectName, currenturl, viewedfrom);
        snubby.add(sob);
        snubby.add(objectName);
        return snubby;
        
    }
    
    @AuraEnabled
    public static String sendLAMessage(String key, String affinity, String text, String sequence){
        // /Chasitor/ChatMessage
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:LiveAgent/Chasitor/ChatMessage');
        req.setHeader('X-LIVEAGENT-API-VERSION', '39');
        req.setHeader('X-LIVEAGENT-AFFINITY', affinity);
        req.setHeader('X-LIVEAGENT-SESSION-KEY', key);
        req.setHeader('X-LIVEAGENT-SEQUENCE', sequence);
        lamessage lamess = new lamessage();
        lamess.text = text;
        req.setBody(JSON.serialize(lamess, false));
        req.setMethod('POST');
        Http http = new Http();
        
        HTTPResponse res = http.send(req);
        
        
        //   LASessionID sessid = LASessionID.parse(res.getBody());
        System.debug(res.getBody());
        
        
        
        
        return 'ok';
    }
    
    @AuraEnabled
    public static String LAMessages(String key, String affinity){
        
        
        System.debug('in lamessage');
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:LiveAgent/System/Messages');
        req.setHeader('X-LIVEAGENT-API-VERSION', '39');
        req.setHeader('X-LIVEAGENT-AFFINITY', affinity);
        req.setHeader('X-LIVEAGENT-SESSION-KEY', key);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        //     LASessionID sessid = LASessionID.parse(res.getBody());
        System.debug(res.getBody());
        
        return res.getBody();   
        //     return res.getBody();
    }
    
    @AuraEnabled
    public static LASessionID startLASession(string email){
        String firstname;
        String lastname;
        List<Contact> cl = [Select Id, Firstname, lastname from contact where email =: email];
        if(cl.size() > 0){
            firstname = cl[0].firstname;
            lastname = cl[0].lastname;
            
        } else {
            firstname = 'Guest';
            Lastname = 'Visitor';

            
        }
        livechatbuttondeployment button = [select buttonid, deploymentid, button.developername from livechatbuttondeployment where button.isactive = true limit 1];
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:LiveAgent/System/SessionId');
        req.setHeader('X-LIVEAGENT-API-VERSION', '39');
        req.setHeader('X-LIVEAGENT-AFFINITY', 'null');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        LASessionID sessid = LASessionID.parse(res.getBody());
        System.debug(res.getBody());
        
        
        HttpRequest reqpost = new HttpRequest();
        
        //SosClient/SosRequest
        reqpost.setEndpoint('callout:LiveAgent/Chasitor/ChasitorInit');
        //reqpost.setEndpoint('callout:LiveAgent/SosClient/SosRequest');
        reqpost.setHeader('X-LIVEAGENT-API-VERSION', '39');
        reqpost.setHeader('X-LIVEAGENT-AFFINITY', sessid.affinityToken);
        reqpost.setHeader('X-LIVEAGENT-SESSION-KEY', sessid.key);
        reqpost.setHeader('X-LIVEAGENT-SEQUENCE', '1');
        reqpost.setMethod('POST');
        
       // PrechatDetail pd = new PrechatDetail();
        
        List<PrechatEntities> pel = new List<PrechatEntities>();
        PrechatEntities pa = new PrechatEntities();
        pa.entityName = 'Contact';
        pa.showOnCreate = true;
        pa.saveToTranscript = 'Contact';
        
        List<PrechatDetails> pd = new List<PrechatDetails>();
        List<EntityFieldsMaps> efm = new List<EntityFieldsMaps>();
        
        EntityFieldsMaps fnm = new EntityFieldsMaps();
        PrechatDetails fn = new PrechatDetails();
        fn.label = 'First Name';
        fn.value = firstname;
        fn.displayToAgent = true;
        fn.doKnowledgeSearch = false;
        fnm.fieldname = 'FirstName';
        fnm.label = 'First Name';
        fnm.doFind = false;
        fnm.isExactMatch = false;
        fnm.doCreate = true;
        
        efm.add(fnm);
        pd.add(fn);
        
        EntityFieldsMaps lnm = new EntityFieldsMaps();
        PrechatDetails ln = new PrechatDetails();
        ln.label = 'Last Name';
        ln.value = lastname;
        ln.displayToAgent = true;
        ln.doKnowledgeSearch = false;
        lnm.fieldname = 'LastName';
        lnm.label = 'Last Name';
        lnm.doFind = false;
        lnm.isExactMatch = false;
        lnm.doCreate = true;
        
        efm.add(lnm);
        pd.add(ln);

        EntityFieldsMaps emm = new EntityFieldsMaps();
        PrechatDetails em = new PrechatDetails();
        em.label = 'Email';
        em.value = email;
        em.displayToAgent = true;
        em.doKnowledgeSearch = false;
        emm.fieldname = 'Email';
        emm.label = 'Email';
        emm.doFind = true;
        emm.isExactMatch = true;
        emm.doCreate = true;

        efm.add(emm);
        pd.add(em);
        
        pa.entityFieldsMaps = efm;
        pel.add(pa);
       
        
        String butid = button.ButtonId;
        butid = butid.left(15);
        String depid = button.DeploymentId;
        depid = depid.left(15);
        
        System.debug(sessid.key);        
        chasinit chas = new chasinit();
        chas.organizationid = UserInfo.getOrganizationId().left(15);
        chas.deploymentid = depid;
        chas.visitorName = firstname + ' ' + lastname;
        chas.buttonid = butid;
        chas.sessionid = sessid.id;
        chas.preChatDetails = pd;
        chas.prechatEntities = pel;
        reqpost.setBody(JSON.serialize(chas, false));
        System.debug(reqpost.getBody());
        //Http http = new Http();
        HTTPResponse respost = http.send(reqpost);
        //   LASessionID sessid = LASessionID.parse(res.getBody());
        System.debug(respost.getBody());
        
        
        
        
        
        ///chat/rest/System/SessionId
        return sessid;
    }
    
    
    public class chasinit{
        
        Public  String organizationId;
        public String deploymentId;
        public String buttonId;
        public String sessionId;
       // Mozilla/5.0 (Windows; U; Win 9x 4.90; de-DE; rv:0.9.2) Gecko/20010726 Netscape6/6.1
      //  String userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:51.0) Gecko/20100101 Firefox/51.0'; 
         String userAgent = 'Mozilla/5.0 (Windows; U; Windows NT 6.1; zh_CN) AppleWebKit/534.7 (KHTML, like Gecko) Chrome/7.0 baidubrowser/1.x Safari/534.7'; 
        String language =  'en-US'; 
        
        String screenResolution = '1900x1080'; 
        String visitorName = 'Frank Underwood'; 
     //   String[] prechatDetails = new String[]{};  
     //String [] prechatEntities = new String[]{};
    // 
    // 
    //
        public List<PrechatEntities> prechatEntities;
         public List<PrechatDetails> prechatDetails; 
       //  PreChatDetail prechatDetails = new PreChatDetail();  
      //  PrechatEntity prechatEntities = new PrechatEntity();
        Boolean receiveQueueUpdates = true;
        Boolean isPost = true;
        
        
    }
    
    public List<PrechatEntities> prechatEntities;

	public class PrechatEntities {
		public String entityName;
		public Boolean showOnCreate;
        public String saveToTranscript;
		public List<EntityFieldsMaps> entityFieldsMaps;
	}

	public class EntityFieldsMaps {
		public String fieldName;
		public String label;
		public Boolean doFind;
		public Boolean isExactMatch;
		public Boolean doCreate;
	}
    
    
    public class EntityMaps {
	}

	public List<PrechatDetails> prechatDetails;

	public class PrechatDetails {
		public String label;
		public String value;
		public List<EntityMaps> entityMaps = new List<EntityMaps>();
		public List<EntityMaps> transcriptFields = new List<EntityMaps>();
		public Boolean displayToAgent = true;
		public Boolean doKnowledgeSearch = false;
	}
    
    
    public class lamessage {
        Public String text;
    }
}