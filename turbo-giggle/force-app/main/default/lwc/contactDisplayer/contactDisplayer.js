import { LightningElement,wire,track} from 'lwc';
import AccountSelected from '@salesforce/messageChannel/AccountSelected__c';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext} from 'lightning/messageService';

/* Contact Methods */
import getContactByAccountId from '@salesforce/apex/ContactSelector.getContactByAccountId';

export default class ContactDisplayer extends LightningElement {
  
    @wire(MessageContext)
    messageContext;

    contacts;
    loading;
    error;
    subscription = null;
    hasContacts = false;
    myAccountId = undefined;

    get HasContacts() {return this.hasContacts;}

    /* Message channel subscriber/unsubscriber and handlers */
    connectedCallback(){ console.log('connected');this.subscribeToMessageChannel();}
    disconnectedCallback(){ this.unsubscribeToMessageChannel();}
    handleMessage(message){
        //this.loadContacts(message.accountId);
        console.log('mesage ----->');
        this.myAccountId = message.accountId;
    }
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                AccountSelected,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }
    @wire(getContactByAccountId,{ accId: '$myAccountId'})
    wiredContact({error,data}) {
        if (data) {
            console.log('-----> LOADED CONTACTS');
            this.loading = false; 
            this.contacts = data;
            this.error = undefined;
            this.hasContacts = this.contacts.length > 0;
        } else if (error) {
            console.error('NO LOADED CONTACTS');
            console.error(error);
            this.loading = false; 
            this.error = error;
            this.hasContacts = false;
        }
    }
    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }
    loadContacts(accountId){
        
    }
}