@isTest(seealldata=true)
public class SDM_ChatbotControllerTest {

    @isTest
    public static void testChatbot(){
        User u = [Select Id from user where contactid != null AND Lastname='Boyle'  LIMIT 1];
        User agent = [Select id from user where contactid = null LIMIT 1];
        Case c = [Select Id from Case LIMIT 1];
        
        SDM_ChatbotController.getContact();
        SDM_ChatbotController.getUSession();
        SDM_ChatbotController.myUserName();
        SDM_ChatbotController.searchForPage('headphone', 'headphone');
        SDM_ChatbotController.agentPicture(agent.Id);
        SDM_ChatbotController.getShopItemsX();
        SDM_ChatbotController.verifyUser();
        SDM_ChatbotController.saveArticleAction('aa', 'aa', 'Pageview');
        SDM_ChatbotController.getRecord(c.Id, 'snapin', 'search');
        OpenCasesWidgetController.getCases();
        SDM_ChatbotController.chasinit chas = new SDM_ChatbotController.chasinit();
        
        MyAppointmentMapController.myAppointment(u.Id);
    }
    
    @istest
    public static void testCallout(){
        Test.setMock(HttpCalloutMock.class, new MockHttpPredictionCallout());
        SDM_ChatbotController.sendLAMessage('test', 'test', 'text', '1');
        SDM_ChatbotController.startLASession('lboyle@example.com');
        SDM_ChatbotController.LAMessages('test', 'affinit');
    }
}