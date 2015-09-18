chorus.alerts.WorkletParameterDeleteAlert = chorus.alerts.ModelDelete.extend({
    constructorName: "WorkletParameterDeleteAlert",

    ok: t("worklets.parameter.delete.ok"),
    title: t("worklets.parameter.delete.title"),
    text: t("worklets.parameter.delete.text"),
    deleteMessage: "worklets.parameter.delete.success",

    setup:function () {
        //this.title = t("workfile.delete.title", {workfileTitle:this.model.get("fileName")});
        //this.redirectUrl = this.model.workspace().workfilesUrl();
    },

    deleteMessageParams: function() {
        return {
            name: this.model.name()
        };
    },

    makeModel:function () {
        this.model = this.model || new chorus.models.WorkletParameter({});
    },

    modelDeleted: function() {
        this._super("modelDeleted");
        chorus.PageEvents.trigger("parameter:deleted", this.options);
    }
});