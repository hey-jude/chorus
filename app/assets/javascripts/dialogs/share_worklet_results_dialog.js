chorus.dialogs.ShareWorkletResultsDialog = chorus.dialogs.PickWorkspace.extend({
    constructorName: "ShareWorkletResultsDialog",

    title: t("workfile.share_worklet_results_dialog.title"),
    submitButtonTranslationKey: "workfile.share_worklet_results_dialog.submit",

    setup: function() {
        this._super("setup", arguments);
        this.resultsId = this.options.resultsId;
        this.worklet = this.options.worklet;
        this.render();
    },

    submit: function() {
        var self = this;
        var params = {
            workspace_id: this.selectedItem().get("id"),
            results_id: this.resultsId
        };

        $.ajax({
            url: "/worklets/" + this.worklet.get("id") + "/share",
            type: "POST",
            dataType: "json",
            data: params,
            success: function(data) {
                self.closeModal(true);
                chorus.toast("worklet.share_success.toast", {workspaceName: data.response.workspace.name});
            },

            error: function(xhr) {
                var data = JSON.parse(xhr.responseText);
                self.resource.serverErrors = data.errors;
                self.showErrors();
            }
        });

    }
});