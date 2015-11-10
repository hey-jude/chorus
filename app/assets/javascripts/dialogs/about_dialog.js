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

    additionalContext: function() {

        return _.extend({
            items: this.items(),
            applicationKey: "about." + this.model.applicationKey(),
            //version: chorus.branding.applicationVersion,
            branding: chorus.branding.applicationVendor,
            brandingLogo: chorus.branding.applicationLoginLogo,
            copyright: chorus.branding.copyright,
            
        }, this.pageOptions);
    },
    
    items: function() {
        var keys = [];
        //var vendor = this.model.get("vendor");
        var vendor = chorus.branding.applicationVendor;

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
