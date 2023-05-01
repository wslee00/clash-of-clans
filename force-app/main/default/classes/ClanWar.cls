public class ClanWar {
	public String state;	//inWar
	public Integer teamSize;	//10
	public Integer attacksPerMember;	//2
	public String preparationStartTime;	//20230429T014317.000Z
	public String startTime;	//20230430T004317.000Z
	public String endTime;	//20230501T004317.000Z
	public WarClan clan;
	public WarClan opponent;

	public Datetime getStartTime() {
		return ClashOfClansApiUtils.parseDttm(this.startTime);
	}

	public Datetime getEndTime() {
		return ClashOfClansApiUtils.parseDttm(this.endTime);
	}

    class WarClan {
        public String tag;	//#2LVJ29Y00
		public String name;	//The Zap Factory
		public Clan.BadgeUrls badgeUrls;
		public Integer clanLevel;	//12
		public Integer attacks;	//12
		public Integer stars;	//20
		public Double destructionPercentage;	//71.7
		public List<ClanWarMember> members;
    }

    class ClanWarMember extends ClanMember {
		public Integer mapPosition;	//1
		public List<ClanWarAttack> attacks;
		public Integer opponentAttacks;	//0
	}

	class ClanWarAttack {
		public String attackerTag;	//#LP98JGP82
		public String defenderTag;	//#L8RYYYQ8Y
		public Integer stars;	//2
		public Integer destructionPercentage;	//61
		public Integer order;	//13
		public Integer duration;	//140
	}

	public static ClanWar parse(String json) {
		return (ClanWar) System.JSON.deserialize(json, ClanWar.class);
	}
}