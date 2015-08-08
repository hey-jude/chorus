chorus.views.WorkletWorkflowConfiguration = chorus.views.Base.extend({
    constructorName: "WorkletWorkflowConfiguration",
    templateName: "worklets/worklet_workflow_configuration",

    //events: {
    //    "click button.update_workflow": 'updateWorkflow'
    //},

    setup: function() {
        this.model = this.options.model;

        this._hasUnsavedChanges = false;
        this._hasErrors = false;

        this.workflow = this.model.basisWorkflow();
        this.workflow.fetch();
        this.onceLoaded(this.workflow, this.render);

        this.listenTo(this.model, "saved", this.workletSaved);
        this.listenTo(this.model, "saveFailed", this.workletSaveFailed);
    },

    postRender: function() {
        if (this.hasErrors()) {
            this.showErrors();
        }
    },

    hasUnsavedChanges: function() {
        return this._hasUnsavedChanges;
    },

    hasErrors: function() {
        return this._hasErrors;
    },

    broadcastEditorState: function() {
        chorus.PageEvents.trigger("worklet:editor:state", {
            mode: "workflow",
            hasErrors: this.hasErrors(),
            unsaved: this.hasUnsavedChanges()
        });
    },

    updateWorkflow: function(e) {
        e && e.preventDefault();

        // Gather  attributes
        var updates = {};
        _.each(this.$("input[type=text], textarea"), function (i) {
            var input = $(i);
            var val = input.val().trim();
            updates[input.attr("name")] = val;
        });

        this.model.save(updates);
    },

    workletSaved: function(e) {
        this._hasUnsavedChanges = false;
    },

    workletSaveFailed: function(e) {
    },

    additionalContext: function () {
        return {
            workflow: this.workflow
        };
    }
});