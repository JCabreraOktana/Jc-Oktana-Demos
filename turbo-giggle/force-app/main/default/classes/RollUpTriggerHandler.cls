public with sharing class RollUpTriggerHandler {
    Map<id,List<Id>> accOpportunity = new Map<id,List<Id>>();
    List<Opportunity> opportunities = new List<Opportunity>();
    Map<id,List<Id>> accByRecycled = new Map<id,List<Id>>();
    Map<id,List<Id>> accByStandard = new Map<id,List<Id>>();

    /*desc: add a list of opportunities to main list */
    public void addOpportunities(List<Opportunity> opptys){
        opportunities.addAll(opptys);
    }

    /*desc: maps account id with opportunty obj with check against old opportunity map*/
    public void addOpportunitiesWithOldMapCheck(List<Opportunity> newOppties,Map<Id,Opportunity> oldMap){
        for(Opportunity o : newOppties) {
            if(o?.AccountId != null) {
                accOpportunity.put(o.AccountId,o.Id);
            }
            if(oldMap.get(o.Id).AccountId != null 
            && oldMap.get(o.Id).AccountId != o.AccountId) {
                accOpportunity.put(oldMap.get(o.Id).AccountId,o.Id);
            }
        }
    }

    /* MAin rollup processing */
    public void processWoodTypeRollUp(){

        for(Opportunity o : opportunities){
            if(o?.AccountId != null){
                addToMap(accOpportunity,o);
            }
        }

        if(!accOpportunity.isEmpty()){
            processOpportunityByType(accOpportunity);
        }

        try{
            List<Account> accToUpdate = getAccountsToUpdate();
            
            if(!accToUpdate.isEmpty()){
                if (
                    Schema.sObjectType.Account.fields.Total_Sales_Wood__c.isUpdateable()
                    && Schema.sObjectType.Account.fields.Total_Sales_Recycled__c.isUpdateable()) {
                    update accToUpdate;
                }
            }

        }catch(System.QueryException e) {
            throw new AuraHandledException(e.getMessage());
        }catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*Separates opportunities into maps according to Wood_Type__c */
    private void processOpportunityByType(Map<id,List<Id>> accOpportunity){

        for(Opportunity o : accOpportunity.values()){
            if (o.Wood_Type__c == 'Standard') {
                addToMap(accByStandard,o);
            }else {
                addToMap(accByRecycled,o);
            }
        }
    }

    /* adds opportunity to map */
    public void addToMap(Map<id,List<Id>> currentMap,Opportunity o){
        if(currentMap.containsKey(o.AccountId)){
            List<Id> currentOpptyIds = currentMap.get(o.AccountId);
            currentOpptyIds.add(o.Id);
            currentMap.put(o.AccountId,currentOpptyIds);
        }else {
            List<Id> newOpptyIds = new List<Id>();
            newOpptyIds.add(o.AccountId);
            currentMap.put(o.AccountId,newOpptyIds);
        }
    }

    /* selects the accounts that need an update and calculate their rollups */
    private List<Account> getAccountsToUpdate(){
        List<Account> accToUpdate = new List<Account>();
        for(Account acc : [
            SELECT Id, Total_Sales_Wood__c,Total_Sales_Recycled__c 
            FROM Account WHERE Id in :accOpportunity?.keySet()
            WITH SECURITy_ENFORCED]
        ){
            if (accByRecycled.containsKey(acc.Id)){
                acc.Total_Sales_Recycled__c = accByRecycled?.get(acc.Id)?.size();
            }
            if (accByStandard.containsKey(acc.Id)){
                acc.Total_Sales_Recycled__c = accByStandard?.get(acc.Id)?.size();
            }
        }
        return accToUpdate;
    }
}
