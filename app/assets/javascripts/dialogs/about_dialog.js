chorus.dialogs.About= chorus.dialogs.Base.extend ({
    templateName: "dialogs/about",
    title: t("about.dialog.title"),

    
    makeModel: function(options) {
        console.log ("makemodel");
        console.log ("> " + this.model);
                console.log ("> " + this.options.model);
        console.log ("> " + this.license);
        
//         this.model = this.license = new chorus.models.License();
        this.model = new chorus.models.License();
    },

    setup: function() {
        this.requiredResources.add(this.model);
        this.model.fetch();
        
        console.log ("setup");
        console.log ("> " + this.model);
    },

    postRender: function() {
        this.$(".version").load("/VERSION", function(res) {
            $(this).text(res);
        });
        
        console.log ("postrender");
    },


    context: function() {
        console.log ("context");
        console.log ("> " + this.options);
        
        return _.extend({
            items: this.items(),
            applicationKey: "about." + this.model.applicationKey(),
            
            branding: chorus.branding.applicationVendor,
            brandingLogoSrc: chorus.branding.applicationLoginLogo,
            copyright: chorus.branding.copyright,
            
        }, this.pageOptions);
    },

    items: function() {
        var keys = [];
        var vendor = this.model.get("vendor");
        
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
