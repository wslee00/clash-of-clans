public with sharing class ClanWarMemberController {
    @AuraEnabled
    public static List<ClanWarAttack__c> getAttacks(Id clanWarMemberId) {
        return [
            SELECT Id, DefenderTag__c, DestructionPercentage__c, Stars__c 
            FROM ClanWarAttack__c
            WHERE ClanWarMember__c = :clanWarMemberId
        ];
    }
}