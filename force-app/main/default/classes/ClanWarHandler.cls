public with sharing class ClanWarHandler extends TriggerHandler {
    private Map<String, ClanWarLeagueRoundWar__c> roundWarMap = new Map<String, ClanWarLeagueRoundWar__c>();
    private List<ClanWarLeagueRoundWar__c> roundWarsToUpdate = new List<ClanWarLeagueRoundWar__c>();

    public override void bulkAfter() {
        Set<String> warTags = new Set<String>();
        for (ClanWar__c clanWar : (List<ClanWar__c>) Trigger.new) {
            warTags.add(clanWar.WarTag__c);
        }
        warTags.remove(null);

        List<ClanWarLeagueRoundWar__c> roundWars = [
            SELECT WarTag__c 
            FROM ClanWarLeagueRoundWar__c 
            WHERE WarTag__c IN :warTags
            AND ClanWar__c = null
        ];
        for (ClanWarLeagueRoundWar__c roundWar : roundWars) {
            this.roundWarMap.put(roundWar.WarTag__c, roundWar);
        }
    }

    public override void afterInsert(SObject so) {
        ClanWar__c clanWar = (ClanWar__c) so;

        if (String.isBlank(clanWar.WarTag__c)) return;
        if (!this.roundWarMap.containsKey(clanWar.WarTag__c)) return;

        ClanWarLeagueRoundWar__c roundWar = this.roundWarMap.get(clanWar.WarTag__c);
        roundWarsToUpdate.add(new ClanWarLeagueRoundWar__c(Id = roundWar.Id, ClanWar__c = clanWar.Id));
    }

    public override void afterUpdate(SObject oldSo, SObject newSo) {
        ClanWar__c clanWar = (ClanWar__c) newSo;

        if (String.isBlank(clanWar.WarTag__c)) return;
        if (!this.roundWarMap.containsKey(clanWar.WarTag__c)) return;

        ClanWarLeagueRoundWar__c roundWar = this.roundWarMap.get(clanWar.WarTag__c);
        roundWarsToUpdate.add(new ClanWarLeagueRoundWar__c(Id = roundWar.Id, ClanWar__c = clanWar.Id));
    }

    public override void andFinally() {
        update roundWarsToUpdate;
    }
}