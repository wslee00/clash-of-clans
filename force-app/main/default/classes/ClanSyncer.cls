public with sharing class ClanSyncer {
    public static void syncClan(String clanTag) {
        ClashOfClansClient client = new ClashOfClansClient();
        Clan clan = client.getClan(clanTag);
        Clan__c clanSObject = generateClanSObject(clan);
        upsert clanSObject Tag__c;

        List<ClanMember__c> clanMembers = generateClanMembers(clanSObject, clan.memberList);
        upsert clanMembers Tag__c;
    }

    private static Clan__c generateClanSObject(Clan clan) {
        Clan__c clanSObject = new Clan__c();
        clanSObject.Tag__c = clan.tag;
        clanSObject.Name = clan.name;
        clanSObject.Type__c = clan.type;
        clanSObject.Description__c = clan.description;
        clanSObject.IsFamilyFriendly__c = clan.isFamilyFriendly;
        clanSObject.ClanLevel__c = clan.clanLevel;
        clanSObject.ClanPoints__c = clan.clanPoints;
        clanSObject.ClanCapitalPoints__c = clan.clanCapitalPoints;
        clanSObject.RequiredTrophies__c = clan.requiredTrophies;
        clanSObject.WarFrequency__c = clan.warFrequency;
        clanSObject.WarWinStreak__c = clan.warWinStreak;
        clanSObject.WarWins__c = clan.warWins;
        clanSObject.WarTies__c = clan.warTies;
        clanSObject.WarLosses__c = clan.warLosses;
        clanSObject.IsWarLogPublic__c = clan.isWarLogPublic;
        clanSObject.Members__c = clan.members;
        clanSObject.RequiredVersusTrophies__c = clan.requiredVersusTrophies;
        clanSObject.RequiredTownHallLevel__c = clan.requiredTownhallLevel;
        return clanSObject;
    }

    private static List<ClanMember__c> generateClanMembers(Clan__c clanSObject, List<ClanMember> clanMembers) {
        List<ClanMember__c> clanMemberSObjs = new List<ClanMember__c>();
        for (ClanMember clanMember : clanMembers) {
            ClanMember__c clanMemberSObj = new ClanMember__c();
            clanMemberSObj.Clan__c = clanSObject.Id;
            clanMemberSObj.Tag__c = clanMember.tag;
            clanMemberSObj.Name = clanMember.name;
            clanMemberSObj.Role__c = clanMember.role;
            clanMemberSObj.ExpLevel__c = clanMember.expLevel;
            clanMemberSObj.Trophies__c = clanMember.trophies;
            clanMemberSObj.VersusTrophies__c = clanMember.versusTrophies;
            clanMemberSObj.ClanRank__c = clanMember.clanRank;
            clanMemberSObj.PreviousClanRank__c = clanMember.previousClanRank;
            clanMemberSObj.Donations__c = clanMember.donations;
            clanMemberSObj.DonationsReceived__c = clanMember.donationsReceived;
            clanMemberSObjs.add(clanMemberSObj);
        }
        return clanMemberSObjs;
    }
}