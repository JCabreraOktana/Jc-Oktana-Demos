import { LightningElement,wire } from 'lwc';

/* Messagging Methods */
import {publish, MessageContext} from 'lightning/messageService'
import AccountSelected from '@salesforce/messageChannel/AccountSelected__c';

/* Account Methods */
import getAllAccounts from '@salesforce/apex/AccountSelector.getAllAccounts';

import getContactByAccountId from '@salesforce/apex/ContactSelector.getContactByAccountId';

export default class AccContactContainer extends LightningElement {

    accounts;
    error;
    loading;
    @wire(MessageContext)
    messageContext;
    
    @wire(getAllAccounts)
    wiredAccount({ error, data }) {
        this.accounts = undefined;
        this.error = undefined;
        this.loading = true;
        if (data) {
            this.accounts = data;
            this.loading = false;
        } else if (error) {
            this.error = error;
            console.error(this.error);
            this.loading = false;
        }
    }

    handleAccountClicked(account){
        let message = {'accountId': account.detail };
        publish(this.messageContext, AccountSelected, message);
    }
}