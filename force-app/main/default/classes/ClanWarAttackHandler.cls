public with sharing class ClanWarAttackHandler extends TriggerHandler {
    private Map<String, ClanWarMember__c> defenderMap = new Map<String, ClanWarMember__c>();
    private Map<Id, ClanWarMember__c> attackIdToMember = new Map<Id, ClanWarMember__c>();

    public override void bulkBefore() {
        Set<Id> clanWarMemberIds = new Set<Id>();
        for (ClanWarAttack__c attack : (List<ClanWarAttack__c>) Trigger.new) {
            clanWarMemberIds.add(attack.ClanWarMember__c);
        }

        List<ClanWarMember__c> attackingMembers = [SELECT WarClan__r.ClanWar__c FROM ClanWarMember__c WHERE Id IN :clanWarMemberIds];
        Map<Id, ClanWarMember__c> attackingMemberMap = new Map<Id, ClanWarMember__c>(attackingMembers);
        Set<Id> clanWarIds = new Set<Id>();
        for (ClanWarMember__c attackingMember : attackingMembers) {
            clanWarIds.add(attackingMember.WarClan__r.ClanWar__c);
        }

        for (ClanWarAttack__c attack : (List<ClanWarAttack__c>) Trigger.new) {
            this.attackIdToMember.put(attack.Id, attackingMemberMap.get(attack.ClanWarMember__c));
        }

        Set<String> defenderTags = new Set<String>();
        for (ClanWarAttack__c attack : (List<ClanWarAttack__c>) Trigger.new) {
            defenderTags.add(attack.DefenderTag__c);
        }

        List<ClanWarMember__c> defendingMembers = [
            SELECT Tag__c, WarClan__r.ClanWar__c 
            FROM ClanWarMember__c 
            WHERE WarClan__r.ClanWar__c IN :clanWarIds 
            AND Tag__c IN :defenderTags
        ];
        for (ClanWarMember__c defendingMember : defendingMembers) {
            this.defenderMap.put(defendingMember.WarClan__r.ClanWar__c + '|' + defendingMember.Tag__c, defendingMember);
        }
    }

    public override void beforeInsert(SObject so) {
        ClanWarAttack__c attack = (ClanWarAttack__c) so;
        Id clanWarId = this.attackIdToMember.get(attack.Id).WarClan__r.ClanWar__c;
        Id defenderId = this.defenderMap.get(clanWarId + '|' + attack.DefenderTag__c).Id;
        attack.Defender__c = defenderId;
    }

    public override void beforeUpdate(SObject oldSo, SObject newSo) {
        ClanWarAttack__c attack = (ClanWarAttack__c) newSo;
        if (attack.Defender__c != null) {
            return;
        }
        Id clanWarId = this.attackIdToMember.get(attack.Id).WarClan__r.ClanWar__c;
        Id defenderId = this.defenderMap.get(clanWarId + '|' + attack.DefenderTag__c).Id;
        attack.Defender__c = defenderId;
    }
}