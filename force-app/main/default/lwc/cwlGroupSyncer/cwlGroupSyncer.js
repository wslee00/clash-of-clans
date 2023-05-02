import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, wire } from 'lwc';
import INITIATING_CLAN_TAG_FIELD from '@salesforce/schema/ClanWarLeagueGroup__c.InitiatingClanTag__c';
import syncCurrentWar from '@salesforce/apex/ClanWarLeagueGroupSyncer.syncCurrentWar';

export default class CwlGroupSyncer extends LightningElement {
    @api recordId;

    cwlGroup;
    isProcessing = false;

    @wire(getRecord, { recordId: '$recordId', fields: [INITIATING_CLAN_TAG_FIELD]})
    processGetRecord({ data, error }) {
        if (error) {
            console.error('Error occurred', error);
        }
        if (data) {
            this.cwlGroup = data;
        }
    }

    async syncCwlGroup() {
        const initiatingClanTag = getFieldValue(this.cwlGroup, INITIATING_CLAN_TAG_FIELD);
        console.log('syncing', initiatingClanTag);
        this.isProcessing = true;
        try {
            await syncCurrentWar({ clanTag: initiatingClanTag });
        } catch (error) {
            console.error('Error occured', error);
        }
        this.isProcessing = false;
    }
}