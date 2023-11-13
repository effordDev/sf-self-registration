public without sharing class RegisterCommunityUser {
    

    // if need to know community or not
    //System.debug(URL.getSalesforceBaseUrl().toExternalForm());

    public static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }
    
    public static boolean siteAsContainerEnabled(Id networkId) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
    
    @AuraEnabled(cacheable=true)
    public static String getPicklistValues(String objectName, String fieldName){

        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap();
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        JSONGenerator json = JSON.createGenerator(true);
        json.writeStartArray();
 
        for( Schema.PicklistEntry pl : ple){
            json.writeString( pl.getValue() );
        }

        json.writeEndArray();
        return json.getAsString();
    }

    
    @AuraEnabled(Cacheable=false)
    public static String register(RegistrationConfig config){

        if(!RegisterCommunityUser.validateEmailFormat(config.email)){
            return 'Invalid email address. Valid email can contain only contain letters and number.  Email address must contain @ and .';
        }
        
        if(!RegisterCommunityUser.validateUserNameNotDuplicate(config.username)){
            return 'Username already exists.  Please choose a different username';
        }

        if(config.password == config.username.substring(0, config.username.lastIndexOf('@'))) {
            return 'Password cannot equal Username.';
        }
        
        Savepoint sp = Database.setSavepoint();

        try {

            User owner = Test.isRunningTest() ? [
                SELECT Id 
                FROM User 
                WHERE Profile.Name = 'System Administrator'
                AND UserRoleId != null
                AND IsActive = true
                LIMIT 1
            ] : [
                SELECT Id 
                FROM User 
                WHERE Username = : config.ownerUsername
                LIMIT 1
            ];

            Profile communityProfile = [
                SELECT Id, Name 
                FROM Profile 
                WHERE Name = : config.profileName 
                LIMIT 1
            ];

            System.debug( config );
            
            Account a = new Account(
                Name = config.accountName,
                OwnerId = owner.Id
            );

            insert a;
            System.debug( a );
            
            Contact c = new Contact();
                c.FirstName = config.firstName;
                c.LastName = config.lastName;
                c.Phone = config.phone;
                c.MobilePhone = config.phone;
                c.Email = config.email;
                c.AccountId = a.Id;
                c.OwnerId = owner.Id;
            insert c;
            

            User u = new User();
                u.Email = config.email;
                u.FirstName = config.firstName;
                u.LastName = config.lastName;
                u.Username = config.username;
                u.MobilePhone =  config.phone;
                
                u.ContactId =  c.Id;

                u.TimeZoneSidKey = 'America/New_York'; // Required
                u.LocaleSidKey = 'en_US'; // Required
                u.EmailEncodingKey = 'ISO-8859-1'; // Required
                u.LanguageLocaleKey = 'en_US'; // Required
                u.ProfileId = communityProfile.Id;


            String nickname = ((config.firstName != null && config.firstName.length() > 0) ? config.firstName.substring(0,1) : '' ) + config.lastName.substring(0,1);
                
            nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
                
            u.put('CommunityNickname', nickname);
                
            u.Alias = nickname;

            if (!Test.isRunningTest()) {
                Site.validatePassword(u, config.password, config.confirmPassword);
            }

            String networkId = Network.getNetworkId();

            // If using site to host the community the user should not hit s1 after logging in from mobile.
            if (networkId != null && RegisterCommunityUser.siteAsContainerEnabled(networkId)) {
                u.put('UserPreferencesHideS1BrowserUI', true);
            }

            String userId = Site.createExternalUser(u, a.id, config.password);

            if (config.password != null && config.password.length() > 1) {
                
                ApexPages.PageReference lgn = Site.login(u.Username, config.password, '');
                return lgn.getUrl();
            } else {
                PageReference page = System.Page.SiteRegisterConfirm;
                page.setRedirect(true);
                return page.getUrl();
            }
        } catch (Exception ex){
            Database.rollBack(sp);
            return ex.getMessage();
        }
    }
    
    @TestVisible
    private static Boolean validateEmailFormat(String email) {
        Boolean res = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        if (!MyMatcher.matches())
            res = false;
        return res;
    }
    @TestVisible
    private static Boolean validateUsernameNotDuplicate(String username){
        List<User> userList = [SELECT Id, Name FROM User WHERE Username = :username];
        return userList.size() == 0;
    }


    public class RegistrationConfig {
        @AuraEnabled 
        public String accountName{get;set;}
        @AuraEnabled 
        public String firstname {get;set;}
        @AuraEnabled 
        public String lastName {get;set;}
        @AuraEnabled 
        public String email {get;set;}
        @AuraEnabled 
        public String phone {get;set;}
        @AuraEnabled 
        public String username {get;set;}
        @AuraEnabled 
        public String password {get;set;}
        @AuraEnabled 
        public String confirmPassword {get;set;}
        @AuraEnabled 
        public String language {get;set;}
        @AuraEnabled 
        public String profileName {get;set;}
        @AuraEnabled 
        public String ownerUsername {get;set;}

        public RegistrationConfig(){}
        
        public RegistrationConfig(
            String p_accountName,
            String p_firstname,
            String p_lastName,
            String p_email,
            String p_phone,
            String p_username,
            String p_password,
            String p_confirmPassword,
            String p_language,
            String p_profileName,
            String p_ownerUsername
        ) {
            accountName = p_accountName;
            firstname = p_firstname;
            lastName = p_lastName;
            email = p_email;
            phone = p_phone;
            username = p_username;
            password = p_password;
            confirmPassword = p_confirmPassword;
            language = p_language;
            profileName = p_profileName;
            ownerUsername = p_ownerUsername;
        }
    }
}