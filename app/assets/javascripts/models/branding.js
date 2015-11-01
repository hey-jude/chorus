// common app-wide singleton resource for branding of the app

// VENDOR_ALPINE = 'alpine'
// VENDOR_PIVOTAL = 'pivotal'
        
chorus.models.Branding = chorus.models.Base.extend ({
    constructorName: "Branding",
    urlTemplate: "branding/",

    brandingLogoLocation: "/images/branding/",


//  what needs to be set?
//             helpLinkUrl: 'help.link_address.' + license.branding(),
//             brandingVendor: branding.brandingVendor,
//             brandingLogoSrc: branding.brandingLogo,
//             advisorNow: license.advisorNowEnabled(),
//             advisorNowLink: this.advisorNowLink(user, license)
            
//          var user = this.session.user();
//         var license = chorus.models.Config.instance().license();

    initialize: function () {
    
        console.log ("chorus.models.Branding initialize");
        console.log ("chorus.models.Branding user: " + chorus.session.user() );
        
        this.applicationLicense = chorus.models.Config.instance().license();
        
        this.applicationVendor = this.getBrandingVendor();
        this.applicationHeaderLogo = this.getBrandingLogo();
        
        // if (this.isAdvisorNowEnabled) this.advisorNowLink = this.getAdvisorNowLink( chorus.session.user(), this.applicationLicense);

        this.applicationHelpLink = this.getHelpLink();
        

    },
      
   getBrandingVendor: function() {
        // get vendor
        return this.applicationLicense.branding();
    },


   getBrandingLogo: function() {
   
        console.log ("models.branding > getBrandingLogo");
        // generate reference to the branding logo
        
        var brandingLogo;
        // var brandingLogoLocation = "/images/branding/";
        var vendor = this.getBrandingVendor;
        
        switch (vendor) {
            case "alpine":
                brandingLogo = "alpine-logo-header.svg";
                break;
            
            case "pivotal":
                brandingLogo = "pivotal-logo-header.png";
                break;
 
            case "openchorus":
                brandingLogo = "alpine-logo-header.svg";
                break;
                             
            default:
                brandingLogo = "alpine-logo-header.svg";
                break;
        }
        
        brandingLogo = this.brandingLogoLocation + brandingLogo;
        return brandingLogo;
    },

    generateLoginBrandingLogo: function() {
        // generate reference to the branding logo on login screen
  
        var loginBrandingLogo;
        // var brandingLogoLocation = "images/branding/";
        var vendor = this.getBrandingVendor;
        
        switch (vendor) {
            case "alpine":
                brandingLogo = "alpine-logo-login.svg";
                break;
            
            case "pivotal":
                brandingLogo = "pivotal-logo-login.png";
                break;

            case "openchorus":
                brandingLogo = "alpine-logo-header.svg";
                break;

            default:
                brandingLogo = "alpine-logo-login.svg";
                break;
        }
        
        brandingLogo = this.brandingLogoLocation + loginBrandingLogo;
        return loginBrandingLogo;
    },


    isAdvisorNowEnabled: function () { 
        return applicationLicense.advisorNowEnabled();
    },

    getAdvisorNowLink: function(user, license) {

        console.log ("models.branding > advisorNowLink");
        console.log ("user > " + user);

        return URI({
            hostname: "http://advisor.alpinenow.com",
            path: "start",
            query: $.param({
                first_name: user.get("firstName"),
                last_name: user.get("lastName"),
                email: user.get("email"),
                org_id: license.get("organizationUuid")
            })
        });
    },

    getHelpLink: function() {
        // pull the base help link from the messages properties file...?
        return ( "help.link_address." + this.applicationVendor);
    }
    

}, {
    // singleton
    instance: function () {
        if (!this._instance) {
            this._instance = new chorus.models.Branding();
        }
        
        console.log ("instance models.Branding");
        return this._instance;
    }
});
