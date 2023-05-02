trigger ClanWarTrigger on ClanWar__c (after insert, after update) {
    TriggerRunner.execute(new ClanWarHandler());
}