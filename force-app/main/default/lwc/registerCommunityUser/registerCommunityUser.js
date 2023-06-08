import { LightningElement, api, track } from 'lwc'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

import registerUser from '@salesforce/apex/RegisterCommunityUser.register';

import { 
    capitalize,
} from './helper';

export default class RegisterCommunityUser extends LightningElement {

    @api ownerUsername
    @api profileName
    @api title
    @api usernamePostFix

    accountName = ''
    firstName = ''
    lastName = ''
    email = ''
    
    password = ''
    confirmPassword = ''

    error = false
    isLoading = false

    get username() {
        return `${this.email}.${this.usernamePostFix}`
    }
    get passwordIsValidLength() {
        return this.password.length >= 8
    }
    get confirmPasswordIcon() {
        return this.password === this.confirmPassword  && this.passwordIsValidLength ? 'utility:check' : 'utility:error'
    }
    get confirmPasswordIconVariant() {
        return this.password === this.confirmPassword && this.passwordIsValidLength ? 'success' : 'error'
    }

    onkeyup( event ){
        //check for "enter" key
        if (event.keyCode === 13) {
            this.register()
        }
    }

    setValues( event ){
        
        const prop = event.target.name
        const value = event.target.value

        this[prop] = value
    }
    
    async register(event){

        const allValid = [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        if (!allValid) {
            return
        }

        this.loading()
        
        console.log('register =>')

        const config = this.getConfig()
        // console.log(config)

        try {

            const result = await registerUser({config})

            // console.log({result})

            if(result.substring(0,5) === 'https'){

                this.error = false
                window.location.href = result

            } else {

                console.log('thrrow error')
                this.error = result

            }
        } catch (error) {
            console.log(error)
        } finally {
            this.loading()
        }
    }


    getConfig(){
        return { 
            accountName: this.accountName,
            firstName: this.firstName,
            lastName: this.lastName,
            email: this.email,
            phone: this.phone,
            username: this.username,
            password: this.password,
            confirmPassword: this.confirmPassword,
            language: '',
            profileName: this.profileName,
            ownerUsername: this.ownerUsername
        }
    }


    validateEmail( event ){

        const email = event.target.value
        
		const filter = /^\s*[\w\-\+_]+(\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(\.[\w\-\+_]+)*\s*$/;

		if(String(email).search(filter) != -1){

            // this.username = email
            this.email = email
        
		} else {
            this.toast(
                `Must be in 'example@example.com' format`,
                'error'
            )
        }
    }

    loading() {
        this.isLoading = this.isLoading ? false : true    
    }
}