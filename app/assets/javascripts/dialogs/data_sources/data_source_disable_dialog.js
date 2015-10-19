chorus.dialogs.DataSourceDisable = chorus.dialogs.Base.extend({
    constructorName: "DataSourceInvalid",
    templateName: "confirmation",
    title: t("data_sources.disable_dialog.title"),

    events: {
        "click button.submit": "disableDataSource",
        "click button.cancel": "close"
    },

    setup: function(options){
        this.model = options.model;
    },

    additionalContext: function(){
        return {
            text: t("data_sources.disable_dialog.text"),
            ok: t("data_sources.disable_dialog.disable"),
            cancel: t("data_sources.invalid_dialog.cancel"),
            dataSourceName: this.model.get("name")
        };
    },

    disableDataSource: function(e) {
        e.preventDefault();
        this.$("button.submit").startLoading("data_sources.edit_dialog.saving");

        this.model.set('state', 'disabled');

        this.model.save(this.model.attributes, {

            success: function(){
                chorus.toast("data_sources.state.disabled_success.toast", {dataSourceName: this.model.name(), toastOpts: {type:"info"}});
            }.bind(this),

            error: function() {
                chorus.toast("data_sources.state.disabled_error.toast", {dataSourceName: this.model.name(), toastOpts: {type:"success"}});
                this.model.set('state', 'enabled');
            }.bind(this)
        });

        this.closeModal();
    }

});
