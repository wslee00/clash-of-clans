public class ClanWar {
	public String state;	//inWar
	public Integer teamSize;	//10
	public Integer attacksPerMember;	//2
	public String preparationStartTime;	//20230429T014317.000Z
	public String startTime;	//20230430T004317.000Z
	public String endTime;	//20230501T004317.000Z
	public WarClan clan;
	public WarClan opponent;

	public Datetime getPreparationStartTime() {
		return ClashOfClansApiUtils.parseDttm(this.preparationStartTime);
	}

	public Datetime getStartTime() {
		return ClashOfClansApiUtils.parseDttm(this.startTime);
	}

	public Datetime getEndTime() {
		return ClashOfClansApiUtils.parseDttm(this.endTime);
	}

    public class WarClan {
		public String tag;
		public String name;
		public Clan.BadgeUrls badgeUrls;
		public Integer clanLevel;
		public Integer attacks;	//12
		public Integer stars;	//20
		public Integer expEarned;
		public Double destructionPercentage;	//71.7
		public List<ClanWarMember> members;
    }

    public class ClanWarMember {
		public String tag;
		public String name;
		public Integer mapPosition;	//1
		public Integer townhallLevel;
		public Integer opponentAttacks;	//0
		public ClanWarAttack bestOpponentAttack;
		public List<ClanWarAttack> attacks;
	}

	public class ClanWarAttack {
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