trigger CTPeopleTracingTrigger on People_Tracing__c (before insert) {

    List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(Trigger.new);


    for(People_Tracing__c trace : duplicates)
    {
        trace.addError('Duplicate record found Person1 '+trace.Person_1__c+' Person2 '+trace.Person_2__c);
    }
}