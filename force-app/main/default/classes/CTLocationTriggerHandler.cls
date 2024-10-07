public with sharing class CTLocationTriggerHandler {
    
    public static void beforeInsertHandler(List<Location__c> locations)
    {
        for (Location__c l : locations) {
            l.Status__c = 'Green';
        }
    }

    public static void beforeUpdateHandler(List<Location__c> locations, Map<Id,Location__c> oldLocationRecords)
    {
        for(Location__c l : locations)
        {
            if(l.Status__c != oldLocationRecords.get(l.Id).Status__c)
            {
                l.Status_Update_Date__c = Date.today();
            }
        }
    }

    public static void afterUpdateHandler(List<Location__c> locations, Map<Id,Location__c> oldLocationRecords)
    {
        Set<Id> locationIds = new Set<Id>();

        for(Location__c l : locations)
        {
            if(l.Status__c == 'Red' && oldLocationRecords.get(l.Id).Status__c != 'Red' )
            {
                locationIds.add(l.Id);
            }
        }

        List<Location_Tracing__c> traces = CTLocationTracingController.getLocationsByLocationIds(locationIds);

        Set<Id> personIds = new Set<Id>();

        for(Location_Tracing__c trace : traces)
        {
            personIds.add(trace.Person__c);
        }
        
        List<Person__c> personToBeUpdated = new List<Person__c>();

        for(Id pId : personIds)
        {
            personToBeUpdated.add(new Person__c(Id = pId, Health_Status__c = 'Yellow'));
        }

        if(personToBeUpdated.size() >0)
        {
            update personToBeUpdated;
        }
    }
}