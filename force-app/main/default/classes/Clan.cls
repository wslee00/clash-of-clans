public class Clan {
	public String tag;	//#2LVJ29Y00
	public String name;	//The Zap Factory
	public String type;	//inviteOnly
	public String description;	//All are welcome! be friendly and helpful ⚠️keep even donations ⚠️team first mindset...
	public Location location;
	public boolean isFamilyFriendly;
	public BadgeUrls badgeUrls;
	public Integer clanLevel;	//10
	public Integer clanPoints;	//36154
	public Integer clanVersusPoints;	//32318
	public Integer clanCapitalPoints;	//2422
	public CapitalLeague capitalLeague;
	public Integer requiredTrophies;	//200
	public String warFrequency;	//always
	public Integer warWinStreak;	//0
	public Integer warWins;	//52
	public Integer warTies;	//0
	public Integer warLosses;	//42
	public boolean isWarLogPublic;
	public WarLeague warLeague;
	public Integer members;	//45
	public List<Member> memberList;
	public List<Label> labels;
	public Integer requiredVersusTrophies;	//200
	public Integer requiredTownhallLevel;	//10
	public ClanCapital clanCapital;
	public ChatLanguage chatLanguage;
	public class Location {
		public Integer id;	//32000006
		public String name;	//International
		public boolean isCountry;
	}
	public class BadgeUrls {
		public String small;	//https://api-assets.clashofclans.com/badges/70/uHOr7CGhVekq-p8bnVSfD9B-L_RX1_xeSALR38O_PA0.png
		public String large;	//https://api-assets.clashofclans.com/badges/512/uHOr7CGhVekq-p8bnVSfD9B-L_RX1_xeSALR38O_PA0.png
		public String medium;	//https://api-assets.clashofclans.com/badges/200/uHOr7CGhVekq-p8bnVSfD9B-L_RX1_xeSALR38O_PA0.png
	}
	public class CapitalLeague {
		public Integer id;	//85000012
		public String name;	//Crystal League I
	}
	public class WarLeague {
		public Integer id;	//48000012
		public String name;	//Crystal League I
	}
	public class Member {
		public String tag;	//#YG090UPVJ
		public String name;	//munna
		public String role;	//coLeader
		public Integer expLevel;	//145
		public League league;
		public Integer trophies;	//4976
		public Integer versusTrophies;	//2926
		public Integer clanRank;	//1
		public Integer previousClanRank;	//1
		public Integer donations;	//40
		public Integer donationsReceived;	//2014
		public PlayerHouse playerHouse;
	}
	public class League {
		public Integer id;	//29000021
		public String name;	//Titan League I
		public IconUrls iconUrls;
	}
	public class IconUrls {
		public String small;	//https://api-assets.clashofclans.com/labels/64/lXaIuoTlfoNOY5fKcQGeT57apz1KFWkN9-raxqIlMbE.png
		public String medium;	//https://api-assets.clashofclans.com/labels/128/lXaIuoTlfoNOY5fKcQGeT57apz1KFWkN9-raxqIlMbE.png
	}
	public class PlayerHouse {
		public List<Element> elements;
	}
	public class Element {
		public String type;	//ground
		public Integer id;	//82000001
	}
	public class Label {
		public Integer id;	//56000000
		public String name;	//Clan Wars
		public IconUrls iconUrls;
	}
	public class ClanCapital {
		public Integer capitalHallLevel;	//8
		public List<District> districts;
	}
	public class District {
		public Integer id;	//70000000
		public String name;	//Capital Peak
		public Integer districtHallLevel;	//8
	}
	public class ChatLanguage {
		public Integer id;	//75000000
		public String name;	//English
		public String languageCode;	//EN
	}

	public static Clan parse(String json) {
		return (Clan) System.JSON.deserialize(json, Clan.class);
	}
}