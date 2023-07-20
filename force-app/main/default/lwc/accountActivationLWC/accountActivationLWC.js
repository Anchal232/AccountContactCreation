import { LightningElement, track, api } from 'lwc';
import userHasAccountManagerPS from '@salesforce/customPermission/Account_Manager_CP';
import activateAccount from '@salesforce/apex/ActivateAccountClass.activateAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountActivationLWC extends LightningElement {
    @api recordId;
    @track isAccountManager = false;

    connectedCallback(){
        this.isAccountManager = userHasAccountManagerPS;
    }

    handleClick(){
        activateAccount({recordId: this.recordId})
        .then((result)=>{
            if(result.contains('Activation_Summary__c')){
                this.toastEvent('Error!', 'Activation Summary Required', 'Error');
            }
            else{
                this.toastEvent('Success!', 'Successfully Activated Account', 'Success');
            }
        })
        .catch(
            this.toastEvent('Error!', 'Something went wrong', 'Error')
        )

    }

    toastEvent(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({title: title,message: message, variant: variant}));
    }
}