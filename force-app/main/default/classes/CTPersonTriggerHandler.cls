public with sharing class CTPersonTriggerHandler {
    
    public static void beforeInsertHandler(List<Person__c> newPersonRecords)
    {
        for(Person__c person : newPersonRecords)
        {
            person.Health_Status__c = 'Green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }
    }

    public static void beforeUpdateHandler(List<Person__c> newPersonRecords,Map<Id,Person__c> oldPersonMap)
    {
        for(Person__c person : newPersonRecords)
        {
            if(person.Health_Status__c != oldPersonMap.get(person.Id).Health_Status__c)
            {
                person.Status_Update_Date__c = Date.today();
            }
        }
    }

    public static void afterUpdateHandler(List<Person__c> newPersonRecords,Map<Id,Person__c> oldPersonMap)
    {
        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();
        for(Person__c person : newPersonRecords)
        {
            if(person.Health_Status__c != oldPersonMap.get(person.Id).Health_Status__c)
            {
                statusChange.add(person.Id);
            }

            if(person.Health_Status__c == 'Red' &&  oldPersonMap.get(person.Id).Health_Status__c != 'Red')
            {
                redStatus.add(person.Id);
            }
        }

        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);

        List<Person__c> personToBeUpdated = new List<Person__c>();

        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();

        Set<Id> cohabitantIds = CTPersonController.getCohabitants(redStatus,alreadyProcessed);
        if (cohabitantIds != null && cohabitantIds.size() >0) {
            orangeStatus.addAll(cohabitantIds);
        }
        
        Set<Id> primaryContacts = CTPersonController.getPrimaryContact(redStatus,alreadyProcessed);
        if(primaryContacts != null && primaryContacts.size() >0)
        {
            orangeStatus.addAll(primaryContacts);
        }
        
        Set<Id> neighboursIds = CTPersonController.getNeighbours(redStatus,alreadyProcessed);

        if(neighboursIds != null && neighboursIds.size() > 0)
        {
            yellowStatus.addAll(neighboursIds);
        }
       
        Set<Id> secondaryContact = CTPersonController.getSecondaryContact(primaryContacts,alreadyProcessed);
        if(secondaryContact != null && secondaryContact.size() >0)
        {
            yellowStatus.addAll(secondaryContact);
        }
        

        for (Id pId : orangeStatus) {
            personToBeUpdated.add(new Person__c(Id = pId, Health_Status__c = 'Orange'));
        }

        for (Id pId : yellowStatus) {
            personToBeUpdated.add(new Person__c(Id = pId, Health_Status__c = 'Yellow'));
        }
        
        if(personToBeUpdated.size() >0)
        {
            update personToBeUpdated;
        }

        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChange);

        if(locationTraces != null && locationTraces.size() >0)
        {
            Set<Id> locationIds = new Set<Id>();

            for(Location_Tracing__c traces : locationTraces)
            {
                locationIds.add(traces.Location__c);
            }

            CTLocationController.updateRedScore(locationIds);
        }
    }
}