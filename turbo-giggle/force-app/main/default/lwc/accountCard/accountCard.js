import { LightningElement,api } from 'lwc';

export default class AccountCard extends LightningElement {
    clicked;
    @api account;

    handleOnClick(event){
        this.clicked = true;
        this.dispatchEvent(new CustomEvent('accountclicked',{ detail: this.account.Id }));
    }
}