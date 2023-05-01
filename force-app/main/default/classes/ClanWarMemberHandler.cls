public with sharing class ClanWarMemberHandler extends TriggerHandler {
    private Map<String, ClanMember__c> clanMemberMap = new Map<String, ClanMember__c>();

    public override void bulkBefore() {
        Set<String> memberTags = new Set<String>();
        for (ClanWarMember__c warMember : (List<ClanWarMember__c>) Trigger.new) {
            memberTags.add(warMember.Tag__c);
        }

        List<ClanMember__c> clanMembers = [SELECT Tag__c FROM ClanMember__c WHERE Tag__c IN :memberTags];
        for (ClanMember__c clanMember : clanMembers) {
            this.clanMemberMap.put(clanMember.Tag__c, clanMember);
        }
    }

    public override void beforeInsert(SObject so) {
        ClanWarMember__c warMember = (ClanWarMember__c) so;
        if (!this.clanMemberMap.containsKey(warMember.Tag__c)) {
            return;
        }

        warMember.ClanMember__c = this.clanMemberMap.get(warMember.Tag__c).Id;
    }
}