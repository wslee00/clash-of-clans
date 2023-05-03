public with sharing class ClanWarSyncerBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT WarTag__c
            FROM ClanWarLeagueRoundWar__c
            WHERE ClanWar__c = null
            AND WarTag__c != null
        ]);
    }

    public void execute(Database.BatchableContext bc, List<ClanWarLeagueRoundWar__c> roundWars) {
        for (ClanWarLeagueRoundWar__c roundWar : roundWars) {
            ClanWarSyncer.syncClanWarLeagueWar(roundWar.WarTag__c);
        }
    }

    public void finish(Database.BatchableContext bc) {

    }
}