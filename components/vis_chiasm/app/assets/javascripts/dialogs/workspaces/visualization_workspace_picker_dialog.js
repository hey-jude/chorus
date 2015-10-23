// TODO Curran / Mike Souza to do: this is currently busted, there's no place in the UI for saving the visualization to
// a workspace.  We need to wire this back up or delete ...

chorus.dialogs.VisualizationWorkspacePicker = chorus.dialogs.PickWorkspace.extend({
    constructorName: "VisualizationWorkspacePicker",

    title: t("visualization.workspace_picker.title"),
    submitButtonTranslationKey: "visualization.workspace_picker.button",

    makeModel: function() {
        this.options = this.options || {};
        this.options.activeOnly = true;
        this._super("makeModel", arguments);
    },

    submit : function() {
        this.trigger("workspace:selected", this.selectedItem());
        this.closeModal();
    }
});
