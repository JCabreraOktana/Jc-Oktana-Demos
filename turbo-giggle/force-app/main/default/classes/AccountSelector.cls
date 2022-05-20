public with sharing class AccountSelector {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAllAccounts(){
        try{
            return [
                SELECT Id, name 
                FROM Account WITH SECURITY_ENFORCED
            ];
        }catch(System.QueryException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
