public with sharing class BatchService implements Schedulable{

    BaseBatchClass sc;
    Integer iBatchSize;
    Integer iTimeInterval;
    Integer iErrorTimeInterval;
    @testVisible boolean bTestExecute = true; 
    public BatchService(BaseBatchClass sc, Integer iBatchSize, Integer iTimeInterval,Integer iErrorTimeInterval)
    {
        this.sc = sc;  
        this.iBatchSize = iBatchSize;
        this.iTimeInterval = iTimeInterval;
        this.iErrorTimeInterval = iErrorTimeInterval;
    }
    
    public void scheduleBatchAtNextAvailableTime()
    {	
        Datetime dt;
        String timeForScheduler;
        Id schedId; 
        //check if there are 5 active batch jobs
        //In some cases, might need to add "Status='Queued' " to the criteria
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Holding' OR Status = 'Queued')] < 100 && bTestExecute){ 
            Database.executeBatch(sc, iBatchSize); 
        	
            //schedule this same schedulable class again in defined TimeInterval
            dt = Datetime.now().addMinutes(Integer.valueOf(iTimeInterval));
            timeForScheduler = dt.format('s m H d M \'?\' yyyy');
            schedId = System.Schedule('Sys Schedule '+ sc.getName() + ' ' + timeForScheduler+' '+system.currentTimeMillis(),timeForScheduler,new BatchService(sc, iBatchSize,iTimeInterval,iErrorTimeInterval));
            
        }else{
           //schedule this same schedulable class again in defined errorTimeInterval
           dt = Datetime.now().addMinutes(Integer.valueOf(iErrorTimeInterval));
           timeForScheduler = dt.format('s m H d M \'?\' yyyy');
           schedId = System.Schedule('Sys Schedule '+ sc.getName() + ' ' + timeForScheduler+' '+system.currentTimeMillis(),timeForScheduler,new BatchService(sc, iBatchSize,iTimeInterval,iErrorTimeInterval));
        }
    }
    
    public void execute(System.SchedulableContext scontext)
    {
        scheduleBatchAtNextAvailableTime();
    }
}