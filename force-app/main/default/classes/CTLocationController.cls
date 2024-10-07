public with sharing class CTLocationController {

    public static List<Location__c> getRecentHealthChanges()
    {
        List<Location__c> locationList = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                                    FROM Location__c 
                                    Order By Status_Update_Date__c DESC
                                    Nulls Last
                                    LIMIT 100
                                    ];
        return locationList;
    }

    public static List<Location__c> searchlocations(String searchTerm)
    {
        searchTerm = searchTerm+'%';
        List<Location__c> locationList = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                                    FROM Location__c 
                                    WHERE Name Like :searchTerm 
                                        OR Address__c Like :searchTerm 
                                        OR Pincode__c Like :searchTerm
                                    ORDER BY Status_Update_Date__c DESC 
                                    Nulls Last ];
        
        return locationList;
    }

    public static Location__c getPersonId(String locationId)
    {
        List<Location__c> locationList = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                                        FROM Location__c 
                                        WHERE Id = :locationId];

        if(locationList != null && locationList.size() >0)
        {
            return locationList[0];
        }
        return null;
    }

    public static Map<String,Integer> getStatusCount()
    {
        Map<String,Integer> mapOfLocationStatusCount = new Map<String,Integer>();
        for(AggregateResult agg : [SELECT Status__c, Count(Id) TotalLocation FROM Location__c Group By Status__c])
        {
            mapOfLocationStatusCount.put((String)agg.get('Status__c'), (Integer)agg.get('TotalLocation'));
        }

        return mapOfLocationStatusCount;
    }

    public static void updateRedScore(Set<Id> locationIds)
    {
        List<Location__c> locationToBeUpdated = new List<Location__c>();
       AggregateResult[] aggregateResult = [
            Select Location__c, Count(Id) Total FROM Location_Tracing__c
            WHERE Person__r.Health_Status__c = 'Red'
            AND Visit_Date__c = LAST_N_DAYS:10
            AND Location__c In : locationIds
            Group By Location__c
        ];

        for (AggregateResult ag : aggregateResult) {
            String locationId = String.valueOf(ag.get('Location__c'));
            Integer redScore = Integer.valueOf(ag.get('Total'));
            String status = getStatus(redScore);
            
            locationToBeUpdated.add(new Location__c(Id = locationId,Status__c = status,Red_Score__c = redScore));
        }

        if(locationToBeUpdated.size() > 0)
        {
            update locationToBeUpdated;
        }
    }

    private static String getStatus(Integer redScore)
    {
        if(redScore == 0)
        {
            return 'Green';
        }
        else if( redScore <= 5)
        {
            return 'Yellow';
        }
        else if( redScore <= 10)
        {
            return 'Orange';
        }
        else {
            return 'Red';
        }
    }
}