public with sharing class CaseCloseCalloutBatchScheduler implements Schedulable {
    public void execute(SchedulableContext ctx){ 
        //If for any reason this batch cannot be scheduled, it will automatically schedule it in 30 mins.
        //If success then schedule it every 3 Hrs
        BatchService oBatchService = new BatchService(new CaseCloseCalloutBatch(),100,180,30);
        oBatchService.scheduleBatchAtNextAvailableTime();   
    }
}