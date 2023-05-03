public with sharing class ClanWarLeagueGroupSyncer {
    @AuraEnabled
    public static void syncCurrentWar(String clanTag) {
        ClashOfClansClient client = new ClashOfClansClient();
        ClanWarLeagueGroup leagueGroup = client.getCurrentWarLeagueGroup(clanTag);
        ClanWarLeagueGroup__c leagueGroupToUpsert = generateLeagueGroupSObj(leagueGroup, clanTag);
        upsert leagueGroupToUpsert UniqueKey__c;

        List<ClanWarLeagueClan__c> clansToUpsert = generateClans(leagueGroupToUpsert, leagueGroup);
        upsert clansToUpsert UniqueKey__c;

        List<ClanWarLeagueClanMember__c> membersToUpsert = generateMembers(clansToUpsert, leagueGroup.clans);
        upsert membersToUpsert UniqueKey__c;

        List<ClanWarLeagueRound__c> roundsToUpsert = generateRounds(leagueGroupToUpsert, leagueGroup.rounds);
        upsert roundsToUpsert WarTags__c;

        List<ClanWarLeagueRoundWar__c> roundWarsToUpsert = generateRoundWars(roundsToUpsert);
        upsert roundWarsToUpsert WarTag__c;

        Database.executeBatch(new ClanWarSyncerBatch(), 1);
    }

    private static ClanWarLeagueGroup__c generateLeagueGroupSObj(
        ClanWarLeagueGroup warLeagueGroup,
        String initiatingClanTag
    ) {
        return new ClanWarLeagueGroup__c(
            Name = warLeagueGroup.season + ' ' + initiatingClanTag,
            Tag__c = warLeagueGroup.tag,
            State__c = warLeagueGroup.state,
            Season__c = warLeagueGroup.season,
            InitiatingClanTag__c = initiatingClanTag,
            UniqueKey__c = initiatingClanTag + warLeagueGroup.season
        );
    }

    private static List<ClanWarLeagueClan__c> generateClans(
        ClanWarLeagueGroup__c leagueGroupSObject, 
        ClanWarLeagueGroup leagueGroup
    ) {
        List<ClanWarLeagueClan__c> clanSObjects = new List<ClanWarLeagueClan__c>();
        for (ClanWarLeagueGroup.ClanWarLeagueClan leagueClan : leagueGroup.clans) {
            clanSObjects.add(new ClanWarLeagueClan__c(
                ClanWarLeagueGroup__c = leagueGroupSObject.Id,
                ClanLevel__c = leagueClan.clanLevel,
                Tag__c = leagueClan.tag,
                Name = leagueClan.name,
                UniqueKey__c = leagueGroupSObject.Id + leagueClan.tag
            ));
        }
        return clanSObjects;
    }

    private static List<ClanWarLeagueClanMember__c> generateMembers(
        List<ClanWarLeagueClan__c> clanSObjects, 
        List<ClanWarLeagueGroup.ClanWarLeagueClan> clans
    ) {
        Map<String, ClanWarLeagueClan__c> leagueClanMap = getLeagueClanMap(clanSObjects);

        List<ClanWarLeagueClanMember__c> membersToUpsert = new List<ClanWarLeagueClanMember__c>();
        for (ClanWarLeagueGroup.ClanWarLeagueClan clan : clans) {
            ClanWarLeagueClan__c clanSobj = leagueClanMap.get(clan.tag);

            for (ClanWarLeagueGroup.ClanWarLeagueClanMember member : clan.members) {
                membersToUpsert.add(new ClanWarLeagueClanMember__c(
                    ClanWarLeagueClan__c = clanSobj.Id,
                    TownHallLevel__c = member.townHallLevel,
                    Tag__c = member.tag,
                    Name = member.name,
                    UniqueKey__c = clanSobj.Id + member.tag
                ));
            }
        }

        return membersToUpsert;
    }

    private static Map<String, ClanWarLeagueClan__c> getLeagueClanMap(List<ClanWarLeagueClan__c> clanSobjs) {
        Map<String, ClanWarLeagueClan__c> leagueClanMap = new Map<String, ClanWarLeagueClan__c>();
        for (ClanWarLeagueClan__c clanSobj : clanSobjs) {
            leagueClanMap.put(clanSobj.Tag__c, clanSobj);
        }
        return leagueClanMap;
    }

    private static List<ClanWarLeagueRound__c> generateRounds(
        ClanWarLeagueGroup__c leagueGroupSObject, 
        List<ClanWarLeagueGroup.ClanWarLeagueRound> rounds
    ) {
        List<ClanWarLeagueRound__c> roundSObjects = new List<ClanWarLeagueRound__c>();
        for (Integer i = 0; i < rounds.size() - 1; i++) {
            ClanWarLeagueGroup.ClanWarLeagueRound round = rounds[i];
            if (round.warTags.contains('#0')) continue;

            roundSObjects.add(new ClanWarLeagueRound__c(
                RoundNumber__c = i + 1,
                ClanWarLeagueGroup__c = leagueGroupSObject.Id,
                WarTags__c = String.join(round.warTags, ';')
            ));
        }

        return roundSObjects;
    }

    private static List<ClanWarLeagueRoundWar__c> generateRoundWars(List<ClanWarLeagueRound__c> rounds) {
        List<ClanWarLeagueRoundWar__c> roundWars = new List<ClanWarLeagueRoundWar__c>();
        for (ClanWarLeagueRound__c round : rounds) {
            List<String> warTags = round.WarTags__c.split(';');
            for (String warTag : warTags) {
                roundWars.add(new ClanWarLeagueRoundWar__c(
                    ClanWarLeagueRound__c = round.Id,
                    WarTag__c = warTag
                ));
            }
        }
        return roundWars;
    }
}