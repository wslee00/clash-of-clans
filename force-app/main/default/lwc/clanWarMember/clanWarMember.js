import { LightningElement, api, wire } from 'lwc';
import townHallImages from '@salesforce/resourceUrl/town_hall_images';
import getAttacks from '@salesforce/apex/ClanWarMemberController.getAttacks';

export default class ClanWarMember extends LightningElement {
    @api clanWarMember = {
        Id: undefined,
        Name: undefined,
        Tag__c: undefined,
        OpponentAttacks__c: undefined,
        TownHallLevel__c: undefined,
    };

    attacks;

    @wire(getAttacks, { clanWarMemberId: '$clanWarMemberId' })
    processGetAttacks({ data, error }) {
        if (error) {
            console.error(error);
        }
        if (data) {
            this.attacks = data;
        }
    }

    get townHallUrl() {
        return `${townHallImages}/Town_Hall${this.clanWarMember.TownHallLevel__c}.webp`;
    }

    get clanWarMemberId() {
        return this.clanWarMember.Id;
    }

    get stars() {
        return this.attacks.reduce((total, attack) => {
            return attack.Stars__c + total
        }, 0);
    }

    get numAttacks() {
        return this.attacks.length;
    }
}