import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/ClanWarMember__c.Id';
import NAME_FIELD from '@salesforce/schema/ClanWarMember__c.Name';
import OPPONENT_ATTACKS_FIELD from '@salesforce/schema/ClanWarMember__c.OpponentAttacks__c';
import TOWN_HALL_LEVEL_FIELD from '@salesforce/schema/ClanWarMember__c.TownHallLevel__c';

export default class ClanWarMemberContainer extends LightningElement {
    @api recordId;

    clanWarMember;

    @wire(getRecord, { recordId: '$recordId', fields: [ID_FIELD, NAME_FIELD, OPPONENT_ATTACKS_FIELD, TOWN_HALL_LEVEL_FIELD] })
    processGetRecord({ data, error }) {
        if (error) {
            console.error(error);
        }
        if (data) {
            this.clanWarMember = data;
        }
    }

    get clanWarMemberSimple() {
        const simplifiedObject = {};
        Object.keys(this.clanWarMember.fields).forEach((key) => {
            simplifiedObject[key] = this.clanWarMember.fields[key].value;
        });
        return simplifiedObject;
    }
}