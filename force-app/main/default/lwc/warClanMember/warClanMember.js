import { LightningElement, api } from 'lwc';
import townHallImages from '@salesforce/resourceUrl/town_hall_images';
export default class WarClanMember extends LightningElement {
    @api clanMember = {
        Town_Hall_Level__c: 12,
        Name: 'test',
        
    };

    get townHallUrl() {
        return `${townHallImages}/Town_Hall${this.clanMember.Town_Hall_Level__c}.webp`;
    }
}