import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, wire } from 'lwc';
import CLAN_WAR_NAME_FIELD from '@salesforce/schema/ClanWar__c.Name';
import getWarDetails from '@salesforce/apex/ClanWarVersusViewController.getWarDetails';

export default class ClanWarVersusView extends LightningElement {
    @api recordId; // clan war id
    clanWar;

    @wire(getRecord, { recordId: '$recordId', fields: [CLAN_WAR_NAME_FIELD]})
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

}