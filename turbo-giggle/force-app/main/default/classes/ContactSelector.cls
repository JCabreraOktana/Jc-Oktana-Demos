public with sharing class ContactSelector {

    @AuraEnabled(cacheable=true)
    public static List<ContactWrapper> getContactByAccountId(String accId){
        try{
            List<ContactWrapper> results = new List<ContactWrapper>();
            for(Contact c : [
                SELECT Id, name, email
                FROM Contact 
                WHERE AccountId = :accId
                WITH SECURITY_ENFORCED
            ]){
                ContactWrapper cw = new ContactWrapper();
                cw.contactId = c.Id;
                cw.contactName = c.Name;
                cw.contactEmail = c.Email;
                results.add(cw);
            }
            return results;
        }catch(System.QueryException e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class ContactWrapper {
        @AuraEnabled public String contactName;
        @AuraEnabled public String contactId;
        @AuraEnabled public String contactEmail;
    }
}
