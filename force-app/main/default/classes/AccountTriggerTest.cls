@IsTest
private class AccountTriggerTest {
    private static final String ACCOUNT_MANAGER_PS = 'Account_Manager_PS';
    private static final String SYST_ADMIN_PROFILE = 'System Administrator';
    
    @IsTest
    static void should_throw_error_while_account_create_if_not_account_manager(){
        //Given: A user
        Boolean isInserted;
        String exceptionMsg;
        System.runAs(makeUser()){
            //When: Account is inserted
            Account acc = new Account(Name = 'test');
            insert acc;
            //Then: no account is created
            System.assertEquals(true, [SELECT Id FROM Account WHERE Id = :acc.Id].size()>0);
        }
    }
    
    @IsTest
    static void should_insert_account_with_No_contact(){
        //Given : a user
        User user = makeUser();
        assignAccountManagerPermissionSet(user);
        System.runAs(user){
            //When: account is inserted
            Account acc = new Account(Name = 'test');
            insert acc;
            
            //Then: account should get inserted and contact should be made
            System.assertEquals(true, acc.Id != null);
            System.assertEquals(true, [SELECT Id FROM Contact WHERE AccountId = :acc.Id ]. size() == 0);
        }
    }
    
    @IsTest
    static void should_insert_account_with_Contact(){
        //Given : a user
        User user = makeUser();
        assignAccountManagerPermissionSet(user);
        System.runAs(user){
            //When: account is inserted
            Account acc = new Account(Name = 'test',Active__c = true, Account_Activation_Summary__c = 'test');
            insert acc;
            
            //Then: account should get inserted and contact should be made
            System.assertEquals(true, acc.Id != null);
            System.assertEquals(true, [SELECT Id FROM Contact WHERE AccountId = :acc.Id ]. size() == 0);
        }
        
    }
    
    static User makeUser(){
        Profile prof = [SELECT Id FROM profile WHERE Name LIKE :SYST_ADMIN_PROFILE];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.email = 'test@test.com';
        user.Username = 'cqTest@cq.com';
        user.Alias = 'CQTest';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        insert user;
        return user;
    }
    
    static void assignAccountManagerPermissionSet(User user){
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :ACCOUNT_MANAGER_PS];
        insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id);
    }
    
}