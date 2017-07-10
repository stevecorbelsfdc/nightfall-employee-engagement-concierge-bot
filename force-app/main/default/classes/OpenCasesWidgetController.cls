public class OpenCasesWidgetController {

    
    
    
    
    @AuraEnabled
    public static List<Case> getCases(){
        
        User u = [Select contactid from user where id =: UserInfo.getUserId()];
        
        List<Case> updated= [Select Id, Subject, CaseNumber, Status, Lastmodifieddate from Case where Status != 'Closed' AND contactid =: u.contactid];
        
        
        return updated;
    }
    
    
   
}