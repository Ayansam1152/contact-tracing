public with sharing class CTLocationTracingController {
    
    public static List<Location_Tracing__c> getVisiters(String locationId)
    {
        List<Location_Tracing__c> visiters = [SELECT Id, Person__c, Location__c, Visit_Date__c , Person__r.Health_Status__c, Person__r.Token__c
                                                FROM Location_Tracing__c
                                                Where Location__c = :locationId
                                                Order By Visit_Date__c DESC];
        if(visiters != null && visiters.size() >0)
        {
            return visiters;
        }

        return null;
    }

    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds)
    {
        Date today = Date.today();
        Date tenDaysAgo = today.addDays(-10);

        List<Location_Tracing__c> visiters = [SELECT Id, Person__c, Location__c, Visit_Date__c 
                                                FROM Location_Tracing__c
                                                Where Person__c IN :personIds
                                                    AND Visit_Date__c <= :tenDaysAgo];
        
        return visiters;
    }

    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds)
    {
        Date today = Date.today();
        Date tenDaysAgo = today.addDays(-10);

        List<Location_Tracing__c> localtions = [
            SELECT Id, Person__r.Health_Status__c, Name, Person__c, Location__c, Visit_Date__c 
            FROM Location_Tracing__c
            Where Location__c IN :locationIds
                AND Visit_Date__c <= :tenDaysAgo
                AND Person__r.Health_Status__c = 'Green'
        ];
        
        if(localtions != null && localtions.size() >0)
        {
            return localtions;
        }

        return null;
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces)
    {
       Set<Id> personIds = new Set<Id>();
       Set<Id> locationIds = new Set<Id>();

       for(Location_Tracing__c traces : newLocationTraces)
       {
            personIds.add(traces.Person__c);
            locationIds.add(traces.Location__c);
       }

       List<Location_Tracing__c> existingTraces = [
            Select Id,Person__c, Location__C
            FROM Location_Tracing__c
            WHERE Person__c In : personIds
            AND Location__C In : locationIds
        ];
       
        Map<Id,Set<Id>> mapOfExistingRecords = new Map<Id,Set<Id>>();
        List<Location_Tracing__c> duplicateRecord = new List<Location_Tracing__c>();
        
        if(existingTraces != null && existingTraces.size() >0)
        {
            for(Location_Tracing__c traces : existingTraces)
            {
                if(!mapOfExistingRecords.containsKey(traces.Location__c))
                {
                    mapOfExistingRecords.put(traces.Location__c, new Set<Id>());
                }

                mapOfExistingRecords.get(traces.Location__c).add(traces.Person__c);
            }

            for(Location_Tracing__c traces : newLocationTraces)
            {
                if(mapOfExistingRecords.containsKey(traces.Location__c) &&
                    mapOfExistingRecords.get(traces.Location__c).contains(traces.Person__c))
                    {
                        duplicateRecord.add(traces);
                    }
            }
        }

        return duplicateRecord;
    }

}