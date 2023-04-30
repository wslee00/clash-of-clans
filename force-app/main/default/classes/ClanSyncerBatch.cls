public with sharing class ClanSyncerBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, System.Schedulable {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT ClanTag__c FROM ClanToSync__c]);
    }

    public void execute(Database.BatchableContext bc, List<SObject> records) {
        for (ClanToSync__c clansToSync : (List<ClanToSync__c>) records) {
            ClanSyncer.syncClan(clansToSync.ClanTag__c);
        }
    }

    public void finish(Database.BatchableContext bc) { }

    public void execute(System.SchedulableContext sc) {
        Database.executeBatch(new ClanSyncerBatch(), 1);
    }
}