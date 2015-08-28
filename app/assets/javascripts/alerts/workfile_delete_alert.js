chorus.alerts.WorkfileDelete = chorus.alerts.ModelDelete.extend({
    constructorName: "WorkfileDelete",

    text: t("workfile.delete.text"),
    ok: t("workfile.delete.button"),
    deleteMessage: "workfile.delete.toast",
    deleteMessageParams: function() {
        return {
            name: this.model.name()
        };
    },

    makeModel:function () {
        this.model = this.model || new chorus.models.Workfile({
            id: this.options.workfileId,
            fileName: this.options.workfileName,
            workspace: {id: this.options.workspaceId}
        });
    },

    cancelAlert:function () {
        this.model.serverErrors = {};
        this._super("cancelAlert", arguments);
    },

    setup:function () {
        this.title = t("workfile.delete.title", {workfileTitle:this.model.get("fileName")});
        this.redirectUrl = this.model.workspace().workfilesUrl();
        if(this.model.get('fileType') === 'worklet') {
            this.deleteMessage = "worklet.delete.toast";
        }
    }
});
