trigger WarClanTrigger on WarClan__c (before insert) {
    TriggerRunner.execute(new WarClanHandler());
}