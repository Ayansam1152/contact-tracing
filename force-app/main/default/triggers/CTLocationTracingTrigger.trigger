trigger CTLocationTracingTrigger on Location_Tracing__c (before insert) {
    
    List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(Trigger.new);


    for(Location_Tracing__c trace : duplicates)
    {
        trace.addError('Duplicate record found Location '+trace.Location__c+' Person '+trace.Person__c);
    }
}