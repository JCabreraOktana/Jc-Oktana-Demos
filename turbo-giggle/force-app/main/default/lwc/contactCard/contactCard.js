import { LightningElement,api } from 'lwc';

export default class AccountCard extends LightningElement {
    clicked;
    @api contact;

    handleOnClick(event){
        this.clicked = true;
        let element = this.template.querySelector('.slds-is-open');
        if (element) {
            if (element.classList.contains('slds-is-open')){
                element.classList.remove('slds-is-open');
            }else {
                element.classList.add('slds-is-open');
            }
        }
    }
}