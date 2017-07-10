@isTest
global class MockHttpPredictionCallout implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        System.debug(req.getEndpoint());
        String json='{}';
        if(req.getEndpoint().contains('opencart')){
         json = '{\"oc_cart\":[{\"cart_id\":\"81\",\"customer_id\":\"1\",\"session_id\":\"85eovtcqjg1apeo44ctdgjkca3\",\"product_id\":\"51\",\"recurring_id\":\"0\",\"option\":\"[]\",\"quantity\":\"1\",\"date_added\":\"2016-10-10 10:31:23\"},{\"cart_id\":\"111\",\"customer_id\":\"0\",\"session_id\":\"85eovtcqjg1apeo44ctdgjkca3\",\"product_id\":\"51\",\"recurring_id\":\"0\",\"option\":\"[]\",\"quantity\":\"1\",\"date_added\":\"2016-10-10 12:36:43\"}]}';   
        }
        if(req.getEndpoint().contains('System/SessionId')){
         json = '{"key":"11e03c39-f4a0-4b28-9a77-1057925c3031!1488277480673!Bv1SqE5QmW4myiZ683duoRoJgIQ=","id":"11e03c39-f4a0-4b28-9a77-1057925c3031","clientPollTimeout":40,"affinityToken":"4b7b1fa0"}';   
        }
        

        if(req.getEndpoint().contains('ChasitorInit') || req.getEndpoint().contains('Message')){
         json = 'OK';   
        }

        
        
        
        //ChasitorInit
        // {"key":"11e03c39-f4a0-4b28-9a77-1057925c3031!1488277480673!Bv1SqE5QmW4myiZ683duoRoJgIQ=","id":"11e03c39-f4a0-4b28-9a77-1057925c3031","clientPollTimeout":40,"affinityToken":"4b7b1fa0"}
        
        if(req.getEndpoint().contains('kbengine')){
            json  = '{\"itemScores\":[{\"item\":\"i18\",\"score\":1.0421191026262568,\"basedon\": [],\"article\":\"i18\"},{\"item\":\"i46\",\"score\":1.0043524687164807,\"basedon\":[],\"article\":\"i46\"},{\"item\":\"i20\",\"score\":1.0030918776309137,\"basedon\":[],\"article\":\"i20\"},{\"item\":\"i21\",\"score\":0.9947949636841973,\"basedon\":[],\"article\":\"i21\"}]}';
        }
           
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //String 
        res.setBody(json);
        res.setStatusCode(200);
        return res;
    }
}