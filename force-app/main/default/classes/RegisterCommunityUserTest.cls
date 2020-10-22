@isTest
public with sharing class RegisterCommunityUserTest {
    
    @isTest
    public static void isValidPassword_Test(){
        Boolean valid = RegisterCommunityUser.isValidPassword('kriug83', 'kriug83');
        System.debug(valid);
    }
    
    @isTest
    public static void siteAsContainerEnabled_Test(){
        String networkId = Network.getNetworkId();
        Boolean valid = RegisterCommunityUser.siteAsContainerEnabled(networkId);
        System.debug(valid);
    }
    
    @isTest
    public static void getPicklistValues_Test(){
        String valid = RegisterCommunityUser.getPicklistValues('Case', 'Status');
        System.debug(valid);
    }
    @isTest
    public static void validateEmailFormat_Test(){
        Boolean valid = RegisterCommunityUser.validateEmailFormat('me@example.com');
        Boolean notValid = RegisterCommunityUser.validateEmailFormat('meexample.com');
        System.debug(valid);
        System.debug(notValid);
    }
    
    
    @isTest
    public static void register_Test(){

    
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    
        User admin = new User(
            ProfileId = p.Id, 
            Alias = 'standt', 
            Email='tester@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Tester', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='tester@testorg.com'
        );
        //insert admin;
        

        //System.runAs(admin){
            String accountName = 'mr test';
            String firstname = 'test';
            String lastName = 'test';
            String email = 'test24142@test.com';
            String phone = '5555555555';
            String username = 'test41421@test.com';
            String password = '';
            String confirmPassword = '';
            String language = '';
            String regConfirmUrl = '';
            String startUrl = '';
            Boolean includePassword = false;
            
            
    
            RegisterCommunityUser.RegistrationConfig config = new RegisterCommunityUser.RegistrationConfig(
                accountName,
                firstname,
                lastName,
                email,
                phone,
                username,
                password,
                confirmPassword,
                language,
                regConfirmUrl,
                startUrl,
                includePassword
            );  
                
            System.debug(config);
            
            String result = RegisterCommunityUser.register( config );
            System.debug(result);

        	config.lastName = null;
            RegisterCommunityUser.register( config );
        
        	config.lastName = 'Test';
        	config.email = null;
            RegisterCommunityUser.register( config );

        	config.lastName = 'Test';
        	config.email = 'asdf.com';
            RegisterCommunityUser.register( config );
        
        	config.lastName = 'Test';
        	config.email = 'test@test.com';
        	config.username = '';
            RegisterCommunityUser.register( config );

            
        //}
    }
    
    @isTest
    public static void register_Test2(){

    
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    
        User admin = new User(
            ProfileId = p.Id,
            FirstName = 'Coastal',
            Alias = 'standt', 
            Email='tester@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Cloud', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='tester@testorg.com'
        );
        //insert admin;
        

        //System.runAs(admin){
            String accountName = 'mr test';
            String firstname = 'test';
            String lastName = 'test';
            String email = 'test312@test.com';
            String phone = '5555555555';
            String username = 'test421@test.com';
            String password = 'coastal12345';
            String confirmPassword = 'coastal12345';
            String language = '';
            String regConfirmUrl = '';
            String startUrl = '';
            Boolean includePassword = true;
            
            
    
            RegisterCommunityUser.RegistrationConfig config = new RegisterCommunityUser.RegistrationConfig(
                accountName,
                firstname,
                lastName,
                email,
                phone,
                username,
                password,
                confirmPassword,
                language,
                regConfirmUrl,
                startUrl,
                includePassword
            );  
                
            System.debug(config);
            
            String result = RegisterCommunityUser.register( config );
            System.debug(result);

        	config.lastName = null;
            RegisterCommunityUser.register( config );
        
        	config.lastName = 'Test';
        	config.email = null;
            RegisterCommunityUser.register( config );

        	config.lastName = 'Test';
        	config.email = 'asdf.com';
            RegisterCommunityUser.register( config );
        
        	config.lastName = 'Test';
        	config.email = 'test@test.com';
        	config.username = '';
            RegisterCommunityUser.register( config );

            
        //}
    }
    
    @isTest
    public static RegisterCommunityUser.RegistrationConfig RegistrationConfig_Test(){
        
        String accountName = 'mr test';
        String firstname = 'test';
        String lastName = 'test';
        String email = 'test12@test.com';
        String phone = '5555555555';
        String username = 'test12@test.com';
        String password = 'coastal1234';
        String confirmPassword = 'coastal1234';
        String language = '';
        String regConfirmUrl = '';
        String startUrl = '';
        Boolean includePassword = true;
        

        RegisterCommunityUser.RegistrationConfig config = new RegisterCommunityUser.RegistrationConfig(
            accountName,
            firstname,
            lastName,
            email,
            phone,
            username,
            password,
            confirmPassword,
            language,
            regConfirmUrl,
            startUrl,
            includePassword
        );
        
        return config;
    }
}