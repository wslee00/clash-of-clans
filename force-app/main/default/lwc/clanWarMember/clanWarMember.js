import { LightningElement, api } from 'lwc';
import townHallImages from '@salesforce/resourceUrl/town_hall_images';

export default class ClanWarMember extends LightningElement {
    @api clanWarMember = {
        Name: undefined,
        Tag__c: undefined,
        OpponentAttacks__c: undefined,
        TownHallLevel__c: undefined,
    };

    get townHallUrl() {
        return `${townHallImages}/Town_Hall${this.clanWarMember.TownHallLevel__c}.webp`;
    }
}