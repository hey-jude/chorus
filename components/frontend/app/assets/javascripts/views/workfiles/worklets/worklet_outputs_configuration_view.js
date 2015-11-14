chorus.views.WorkletOutputsConfiguration = chorus.views.Base.extend({
    constructorName: "WorkletOutputsConfigurationView",
    templateName: "worklets/worklet_outputs_configuration",

    events: {
        "click a.visual_operator": 'workflowImageOperatorClicked',
        "click input.checkbox_operator": 'includeOperatorClicked',
        "click button.update_details": 'updateDetails',
        "change input,textarea,select": 'updateDetails'
    },

    setup: function() {
        this.worklet = this.options.worklet;

        this._hasUnsavedChanges = false;
        this._hasErrors = false;

        this.workflowOperators = new chorus.models.WorkFlowOperators({ workfile_id: this.worklet.get('workflowId') });
        this.workflowOperators.fetch();
        this.onceLoaded(this.workflowOperators, this.render);

        this.listenTo(this.worklet, "saved", this.workletSaved);
        this.listenTo(this.worklet, "saveFailed", this.workletSaveFailed);

        this.broadcastEditorState();
    },

    hasUnsavedChanges: function(broadcast) {
        if (broadcast) {
            chorus.PageEvents.trigger("worklet:editor:unsaved", { mode: "outputs", unsaved: this._hasUnsavedChanges });
        }

        return this._hasUnsavedChanges;
    },

    hasErrors: function() {
        return this._hasErrors;
    },

    broadcastEditorState: function() {
        chorus.PageEvents.trigger("worklet:editor:state", {
            mode: "outputs",
            hasErrors: this.hasErrors(),
            unsaved: this.hasUnsavedChanges()
        });
    },

    postRender: function() {
        // Adjusts workflow canvas so that the top or left-most operator is within view
        var icon_size = 50;
        var wfi = $('#workfile_image_container');

        if (typeof(wfi) !== 'undefined') {
            var leftTop = _.reduce(this.workflowOperators.getOperators(), function(bound, op) {
                    (op.position.startX < bound.x) && (bound.x = op.position.startX);
                    (op.position.startY < bound.y) && (bound.y = op.position.startY);

                    return bound;
                }, {
                    x: Infinity,
                    y: Infinity
                }
            );

            wfi.scrollTop(leftTop.y - icon_size);
            wfi.scrollLeft(leftTop.x - icon_size);
        }

        if (this.hasErrors()) {
            this.showErrors();
        }
    },

    workflowImageOperatorClicked: function(e) {
        e && e.preventDefault();

        var op = this.workflowOperators.getOperators()[e.target.dataset.index];
        op.selected = typeof(op.selected) === 'undefined' ? true : !op.selected;
        
        // map to the other operator marker that is under the image= 'bottom'
        var bottom_checkbox_op = $('#' + e.target.id + 'B');
        bottom_checkbox_op.toggleClass("marked");

        // Also update checkbox 
        var checkbox_op = $('#op_' + e.target.dataset.index + '_checkbox');
        checkbox_op && checkbox_op.prop('checked', !checkbox_op.prop('checked'));

        // Update model
        this.updateDetails();
    },

    includeOperatorClicked: function(e) {
        var op = this.workflowOperators.getOperators()[e.currentTarget.dataset.index];
        op.selected = typeof(op.selected) === 'undefined' ? true : !op.selected;

        // Also update visualization
        var bottom_checkbox_op = $('#op_' + e.currentTarget.dataset.index + 'B');
        bottom_checkbox_op && bottom_checkbox_op.toggleClass("marked");
    },

    updateDetails: function(e, perform_save) {
        e && e.preventDefault();

        var updates = {};

        // Gather the checked output operators into updates['output_operators'] array
        var checked_ops = _.filter($('.checkbox_operator'), function(el) { return el.checked; });
        var all_ops = this.workflowOperators.getOperators();
        updates['outputTable'] = _.map(checked_ops, function (el) {
            return this.ops[el.dataset.index].name;
        }, {
            ops: all_ops
        });

        // Gather "Run as" persona from radio box
        var run_persona = $("input:radio[name = 'run_persona']:checked").val();
        if (typeof(run_persona) === 'undefined') {
            // Uses first persona if one isn't defined.
            run_persona = $($("input:radio[name = 'run_persona']")[0]).val();
        }
        updates['runPersona'] = run_persona;

        // Store changes into client side model, and run validation on the updates
        this.worklet.set(updates, { silent: true });

        this._hasUnsavedChanges = true;
        this._hasErrors = false;
        this.clearErrors();
        this.broadcastEditorState();

        if (!this.worklet.performValidation(updates)) {
            this._hasErrors = true;
            this.showErrors();
            this.broadcastEditorState();
            return;
        }

        if (perform_save === true) {
            this.worklet.save(updates);
        }
    },

    workletSaved: function(e) {
        if (this.worklet.wasRunRelatedSave()) {
            return;
        }

        this._hasUnsavedChanges = false;
        this.broadcastEditorState();
    },

    workletSaveFailed: function(e) {
        this.displayServerErrors();
        this.broadcastEditorState();
    },

    annotatedOperators: function() {
        var icon_size = 50;
        var icon_offset = 6;  // offset to adjust for the border/marker sizes. dependent on the css
        var output_table = this.worklet.get('outputTable');

        return _.map(this.workflowOperators.getOperators(), function (op, index) {
                return {
                    id: "op_" + index,
                    name: op.name,
                    index: index,
                    left: (op.position.startX - this.icon_size/2),
                    top: (op.position.startY - this.icon_size/2),
                    bg_left: (op.position.startX - this.icon_size/2) - icon_offset,
                    bg_top: (op.position.startY - this.icon_size/2) - icon_offset,
                    selected: _.contains(this.output_table, op.name)
                };
            }, {
                icon_size: icon_size,
                output_table: output_table
            }
        );
    },

    additionalContext: function () {
        var run_persona = this.worklet.get('runPersona');
        return {
            // View details for "Run as" options
            runPersonas: [
                {
                    run_persona: "creator",
                    persona_run_statement: t("worklet.configure.settings.run_as.creator"),
                    selected: !run_persona || run_persona === "creator"
                },
                {
                    run_persona: "person_running",
                    persona_run_statement: t("worklet.configure.settings.run_as.user"),
                    selected: run_persona === "person_running"
                }
            ],

            // Workflow image URL
            workflowImageUrl: this.worklet.basisWorkflow().imageUrl(),

            // View details for the operators to select as outputs
            operators: this.annotatedOperators()
        };
    }
});