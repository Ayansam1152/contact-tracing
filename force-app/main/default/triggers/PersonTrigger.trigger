trigger PersonTrigger on Person__c (before insert, after insert, before update, after update, before delete,after undelete) {

    switch on Trigger.OperationType {
        when  BEFORE_INSERT{
            CTPersonTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when BEFORE_UPDATE {
            CTPersonTriggerHandler.beforeUpdateHandler(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            CTPersonTriggerHandler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
        }
    }

}