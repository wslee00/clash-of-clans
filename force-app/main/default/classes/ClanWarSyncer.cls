public with sharing class ClanWarSyncer {
    public static void syncCurrentWar(String clanTag) {
        ClashOfClansClient client = new ClashOfClansClient();
        ClanWar currentWar = client.getClanCurrentWar(clanTag);

        List<Clan__c> opponentClans = [SELECT Id FROM Clan__c WHERE Tag__c = :currentWar.opponent.tag];
        if (opponentClans.size() > 1) {
            throw new ClashOfClansException('More than one clan with tag ' + currentWar.opponent.tag);
        }
        if (opponentClans.isEmpty()) {
            ClanSyncer.syncClan(currentWar.opponent.tag);
        }

        ClanWar__c currentWarSObject = generateClanWarSObject(currentWar);
        upsert currentWarSObject UniqueKey__c;

        WarClan__c clanWarClan = generateWarClan(currentWarSObject, currentWar.clan);
        WarClan__c opponentWarClan = generateWarClan(currentWarSObject, currentWar.opponent);
        upsert new List<WarClan__c>{ clanWarClan, opponentWarClan } UniqueKey__c;

        List<ClanWarMember__c> cwMembersToUpsert = new List<ClanWarMember__c>();
        for (ClanWar.ClanWarMember member : currentWar.clan.members) {
            cwMembersToUpsert.add(generateClanWarMember(clanWarClan, member));
        }
        for (ClanWar.ClanWarMember member : currentWar.opponent.members) {
            cwMembersToUpsert.add(generateClanWarMember(opponentWarClan, member));
        }
        upsert cwMembersToUpsert UniqueKey__c;

        List<ClanWarMember__c> queriedWarMembers = [
            SELECT ClanMember__r.Tag__c 
            FROM ClanWarMember__c 
            WHERE WarClan__r.ClanWar__c = :currentWarSObject.Id
        ];
        Map<String, ClanWarMember__c> clanWarMemberMap = new Map<String, ClanWarMember__c>();
        for (ClanWarMember__c warMember : queriedWarMembers) {
            clanWarMemberMap.put(warMember.ClanMember__r.Tag__c, warMember);
        }

        List<ClanWarAttack__c> cwAttacksToUpsert = new List<ClanWarAttack__c>();
        for (ClanWar.ClanWarMember member : currentWar.clan.members) {
            ClanWarMember__c clanWarMember = clanWarMemberMap.get(member.tag);
            for (ClanWar.ClanWarAttack attack : member.attacks) {
                cwAttacksToUpsert.add(generateClanWarAttack(clanWarMember, attack));
            }
        }
        upsert cwAttacksToUpsert UniqueKey__c;
    }

    private static ClanWar__c generateClanWarSObject(ClanWar currentWar) {
        ClanWar__c currentWarSObject = new ClanWar__c(
            State__c = currentWar.state,
            TeamSize__c = currentWar.teamSize,
            AttacksPerMember__c = currentWar.attacksPerMember,
            PreparationStartTime__c = currentWar.getPreparationStartTime(),
            StartTime__c = currentWar.getStartTime(),
            EndTime__c = currentWar.getEndTime(),
            UniqueKey__c = currentWar.clan.tag + currentWar.opponent.tag + currentWar.preparationStartTime
        );
        return currentWarSObject;
    }

    private static WarClan__c generateWarClan(ClanWar__c clanWarSObject, ClanWar.WarClan warClan) {
        WarClan__c warClanSObject = new WarClan__c(
            ClanWar__c = clanWarSObject.Id,
            Name = warClan.name,
            ClanTag__c = warClan.tag,
            DestructionPercentage__c = warClan.destructionPercentage,
            Stars__c = warClan.stars,
            Attacks__c = warClan.attacks,
            UniqueKey__c = clanWarSObject.Id + warClan.tag
        );

        return warClanSObject;
    }

    private static ClanWarMember__c generateClanWarMember(WarClan__c warClan, ClanWar.ClanWarMember clanWarMember) {
        ClanWarMember__c clanWarMemberSObj = new ClanWarMember__c(
            UniqueKey__c = warClan.Id + clanWarMember.tag,
            WarClan__c = warClan.Id,
            OpponentAttacks__c = clanWarMember.opponentAttacks,
            MapPosition__c = clanWarMember.mapPosition
        );
        return clanWarMemberSObj;
    }

    private static ClanWarAttack__c generateClanWarAttack(
        ClanWarMember__c clanWarMember, 
        ClanWar.ClanWarAttack clanWarAttack
    ) {
        ClanWarAttack__c clanWarAttackSObj = new ClanWarAttack__c(
            Duration__c = clanWarAttack.duration,
            Order__c = clanWarAttack.order,
            DestructionPercentage__c = clanWarAttack.destructionPercentage,
            Stars__c = clanWarAttack.stars,
            DefenderTag__c = clanWarAttack.defenderTag,
            AttackerTag__c = clanWarAttack.attackerTag,
            ClanWarMember__c = clanWarMember.Id
        );

        return clanWarAttackSObj;
    }
}