chorus.dialogs.DataSourceInvalid = chorus.dialogs.Base.extend({
    constructorName: "DataSourceInvalid",
    templateName: "confirmation",
    title: "Data Source Invalid",

    events: {
        "click button.submit": "createDataSource",
        "click button.cancel": "close"
    },

    setup: function(options){
        this.model = options.model;
        this.listenTo(this.model, "saved", this.saveSuccess);
    },

    additionalContext: function(){
        return {
            title: this.title,
            text: t("data_sources.invalid_dialog.text"),
            ok: t("data_sources.invalid_dialog.save"),
            cancel: t("data_sources.invalid_dialog.cancel")
        };
    },

    createDataSource: function(e) {
        e.preventDefault();
        this.model.set({state: "incomplete"});
        this.model.urlParams = { incomplete: "true" };
        this.model.save({silent: true});
        this.$("button.submit").startLoading("data_sources.edit_dialog.saving");
    },

    saveSuccess: function() {
        this.closeModal();
    }
});
