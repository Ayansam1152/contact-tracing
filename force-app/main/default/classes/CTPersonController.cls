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

    public static Set<Id> getCohabitants(Set<Id> personIds,Set<Id> alreadyProcessed)
    {
        List<String> healthStatus = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> tracs = [
            SELECT Id, Person_1__c, Person_2__c 
            FROM People_Tracing__c Where (Person_1__c In :personIds OR Person_2__c In :personIds)
            AND Contact_Type__c = 'Cohabitant'
            AND (Person_1__r.Health_Status__c In : healthStatus OR Person_2__r.Health_Status__c In :healthStatus)
            ];

        
        Set<Id> cohabitants = new Set<Id>();

        for(People_Tracing__c pt : tracs)
        {
            if(!alreadyProcessed.contains(pt.Person_1__c))
            {
                cohabitants.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }

            if(!alreadyProcessed.contains(pt.Person_2__c))
            {
                cohabitants.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }

        if(cohabitants.size() >0)
        {
            return cohabitants;
        }

        return null;

    }

    public static Set<Id> getNeighbours(Set<Id> personIds,Set<Id> alreadyProcessed)
    {
        List<People_Tracing__c> tracs = [
            SELECT Id, Person_1__c, Person_2__c 
            FROM People_Tracing__c Where (Person_1__c In :personIds OR Person_2__c In :personIds)
            AND Contact_Type__c = 'Neighbour'
            AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
            ];

        
        Set<Id> neighbours = new Set<Id>();

        for(People_Tracing__c pt : tracs)
        {
            if(!alreadyProcessed.contains(pt.Person_1__c))
            {
                neighbours.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }

            if(!alreadyProcessed.contains(pt.Person_2__c))
            {
                neighbours.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }

        if(neighbours.size() >0)
        {
            return neighbours;
        }

        return null;
    }

    public static Set<Id> getPrimaryContact(Set<Id> personIds,Set<Id> alreadyProcessed)
    {
        List<String> healthStatus = new List<String>{'Green', 'Yellow'};
        List<People_Tracing__c> tracs = [
            SELECT Id, Person_1__c, Person_2__c 
            FROM People_Tracing__c Where (Person_1__c In :personIds OR Person_2__c In :personIds)
            AND Contact_Type__c = 'Other'
            AND Contact_Date__c = LAST_N_DAYS:10
            AND (Person_1__r.Health_Status__c In : healthStatus OR Person_2__r.Health_Status__c In :healthStatus)
            ];

        
        Set<Id> primaryContacts = new Set<Id>();

        for(People_Tracing__c pt : tracs)
        {
            if(!alreadyProcessed.contains(pt.Person_1__c))
            {
                primaryContacts.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }

            if(!alreadyProcessed.contains(pt.Person_2__c))
            {
                primaryContacts.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }

        if(primaryContacts.size() >0)
        {
            return primaryContacts;
        }

        return null;
    }

    public static Set<Id> getSecondaryContact(Set<Id> primaryContacts,Set<Id> alreadyProcessed)
    {
        List<People_Tracing__c> tracs = [
            SELECT Id, Person_1__c, Person_2__c 
            FROM People_Tracing__c Where (Person_1__c In :primaryContacts OR Person_2__c In :primaryContacts)
            AND Contact_Type__c = 'Other'
            AND Contact_Date__c = LAST_N_DAYS:10
            AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
            ];

        
        Set<Id> neighbours = new Set<Id>();

        for(People_Tracing__c pt : tracs)
        {
            if(!alreadyProcessed.contains(pt.Person_1__c))
            {
                neighbours.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }

            if(!alreadyProcessed.contains(pt.Person_2__c))
            {
                neighbours.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }

        if(neighbours.size() >0)
        {
            return neighbours;
        }

        return null;
    }

}