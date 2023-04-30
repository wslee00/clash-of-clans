trigger MemberDonationResetTrigger on MemberDonationReset__e (after insert) {
    PlatformEventTriggerRun.execute(new MemberDonationResetHandler());
}