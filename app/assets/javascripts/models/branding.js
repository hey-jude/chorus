// common app-wide singleton resource for branding of the app

// VENDOR_ALPINE = 'alpine'
// VENDOR_PIVOTAL = 'pivotal'
        
chorus.models.Branding = chorus.models.Base.extend ({
    constructorName: "Branding",
    urlTemplate: "branding/",

    brandingLogoLocation: "/images/branding/",

    initialize: function () {

        //console.log ("chorus.models.Branding user: " + chorus.session.user() );
        
        // setup a collection of values

        this.applicationLicense = chorus.models.Config.instance().license();

        this.applicationVersion = this.applicationLicense.applicationVersion();

        this.applicationVendor = this.getBrandingVendor();
        this.isAlpine = this.isAlpine();
        this.applicationHeaderLogo = this.getBrandingLogo();
        this.applicationLoginLogo = this.getBrandingLoginLogo();

        this.applicationAdvisorNowEnabled = this.isAdvisorNowEnabled();
        this.advisorNowLink = "";
        
        if (this.isAdvisorNowEnabled) {
            this.advisorNowLink = this.getAdvisorNowLink( chorus.session.user(), this.applicationLicense);
        }

        this.applicationHelpLink = this.getHelpLink();
        this.copyright = this.getCopyright();
    },

    setApplicationVersion: function (r) {
        this.applicationVersion = r;
    },

    getApplicationVersion: function() {
        // 11.2015 this is the old mechanism for getting the application version via ajax call
        // but now the version is tacked on to the chorus license model (ruby)
        that = this;
        $.ajax({
              url: "/VERSION",
              dataType: "text"
          })
          .success (function(response) {
              that.applicationVersion = response;
          });
    },

    getBrandingVendor: function() {
        // get vendor
        return this.applicationLicense.branding();
    },

    isAlpine: function() {
        if (this.getBrandingVendor() === "alpine") {
            return true;
        }
        else {
            return false;
        };
    },
    
    getBrandingLogo: function() {
        // generate path to the branding logo
        
        var logoFile;
        var vendor = this.getBrandingVendor();
        
        switch (vendor) {
            case "alpine":
                logoFile = "alpine-logo-header.svg";
                break;
            
            case "pivotal":
                logoFile = "pivotal-logo-header.png";
                break;
 
            case "openchorus":
                logoFile = null;
                break;
                             
            default:
                logoFile = "alpine-logo-header.svg";
                break;
        }
        
        // if no logofile is defined, then return = null
        brandingLogo = ( logoFile ? this.brandingLogoLocation + logoFile : null );
        return brandingLogo;
    },

    getBrandingLoginLogo: function() {
        // generate path to the branding logo for LOGIN page
            
        var logoFile;
        var vendor = this.getBrandingVendor();
        
        switch (vendor) {
            case "alpine":
                logoFile = "alpine-logo-login.svg";
                break;
            
            case "pivotal":
                logoFile = "pivotal-logo-login.png";
                break;

            case "openchorus":
                logoFile = null;
                break;

            default:
                logoFile = "alpine-logo-login.svg";
                break;
        }
        
        loginBrandingLogo = ( logoFile ? this.brandingLogoLocation + logoFile : null );
        return loginBrandingLogo;
    },

    isAdvisorNowEnabled: function () { 
        return this.applicationLicense.advisorNowEnabled();
    },

    getAdvisorNowLink: function(user, license) {
         return URI({
            protocol: "http",
            hostname: "advisor.alpinenow.com",
            path: "start",
            query: $.param({
                //first_name: user.get("firstName"),
                first_name: "lamont",
                //last_name: user.get("lastName"),
                last_name: "cranston",
                //email: user.get("email"),
                email: "address@gmail.com",
                org_id: license.get("organizationUuid")
            })
        });
    },

    createAdvisorNowLink: function(user, license) {

        console.log ("models.branding > CREATE advisorNowLink");
        console.log ("user > " + user);

//          return URI({
//             hostname: "http://advisor.alpinenow.com",
//             path: "start",
//             query: $.param({
//                 first_name: user.get("firstName"),
//                 last_name: user.get("lastName"),
//                 email: user.get("email"),
//                 org_id: license.get("organizationUuid")
//             })
//         });

          return URI({
          
         
          });

    },
    
    getHelpLink: function() {
        // default to the alpine help if no vendor listed
        var vendor = ( this.applicationVendor ? this.applicationVendor : "alpine" );
        return ( "help.link_address." + vendor);
    },

    getCopyright: function() {
        // construct the copyright notice used here and there.
        // default to the alpine copyright notice if no vendor listed
        var vendor = ( this.applicationVendor ? this.applicationVendor : "alpine" );
        return ( t("login." + vendor + "_copyright", {year:moment().year()}) );
    }

}, {
    // singleton
    instance: function () {
        if (!this._instance) {
            this._instance = new chorus.models.Branding();
        }

        return this._instance;
    }
});
