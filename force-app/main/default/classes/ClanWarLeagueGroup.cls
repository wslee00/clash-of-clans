public class ClanWarLeagueGroup {
    public String tag;
    public String state;
    public String season;
    public List<ClanWarLeagueClan> clans;
    public List<ClanWarLeagueRound> rounds;

    public class ClanWarLeagueClan {
        public String tag;
        public Integer clanLevel;
        public String name;
        public List<ClanWarLeagueClanMember> members;
        public Clan.BadgeUrls badgeUrls;
    }

    public class ClanWarLeagueClanMember {
        public String tag;
        public Integer townHallLevel;
        public String name;
    }

    public class ClanWarLeagueRound {
        public List<String> warTags;
    }

    public static ClanWarLeagueGroup parse(String json) {
        return (ClanWarLeagueGroup) System.JSON.deserialize(json, ClanWarLeagueGroup.class);
    }
}