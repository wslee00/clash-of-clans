public with sharing class MemberDonationResetHandler extends PlatformEventHandler {
    private List<ClanMemberHistory__c> memberHistoriesToInsert = new List<ClanMemberHistory__c>();

    public override void afterInsert(SObject so) {
        MemberDonationReset__e memberDonationReset = (MemberDonationReset__e) so;
        Id clanMemberId = (Id) memberDonationReset.ClanMemberId__c;
        memberHistoriesToInsert.add(new ClanMemberHistory__c(
            ClanMember__c = clanMemberId,
            Donations__c = memberDonationReset.Donations__c,
            DonationsReceived__c = memberDonationReset.DonationsReceived__c
        ));
    }

    public override void andFinally() {
        insert memberHistoriesToInsert;
    }
}