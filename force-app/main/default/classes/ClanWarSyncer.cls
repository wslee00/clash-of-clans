public with sharing class ClanWarSyncer {
    public static void syncCurrentWar(String clanTag) {
        ClashOfClansClient client = new ClashOfClansClient();
        ClanWar currentWar = client.getClanCurrentWar(clanTag);
        upsertClanWarSObjects(currentWar, null);
    }

    @AuraEnabled
    public static void syncClanWarLeagueWar(String warTag) {
        ClashOfClansClient client = new ClashOfClansClient();
        ClanWar cwlWar = client.getClanWarLeagueWar(warTag);
        upsertClanWarSObjects(cwlWar, warTag);
    }

    private static void upsertClanWarSObjects(ClanWar clanWar, String warTag) {
        ClanWar__c clanWarSObject = generateClanWarSObject(clanWar);
        clanWarSObject.WarTag__c = warTag;
        upsert clanWarSObject UniqueKey__c;

        WarClan__c clanWarClan = generateWarClan(clanWarSObject, clanWar.clan);
        WarClan__c opponentWarClan = generateWarClan(clanWarSObject, clanWar.opponent);
        upsert new List<WarClan__c>{ clanWarClan, opponentWarClan } UniqueKey__c;

        List<ClanWarMember__c> membersToUpsert = new List<ClanWarMember__c>();
        for (ClanWar.ClanWarMember member : clanWar.clan.members) {
            membersToUpsert.add(generateClanWarMember(clanWarClan, member));
        }
        for (ClanWar.ClanWarMember member : clanWar.opponent.members) {
            membersToUpsert.add(generateClanWarMember(opponentWarClan, member));
        }
        upsert membersToUpsert UniqueKey__c;

        List<ClanWarMember__c> queriedWarMembers = [
            SELECT ClanMember__r.Tag__c 
            FROM ClanWarMember__c 
            WHERE WarClan__r.ClanWar__c = :clanWarSObject.Id
        ];
        Map<String, ClanWarMember__c> clanWarMemberMap = new Map<String, ClanWarMember__c>();
        for (ClanWarMember__c warMember : queriedWarMembers) {
            clanWarMemberMap.put(warMember.ClanMember__r.Tag__c, warMember);
        }

        List<ClanWarAttack__c> cwAttacksToUpsert = new List<ClanWarAttack__c>();
        for (ClanWar.ClanWarMember member : clanWar.clan.members) {
            ClanWarMember__c clanWarMember = clanWarMemberMap.get(member.tag);

            if (member.attacks == null) {
                continue;
            }

            for (ClanWar.ClanWarAttack attack : member.attacks) {
                cwAttacksToUpsert.add(generateClanWarAttack(clanWarMember, attack));
            }
        }
        upsert cwAttacksToUpsert UniqueKey__c;
    }

    private static ClanWar__c generateClanWarSObject(ClanWar clanWar) {
        ClanWar__c clanWarSObject = new ClanWar__c(
            Name = clanWar.clan.name + ' vs. ' + clanWar.opponent.name,
            State__c = clanWar.state,
            TeamSize__c = clanWar.teamSize,
            AttacksPerMember__c = clanWar.attacksPerMember,
            PreparationStartTime__c = clanWar.getPreparationStartTime(),
            StartTime__c = clanWar.getStartTime(),
            EndTime__c = clanWar.getEndTime(),
            WarStartTime__c = String.isBlank(clanWar.warStartTime) ? null : clanWar.getWarStartTime(),
            UniqueKey__c = clanWar.clan.tag + clanWar.opponent.tag + clanWar.preparationStartTime
        );
        return clanWarSObject;
    }

    private static WarClan__c generateWarClan(ClanWar__c clanWarSObject, ClanWar.WarClan warClan) {
        WarClan__c warClanSObject = new WarClan__c(
            ClanWar__c = clanWarSObject.Id,
            ClanLevel__c = warClan.clanLevel,
            Name = warClan.name,
            Tag__c = warClan.tag,
            DestructionPercentage__c = warClan.destructionPercentage,
            Stars__c = warClan.stars,
            Attacks__c = warClan.attacks,
            UniqueKey__c = clanWarSObject.Id + warClan.tag
        );

        return warClanSObject;
    }

    private static ClanWarMember__c generateClanWarMember(WarClan__c warClan, ClanWar.ClanWarMember clanWarMember) {
        ClanWarMember__c clanWarMemberSObj = new ClanWarMember__c(
            Name = clanWarMember.name,
            UniqueKey__c = warClan.Id + clanWarMember.tag,
            Tag__c = clanWarMember.tag,
            WarClan__c = warClan.Id,
            OpponentAttacks__c = clanWarMember.opponentAttacks,
            MapPosition__c = clanWarMember.mapPosition,
            TownHallLevel__c = clanWarMember.townhallLevel
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
            ClanWarMember__c = clanWarMember.Id,
            UniqueKey__c = clanWarMember.Id + clanWarAttack.attackerTag + clanWarAttack.defenderTag
        );

        return clanWarAttackSObj;
    }
}