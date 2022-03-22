public with sharing class CaseCloseCalloutBatch extends BaseBatchClass {
    //query defining default scope of the batch
    String query = 'SELECT Id,Case_Closed_By__c  FROM Case where Secret_Key__c=null and Status=\'Closed\' and case_closed_by__c!=null '+(Test.isRunningTest()?' LIMIT 100':'');
    
    //method to set query that defines the scope of the batch
    public void setQuery(String query) {
        this.query = query;
    }
    
    public override Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
	
    //Execute the batch 
    public override void execute(Database.BatchableContext bc, List<sObject> scope){
        CaseCloseCalloutService.caseCloseCalloutToWorkforce(scope);
    }
    
    public override void finish(Database.BatchableContext bc){
        
    }
    
    public override String getName(){
        return 'CaseCloseCalloutBatch';
    }
}