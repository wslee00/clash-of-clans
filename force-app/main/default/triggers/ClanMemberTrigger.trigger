trigger ClanMemberTrigger on ClanMember__c (after update) {
    TriggerRunner.execute(new ClanMemberHandler());
}