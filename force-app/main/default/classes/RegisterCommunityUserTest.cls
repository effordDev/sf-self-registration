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
    
        String accountName = 'mr test';
        String firstname = 'test';
        String lastName = 'test';
        String email = 'test24142@test.com';
        String phone = '5555555555';
        String username = 'test41421@test.com';
        String password = 'TestPasswaord123!';
        String confirmPassword = 'TestPasswaord123!';
        String language = '';
        String profileName = 'Customer Community Login User';
        String ownerUsername = 'reidefford@gmail.com';

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
            profileName,
            ownerUsername
        );  
            
        System.debug(config);

        RegisterCommunityUser.register( config );
    }
}