trigger RollUpTrigger on Opportunity (after insert,after update, after delete) {

    RollUpTriggerHandler rTriggerHandler = new RollUpTriggerHandler();
    
    Map<id,List<Id>> accOpportunity = new Map<id,List<Id>>();

    if(Trigger.isInsert ){
        rTriggerHandler.addOpportunities(Trigger.new);
    }

    if (Trigger.isUpdate){
        rTriggerHandler.addOpportunitiesWithOldMapCheck(Trigger.new,Trigger.oldMap);
    }

    if(Trigger.isDelete){
        rTriggerHandler.addOpportunities(Trigger.old);
    }

    rTriggerHandler.processWoodTypeRollUp();
    
}