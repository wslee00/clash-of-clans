public with sharing class ClanWarVersusViewController {
    @AuraEnabled(cacheable=true)
    public static ClanWarDetails getWarDetails(Id clanWarId) {
        List<WarClan__c> warClans = [
            SELECT Name, 
                (
                    SELECT Name, 
                        Tag__c, 
                        OpponentAttacks__c, 
                        TownHallLevel__c 
                    FROM ClanWarMembers__r 
                    ORDER BY MapPosition__c
                ) 
            FROM WarClan__c 
            WHERE ClanWar__c = :clanWarId WITH SECURITY_ENFORCED
        ];
        if (warClans.size() != 2) {
            throw new ClashOfClansException('Did not find 2 war clans: ' + warClans.size());
        }

        ClanWarDetails details = new ClanWarDetails();
        details.clan = warClans[0];
        details.opponent = warClans[1];
        return details;
    }

    public class ClanWarDetails {
        @AuraEnabled public WarClan__c clan;
        @AuraEnabled public WarClan__c opponent;
    }
}