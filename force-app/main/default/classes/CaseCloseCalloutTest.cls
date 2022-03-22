@isTest
public with sharing class CaseCloseCalloutTest {
    @TestSetup
    static void setupData(){
        
        Profile pSysAdmin = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User uSysAdmin = (User)TestFactory.createSObject(new User(Alias = 'standt', Email='rmitob2b@testorg.rmito.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = pSysAdmin.Id,isactive=true,
                TimeZoneSidKey='America/Los_Angeles', UserName='test.devc.regi@regi.com'),true);
        
    }
    
    @isTest
    static void testPostCalloutBulk() {
        User uSysAdmin = [SELECT Id FROM User WHERE UserName='test.devc.regi@regi.com' LIMIT 1]; 
        System.runAs(new User(Id=uSysAdmin.id)){
            Case[] cList = (Case[])TestFactory.createSObjectList(new Case(), 2000,true);

            List<Case> lstCaseUpdate=new List<Case>();
            for(Case obj:cList ){
                obj.Status='Closed';
                lstCaseUpdate.add(obj);
            }
            update lstCaseUpdate;
            
            Test.setMock(HttpCalloutMock.class, new CaseCloseCalloutMock());
    
            Test.startTest();
            	BatchService oBatchService = new BatchService(new CaseCloseCalloutBatch(),100,180,30);
        		oBatchService.scheduleBatchAtNextAvailableTime(); 
            Test.stopTest();
            
            List<Case> caseObjLst = [select id,Secret_Key__c from Case where Secret_Key__c!=null];
            system.assert(caseObjLst.size()==100, 'After Case Close Callout did not update the secretKey for bulk record');
         }
    }
    
    @isTest
    static void testPostCalloutSingle() {
        User uSysAdmin = [SELECT Id FROM User WHERE UserName='test.devc.regi@regi.com' LIMIT 1]; 
        System.runAs(new User(Id=uSysAdmin.id)){
            
            Case caseObj = (Case)TestFactory.createSObject(new Case(),true);
            caseObj.Status='Closed';
            update caseObj;
            
            Test.setMock(HttpCalloutMock.class, new CaseCloseCalloutMock());
    
            Test.startTest();
            	BatchService oBatchService = new BatchService(new CaseCloseCalloutBatch(),100,180,30);
        		oBatchService.scheduleBatchAtNextAvailableTime(); 
            Test.stopTest();
            
            Case obj = [select id,Secret_Key__c from Case LIMIT 1];
            system.assertEquals(obj.Secret_Key__c,'0986HJK', 'After Case Close Callout did not update the secretKey for single record');
         }
    }
    
    @isTest
    static void testPostCalloutFail() {
        User uSysAdmin = [SELECT Id FROM User WHERE UserName='test.devc.regi@regi.com' LIMIT 1]; 
        System.runAs(new User(Id=uSysAdmin.id)){
            Case[] cList = (Case[])TestFactory.createSObjectList(new Case(), 2000,true);

            List<Case> lstCaseUpdate=new List<Case>();
            for(Case obj:cList ){
                obj.Status='Closed';
                lstCaseUpdate.add(obj);
            }
            update lstCaseUpdate;
            
            Test.setMock(HttpCalloutMock.class, new CaseCloseCalloutFailMock());
    
            Test.startTest();
            	BatchService oBatchService = new BatchService(new CaseCloseCalloutBatch(),100,180,30);
        		oBatchService.scheduleBatchAtNextAvailableTime(); 
            Test.stopTest();
            
            List<Case> caseObjLst = [select id,Secret_Key__c from Case where Secret_Key__c!=null];
            system.assert(caseObjLst.size()==0, 'Case Close Callout failed');
         }
    }
    
    @isTest
    static void testCaseCloseByUpdate() {
		//Need to run this as the appropriate user
		
        Case[] cList = (Case[])TestFactory.createSObjectList(new Case(), 2000,true);
        
        List<Case> lstCaseUpdate=new List<Case>();
        for(Case obj:cList ){
            obj.Status='Closed';
            lstCaseUpdate.add(obj);
        }
        
        
        Test.startTest();
        update lstCaseUpdate;
        Test.stopTest();
        
        List<Case> caseObjLst = [select id,case_closed_by__c from Case];
        for(Case obj:caseObjLst){
            system.assertEquals(obj.Case_Closed_By__c,UserInfo.getUserId(), 'Case closed by update failed');
        }
   }
    
}