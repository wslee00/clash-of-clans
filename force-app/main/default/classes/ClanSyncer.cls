public with sharing class ClanSyncer {
    public ClanSyncer() {

    }

    public static void syncClan(String clanTag) {
        ClashOfClansClient client = new ClashOfClansClient();
        Clan clan = client.getClan(clanTag);
        Clan__c clanSObject = generateClanSObject(clan);

    }

    private static Clan__c generateClanSObject(Clan clan) {
        Clan__c clanSObject = new Clan__c();
        clanSObject.
    }
}