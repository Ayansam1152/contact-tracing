public with sharing class CTPersonController {

    public static String getToken(String phone)
    {
        Blob targetBlob = Blob.valueOf(phone);
        Blob hash = Crypto.generateDigest('MD5', targetBlob);

        return EncodingUtil.base64Encode(hash);
    }

    public static List<Person__C> getRecentHealthChanges()
    {
        List<Person__C> people = [Select Id, Name, Mobile__c, Health_Status__c, Status_Update_Date__c,Token__c 
                                        From Person__c 
                                        ORDER BY Status_Update_Date__c DESC 
                                        Nulls Last
                                        LIMIT 100];
        return people;
    }

    public static List<Person__C> searchPeople(String searchTerm)
    {
        searchTerm = searchTerm+'%';
        List<Person__c> people = [Select Id, Name, Mobile__c, Health_Status__c, Status_Update_Date__c,Token__c 
                                    From Person__c 
                                    WHERE Name Like :searchTerm 
                                        OR Mobile__c Like :searchTerm 
                                        OR Token__C Like :searchTerm
                                    ORDER BY Status_Update_Date__c DESC 
                                    Nulls Last ];
        
        return people;
    }

    public static Person__c getPersonId(String personId)
    {
        List<Person__c> people = [Select Id, Name, Mobile__c, Health_Status__c, Status_Update_Date__c,Token__c 
                                        From Person__c 
                                        WHERE Id = :personId];

        if(people != null && people.size() >0)
        {
            return people[0];
        }
        return null;
    }

    public static Map<String,Integer> getHealthStatusCount()
    {
        Map<String,Integer> mapOfPeopleStatusCount = new Map<String,Integer>();
        for(AggregateResult agg : [SELECT Health_Status__c, Count(Id) TotalPeople FROM Person__c Group By Health_Status__c])
        {
            mapOfPeopleStatusCount.put((String)agg.get('Health_Status__c'), (Integer)agg.get('TotalPeople'));
        }

        return mapOfPeopleStatusCount;
    }
}