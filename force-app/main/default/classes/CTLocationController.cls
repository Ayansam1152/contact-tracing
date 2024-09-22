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
}