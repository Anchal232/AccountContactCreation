public with sharing class ActivateAccountClass {
    @AuraEnabled
    public static String activateAccount(Id recordId){
        try {
            Account acc = [SELECT Id, Active__c FROM Account WHERE Id = :recordId];
            acc.Active__c = true;
            update acc;
            return 'Success';
        } catch (Exception e) {
            return e.getMessage();
        }
    }
}