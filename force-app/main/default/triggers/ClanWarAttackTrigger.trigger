trigger ClanWarAttackTrigger on ClanWarAttack__c (before insert, before update) {
    TriggerRunner.execute(new ClanWarAttackHandler());
}