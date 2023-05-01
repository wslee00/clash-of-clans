public virtual class ClanMember {
    public String tag;	//#YG090UPVJ
    public String name;	//munna
    public String role;	//coLeader
    public Integer expLevel;	//145
    public Clan.League league;
    public Integer trophies;	//4976
    public Integer versusTrophies;	//2926
    public Integer clanRank;	//1
    public Integer previousClanRank;	//1
    public Integer donations;	//40
    public Integer donationsReceived;	//2014
    public PlayerHouse playerHouse;

    public class PlayerHouse {
		public List<PlayerHouseElement> elements;
	}

	public class PlayerHouseElement {
		public String type;	//ground
		public Integer id;	//82000001
	}
}