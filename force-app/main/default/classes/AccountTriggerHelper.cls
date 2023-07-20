public with sharing class AccountTriggerHelper {
    private static final String ACCOUNT_MANAGER_CP = 'Account_Manager_CP';
    private static final String CUSTOMER_TYPE = 'Customer';
    
    public static void checkAccountManagerPSAssignment(List<Account> accounts){
        System.debug('sbdjsh');
        if(! FeatureManagement.checkPermission(ACCOUNT_MANAGER_CP)){
            for(Account acc: accounts){
                acc.addError(System.Label.AccountManagerLbl);
            }
        }
    }
    
    public static void doCreateContact(List<Account> accounts){
        Boolean defaultContactExist = checkDefaultContactExistence(accounts);
        List<Contact> contactWithAccounts = new List<Contact>();
        for(Account acc : accounts){
            if(acc.Type == CUSTOMER_TYPE && !defaultContactExist && acc.Active__c){
                if(acc.Account_Activation_Summary__c == null){
                    acc.addError(System.Label.AccountSummaryRequiredLbl); // check if summary is given if account is activated
                }
                else{
                    contactWithAccounts.add(new Contact(FirstName = acc.Name, LastName = 'Customer Representative', AccountId = acc.Id, Email = acc.Company_Email__c, Phone = acc.Phone));//Don't know what is custom representative
                }
                
            }
        }
        
        if(contactWithAccounts != null && !contactWithAccounts.isEmpty()){
            insert contactWithAccounts;
        }
    }
    
    private static Boolean checkDefaultContactExistence(List<Account> acc){
        return [SELECT Id FROM Contact WHERE AccountId IN :acc].size() > 0;
    }
}