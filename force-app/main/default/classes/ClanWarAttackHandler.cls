public with sharing class ClanWarAttackHandler extends TriggerHandler {
    private Map<String, ClanWarMember__c> defenderMap = new Map<String, ClanWarMember__c>();
    private Map<Id, ClanWarAttack__c> attackMap = new Map<Id, ClanWarAttack__c>();

    public override void bulkBefore() {
        this.attackMap = new Map<Id, ClanWarAttack__c>(
            [SELECT Id, ClanWarMember__r.WarClan__r.ClanWar__c FROM ClanWarAttack__c]
        );

        Set<Id> clanWarIds = new Set<Id>();
        for (ClanWarAttack__c attack : this.attackMap.values()) {
            clanWarIds.add(attack.ClanWarMember__r.WarClan__r.ClanWar__c);
        }

        Set<String> defenderTags = new Set<String>();
        for (ClanWarAttack__c attack : (List<ClanWarAttack__c>) Trigger.new) {
            defenderTags.add(attack.DefenderTag__c);
        }

        List<ClanWarMember__c> clanWarMembers = [
            SELECT Tag__c, WarClan__r.ClanWar__c 
            FROM ClanWarMember__c 
            WHERE WarClan__r.ClanWar__c IN :clanWarIds 
            AND Tag__c IN :defenderTags
        ];
        for (ClanWarMember__c clanWarMember : clanWarMembers) {
            this.defenderMap.put(clanWarMember.WarClan__r.ClanWar__c + '|' + clanWarMember.Tag__c, clanWarMember);
        }
    }

    public override void beforeInsert(SObject so) {
        ClanWarAttack__c attack = (ClanWarAttack__c) so;
        Id clanWarId = this.attackMap.get(attack.Id).ClanWarMember__r.WarClan__r.ClanWar__c;
        Id defenderId = this.defenderMap.get(clanWarId + '|' + attack.DefenderTag__c).Id;
        attack.Defender__c = defenderId;
    }

    public override void beforeUpdate(SObject oldSo, SObject newSo) {
        ClanWarAttack__c attack = (ClanWarAttack__c) newSo;
        if (attack.Defender__c != null) {
            return;
        }
        Id clanWarId = this.attackMap.get(attack.Id).ClanWarMember__r.WarClan__r.ClanWar__c;
        Id defenderId = this.defenderMap.get(clanWarId + '|' + attack.DefenderTag__c).Id;
        attack.Defender__c = defenderId;
    }
}