public class ClanWarLeagueGroup {
    public String tag;
    public String state;
    public String season;
    public List<ClanWarLeagueClan> clans;
    public List<ClanWarLeagueRound> rounds;

    public class ClanWarLeagueClan {
        String tag;
        Integer clanLevel;
        String name;
        List<ClanWarLeagueClanMember> members;
        List<Clan.BadgeUrls> badgeUrls;
    }

    public class ClanWarLeagueClanMember {
        String tag;
        Integer townHallLevel;
        String name;
    }

    public class ClanWarLeagueRound {
        List<String> warTags;
    }
}