public with sharing class WarClanHandler extends TriggerHandler {
    private Map<String, Clan__c> clanMap = new Map<String, Clan__c>();

    public override void bulkBefore() {
        Set<String> clanTags = new Set<String>();
        for (WarClan__c warClan : (List<WarClan__c>) Trigger.new) {
            clanTags.add(warClan.Tag__c);
        }

        List<Clan__c> clans = [SELECT Tag__c FROM Clan__c WHERE Tag__c IN :clanTags];
        for (Clan__c clan : clans) {
            this.clanMap.put(clan.Tag__c, clan);
        }
    }

    public override void beforeInsert(SObject so) {
        WarClan__c warClan = (WarClan__c) so;
        if (!this.clanMap.containsKey(warClan.Tag__c)) {
            return;
        }
        warClan.Clan__c = this.clanMap.get(warClan.Tag__c).Id;
    }
}