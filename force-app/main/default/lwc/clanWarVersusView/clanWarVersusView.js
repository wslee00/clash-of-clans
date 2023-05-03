import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, wire } from 'lwc';
import getWarDetails from '@salesforce/apex/ClanWarVersusViewController.getWarDetails';
import syncClanWarLeagueWar from '@salesforce/apex/ClanWarSyncer.syncClanWarLeagueWar';
import CLAN_WAR_NAME_FIELD from '@salesforce/schema/ClanWar__c.Name';
import WAR_TAG_FIELD from '@salesforce/schema/ClanWar__c.WarTag__c';

export default class ClanWarVersusView extends LightningElement {
    @api recordId; // clan war id

    clanWar;
    warDetails;

    @wire(getRecord, { recordId: '$recordId', fields: [CLAN_WAR_NAME_FIELD, WAR_TAG_FIELD]})
    processGetRecord({ data, error }) {
        if (error) {
            console.error(error);
        }
        if (data) {
            this.clanWar = data;
        }
    }

    @wire(getWarDetails, { clanWarId: '$recordId' })
    processGetWarDetails({ data, error }) {
        if (error) {
            console.error(error);
        }
        if (data) {
            this.warDetails = data;
            console.log('war details', this.warDetails);
        }
    }

    get clanWarName() {
        return getFieldValue(this.clanWar, CLAN_WAR_NAME_FIELD);
    }

    async refreshWarDetails() {
        const warTag = getFieldValue(this.clanWar, WAR_TAG_FIELD);
        this.isProcessing = true;
        if (warTag) {
            try {
                await syncClanWarLeagueWar({ warTag });
            } catch (error) {
                console.error(error);
                this.isProcessing = false;
                return;
            }
        } else {
            console.log('implement reg clan war refresh');
        }
        this.isProcessing = false;
    }

}