trigger AccountTrigger on Account (before insert,after insert, after update) {
    if(Trigger.IsInsert && Trigger.IsBefore){
        AccountTriggerHelper.checkAccountManagerPSAssignment(Trigger.New); // Check for Account Manager PS
    }
    
    if(Trigger.IsAfter && (Trigger.IsInsert || Trigger.IsUpdate)){
        AccountTriggerHelper.doCreateContact(Trigger.New); // If user has Account Manager PS then make contact if criterias matched
    }
}