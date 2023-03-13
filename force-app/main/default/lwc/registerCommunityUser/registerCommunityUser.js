import { LightningElement, api, track } from 'lwc'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

import registerUser from '@salesforce/apex/RegisterCommunityUser.register';

import { 
    capitalize,
} from './helper';
//u2YsF219tfLbK%Uz4

export default class RegisterCommunityUser extends LightningElement {

    @api title
    @api startURL
    @api includePasswordField
    @api searchAddressFields
    @api editableAddressFields

    @track accountName = ''
    @track firstName = ''
    @track lastName = ''
    @track email = ''
    @track username = ''
    @track password = ''
    @track confirmPassword = ''

    @track error = false
    @track isLoading = false

    onkeyup( event ){
        //check for "enter" key
        if (event.keyCode === 13) {
            this.register()
        }
    }

    setValues( event ){
        
        const prop = event.target.name
        const value = event.target.value
        //console.log(prop)
        //console.log(value)
        this[prop] = value
    }
    
    async register(event){
        try {
            this.loading()
            
            console.log('register =>')

            const config = this.getConfig()
            // console.log(config)


            const result = await registerUser({config})

            // console.log({result})

            if (result.substring(0,5) === 'https'){

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
            regConfirmUrl: '',
            startUrl: '',
            includePassword: this.includePasswordField,
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

    validateUsername( event ){

        const userName = event.target.value
        
		const filter = /^\s*[\w\-\+_]+(\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(\.[\w\-\+_]+)*\s*$/;

		if(String(userName).search(filter) != -1){

            // this.username = email
            this.username = userName
        
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