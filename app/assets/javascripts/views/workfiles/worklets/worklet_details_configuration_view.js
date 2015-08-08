chorus.views.WorkletDetailsConfiguration = chorus.views.Base.extend({
    constructorName: "WorkletDetailsConfigurationView",
    templateName: "worklets/worklet_details_configuration",

    events: {
        "click button.update_details": 'updateDetails',
        "change input,textarea,select": 'updateDetails'
    },

    setup: function() {
        this.model = this.options.model;

        this._hasUnsavedChanges = false;
        this._hasErrors = false;

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
        return this._hasErrors || this.hasServerErrors();
    },

    hasServerErrors: function() {
        // Use jquery to test whether this view has an input matching the server error field
        if (!this.model.serverErrors) {
            return false;
        }

        var matching_fields = _.filter(this.model.serverErrors.fields, function(errors, field) {
            var bb_field = _.camelize(field);
            var find_field = this.$("input[name=\"" + bb_field + "\"], form textarea[name=\"" + bb_field + "\"]");
            return (find_field.length > 0);
        }, this);

        return matching_fields.length > 0;
    },

    broadcastEditorState: function() {
        chorus.PageEvents.trigger("worklet:editor:state", {
            mode: "details",
            hasErrors: this.hasErrors(),
            unsaved: this.hasUnsavedChanges()
        });
    },

    updateDetails: function(e, perform_save) {
        e && e.preventDefault();

        // Gather text attributes
        var updates = {};
        _.each(this.$("input[type=text], textarea"), function (i) {
            var input = $(i);
            var val = input.val().trim();
            updates[input.attr("name")] = val;
        });

        // Store changes into client side model, and run validation on the updates.
        this.model.set(updates, { silent: true });
        this._hasUnsavedChanges = true;
        this._hasErrors = false;
        this.model.serverErrors = {};
        this.clearErrors();
        this.broadcastEditorState();

        if (!this.model.performValidation(updates)) {
            this._hasErrors = true;
            this.broadcastEditorState();
            this.showErrors();
            return;
        }

        if (perform_save === true) {
            this.model.save(updates);
        }
    },

    workletSaved: function(e) {
        this._hasUnsavedChanges = false;
        this.broadcastEditorState();
    },

    workletSaveFailed: function(e) {
        if (this.hasServerErrors()) {
            this.displayServerErrors();
            this.broadcastEditorState();
        }
    },

    additionalContext: function () {
        return {
            // Worklet avatar
            avatarUrl: this.model.url({workflow_action: 'image'}),
            description: this.model.get('description')
        };
    }
});