public class ClanWarLog {
	public List<ClanWarLogEntry> items;
	public Paging paging;
	public class ClanWarLogEntry {
		public String result;	//lose
		public String endTime;	//20230302T062825.000Z
		public Integer teamSize;	//25
		public Integer attacksPerMember;	//2
		public WarClan clan;
		public WarClan opponent;
	}
	public class WarClan {
		public String tag;	//#2LVJ29Y00
		public String name;	//The Zap Factory
		public BadgeUrls badgeUrls;
		public Integer clanLevel;	//10
		public Integer attacks;	//34
		public Integer stars;	//63
		public Double destructionPercentage;	//90.6
		public Integer expEarned;	//232
	}
	public class BadgeUrls {
		public String small;	//https://api-assets.clashofclans.com/badges/70/8igLsY7rfmiXhdf5WtIc90P4xRhZebiIM7x-pdWG0WU.png
		public String large;	//https://api-assets.clashofclans.com/badges/512/8igLsY7rfmiXhdf5WtIc90P4xRhZebiIM7x-pdWG0WU.png
		public String medium;	//https://api-assets.clashofclans.com/badges/200/8igLsY7rfmiXhdf5WtIc90P4xRhZebiIM7x-pdWG0WU.png
	}
	class Paging {
		public Cursors cursors;
	}
	class Cursors {
	}
	public static ClanWarLog parse(String json){
		return (ClanWarLog) System.JSON.deserialize(json, ClanWarLog.class);
	}
}