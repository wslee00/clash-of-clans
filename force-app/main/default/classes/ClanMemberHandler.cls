public with sharing class ClanMemberHandler extends TriggerHandler {
    private List<MemberDonationReset__e> memberDonationResets = new List<MemberDonationReset__e>();

    public override void afterUpdate(SObject oldSo, SObject newSo) {
        ClanMember__c oldClanMember = (ClanMember__c) oldSo;
        ClanMember__c newClanMember = (ClanMember__c) newSo;

        if (
            newClanMember.Donations__c < oldClanMember.Donations__c 
            || newClanMember.DonationsReceived__c < oldClanMember.DonationsReceived__c
        ) {
            memberDonationResets.add(new MemberDonationReset__e(
                ClanMemberId__c = oldClanMember.Id,
                Donations__c = oldClanMember.Donations__c,
                DonationsReceived__c = oldClanMember.DonationsReceived__c
            ));
        }
    }

    public override void andFinally() {
        Eventbus.publish(memberDonationResets);
    }
}