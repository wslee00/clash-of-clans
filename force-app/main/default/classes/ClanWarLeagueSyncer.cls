public with sharing class ClanWarLeagueSyncer {
    public static void syncCurrentWarLeagueGroup(String clanTag) {
        ClashOfClansClient client = new ClashOfClansClient();
        ClanWarLeagueGroup warLeagueGroup = client.getCurrentWarLeagueGroup(clanTag);
        ClanWarLeagueGroup__c clanWarLeagueGroupSobj = generateClanWarLeagueGroupSObject(warLeagueGroup, clanTag);
        upsert clanWarLeagueGroupSobj UniqueKey__c;

        List<ClanWarLeagueClan__c> clanWarLeagueClans = 
            generateClanWarLeagueClans(clanWarLeagueGroupSobj, warLeagueGroup);


    }

    private static ClanWarLeagueGroup__c generateClanWarLeagueGroupSObject(
        ClanWarLeagueGroup warLeagueGroup,
        String initiatingClanTag
    ) {
        return new ClanWarLeagueGroup__c(
            Tag__c = warLeagueGroup.tag,
            State__c = warLeagueGroup.state,
            Season__c = warLeagueGroup.season,
            InitiatingClanTag__c = initiatingClanTag,
            UniqueKey__c = initiatingClanTag + warLeagueGroup.season
        );
    }

    private static List<ClanWarLeagueClan__c> generateClanWarLeagueClans(
        ClanWarLeagueGroup__c leagueGroupSObj, 
        ClanWarLeagueGroup leagueGroup
    ) {
        List<ClanWarLeagueClan__c> leagueClanSObjs = new List<ClanWarLeagueClan__c>();
        for (ClanWarLeagueGroup.ClanWarLeagueClan leagueClan : leagueGroup.clans) {
            leagueClanSObjs.add(new ClanWarLeagueClan__c(
                ClanLevel__c = leagueClan.clanLevel,
                Tag__c = leagueClan.tag,
                Name = leagueClan.name
            ));
        }
        return leagueClanSObjs;
    }
}