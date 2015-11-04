chorus.dialogs.AboutThisApp = chorus.dialogs.Base.extend ({

    templateName: "dialogs/about",
    title: t("about.dialog.title"),

    
    makeModel: function(options) {
        this.model = this.license = chorus.models.Config.instance().license();
    },

    setup: function(options) {
        this.requiredResources.add(this.model);
        this.model.fetch();
    },

    postRender: function() {
        this.$(".version").load("/VERSION", function(res) {
            $(this).text(res);
        });

    },

//     context: function() {
//         console.log ("context");
//         console.log ("> " + this.model.applicationKey());
//         
//         return _.extend({
//             items: this.items(),
//             applicationKey: "about." + this.model.applicationKey(),
//             
//             //branding: chorus.branding.applicationVendor,
//             //brandingLogoSrc: chorus.branding.applicationLoginLogo,
//             //copyright: chorus.branding.copyright,
//             
//         }, this.pageOptions);
//     },

    additionalContext: function() {

        return _.extend({
            items: this.items(),
            applicationKey: "about." + this.model.applicationKey(),
            
            //branding: chorus.branding.applicationVendor,
            //brandingLogoSrc: chorus.branding.applicationLoginLogo,
            //copyright: chorus.branding.copyright,
            
        }, this.pageOptions);
    },
    
    items: function() {
        var keys = [];
        var vendor = this.model.get("vendor");
        //var vendor = chorus.branding.applicationVendor;

        switch (vendor) {
            case "alpine":
                keys.splice(0, 0, "collaborators", "admins", "developers");
                break;
            case "pivotal":
                break;              
            case "openchorus":
                break;
            default:
                break;
        }
        
        if (vendor !== "openchorus") {
            keys.splice(0, 0, "expires");
        }

        return _.map(keys, function(key) {
            return {
                key: key,
                translationKey: "about." + key,
                value: this.model.get(key)
            };
        }, this);
    }

});
