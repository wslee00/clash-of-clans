trigger ClanWarMemberTrigger on ClanWarMember__c (before insert) {
    TriggerRunner.execute(new ClanWarMemberHandler());
}