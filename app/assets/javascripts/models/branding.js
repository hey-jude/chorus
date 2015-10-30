// common app-wide resource for branding logos

chorus.models.Branding = chorus.models.Base.extend ({
    constructorName: "Branding",
    urlTemplate:"branding/",



    license: function() {
        if (!this._license) {
            this._license = new chorus.models.License(this.get("license"));
        }

        return this._license;
    },

    clear: function() {
        this._super("clear", arguments);
        delete this._license;
    }
}, {
    instance: function () {
        if (!this._instance) {
            this._instance = new chorus.models.Config();
        }

        return this._instance;
    }
});
