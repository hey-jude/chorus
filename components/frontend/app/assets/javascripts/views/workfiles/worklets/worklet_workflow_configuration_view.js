chorus.views.WorkletWorkflowConfiguration = chorus.views.Base.extend({
    constructorName: "WorkletWorkflowConfiguration",
    templateName: "worklets/worklet_workflow_configuration",

    //events: {
    //    "click button.update_workflow": 'updateWorkflow'
    //},

    setup: function() {
        this.worklet = this.options.worklet;

        this._hasUnsavedChanges = false;
        this._hasErrors = false;

        this.workflow = this.worklet.basisWorkflow();
        this.workflow.fetch();
        this.onceLoaded(this.workflow, this.render);

        this.listenTo(this.worklet, "saved", this.workletSaved);
        this.listenTo(this.worklet, "saveFailed", this.workletSaveFailed);

        this.broadcastEditorState();
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

        this.worklet.save(updates);
    },

    workletSaved: function(e) {
        if (this.worklet.wasRunRelatedSave()) {
            return;
        }

        this._hasUnsavedChanges = false;
    },

    workletSaveFailed: function(e) {
    },

    additionalContext: function() {
        var hasComments = this.workflow.get('recentComments') && this.workflow.get('recentComments').length > 0;

        return {
            workflow: this.workflow.attributes,
            workflowIconUrl: this.workflow.iconUrl(),
            workflowWorkfileUrl: this.worklet.workspace().showUrl() + this.workflow.url(),
            //workflowEditUrl: this.workflow.workFlowShowUrl(),
            modifiedTime: new Date(this.workflow.get('userModifiedAt')).toString('MM-dd-yyyy HH:mm:ss'),
            hasComments: hasComments,
            lastComment: hasComments && this.workflow.get('recentComments')[0].body
        };
    }
});