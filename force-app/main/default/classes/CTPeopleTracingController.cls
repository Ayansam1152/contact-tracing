public with sharing class CTPeopleTracingController {
    
    public static List<People_Tracing__c> getTraces(String personId)
    {
        List<People_Tracing__c> traces =  [
            SELECT Id, Person_1__c, Person_1__r.Health_Status__C,Person_1__r.Token__c,
            Person_2__c,Person_2__r.Health_Status__C,Person_2__r.Token__c, Contact_Date__c 
            FROM People_Tracing__c
            WHERE Person_1__c = :personId OR Person_2__c = :personId
            Order By Contact_Date__c DESC nulls Last
        ];

        if(traces != null && traces.size() >0)
        {
            return traces;
        }

        return null;
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPersonTraces)
    {
        Set<Id> personIds = new Set<Id>();

        for(People_Tracing__c trace : newPersonTraces)
        {
            
            personIds.add(trace.Person_1__c);
            personIds.add(trace.Person_2__c);
        }

        List<People_Tracing__c> existingRecords = [
            Select Id,Person_1__c,Person_2__c
            FROM People_Tracing__c
            WHERE Person_1__c IN :personIds
            OR Person_2__c In :personIds
        ];

        Map<Id,Set<Id>> mapOfExistingRecords = new Map<Id,Set<Id>>();

        if(existingRecords != null && existingRecords.size() >0)
        {
            for(People_Tracing__c trace : existingRecords)
            {
                if(!mapOfExistingRecords.containsKey(trace.Person_1__c))
                {
                    mapOfExistingRecords.put(trace.Person_1__c,  new Set<Id>());
                }
                
                mapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);
            

                if(!mapOfExistingRecords.containsKey(trace.Person_2__c))
                {
                    mapOfExistingRecords.put(trace.Person_2__c,  new Set<Id>());
                }
                
                mapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
            }
        }

        List<People_Tracing__c> duplicateRecords = new List<People_Tracing__c>();

        for(People_Tracing__c trace : newPersonTraces)
        {
            if(mapOfExistingRecords.containsKey(trace.Person_1__c) && mapOfExistingRecords.get(trace.Person_1__c).contains(trace.Person_2__c)
            ||
            mapOfExistingRecords.containsKey(trace.Person_2__c) && mapOfExistingRecords.get(trace.Person_2__c).contains(trace.Person_1__c))
            {
                duplicateRecords.add(trace);
            }
        }
        
        return duplicateRecords;
    }
}