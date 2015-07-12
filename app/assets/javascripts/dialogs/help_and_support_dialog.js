chorus.dialogs.HelpAndSupport = chorus.dialogs.Base.extend({
    constructorName: "HelpAndSupport",
    templateName: "dialogs/help_and_support",
    title: t("help.help_and_support.title"),
    events: {
        "submit form": "downloadLogs"
    },

    makeModel:function () {
        this._super("makeModel", arguments);
        this.model = new chorus.models.HelpAndSupport();
        //this.listenTo(this.model, "saved", this.saved);
    },

    downloadLogs: function() {
        this.model.downloadLogs();
    }
});
