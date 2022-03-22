public with sharing abstract class BaseBatchClass implements Database.Batchable<SObject>,Database.AllowsCallouts, Database.Stateful {   
    public abstract Database.QueryLocator start(Database.BatchableContext context);
    public abstract void execute(Database.BatchableContext context, SObject[] scope);
    public abstract void finish(Database.BatchableContext context);
    public abstract String getName(); 
}