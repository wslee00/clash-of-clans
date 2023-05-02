import { getFieldValue, getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, wire } from 'lwc';
import CLAN_WAR_NAME_FIELD from '@salesforce/schema/ClanWar__c.Name';

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

    get clanWarName() {
        return getFieldValue(this.clanWar, CLAN_WAR_NAME_FIELD);
    }

}