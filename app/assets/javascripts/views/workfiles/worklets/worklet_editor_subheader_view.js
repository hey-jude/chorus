chorus.views.WorkletEditorSubheader = chorus.views.Base.extend({
    templateName: "worklets/worklet_editor_subheader",
    constructorName: "WorkletEditorSubheaderView",
    //additionalClass: "sub_nav",

    events: {
        "click a.workletSteps_item": 'clickedWorkletStepsItem'
    },

    clickedWorkletStepsItem: function(e) {
        e && e.preventDefault();

        chorus.PageEvents.trigger("submenu:worklet", e.target.dataset.mode);
    },

    setup: function() {
        this.subscribePageEvent("worklet:editor:state", this.editorStateUpdate);
    },

    editorStateUpdate: function(options) {
        var i = _.map(this.editorModes, function (e) { return e.mode; }).indexOf(options.mode);

        this.editorModes[i] = _.extend(this.editorModes[i], options);
        this.render();
    },

    editorModes: [
        { mode: 'workflow', label: t('worklet.edit_mode.workflow'), hasErrors: false, unsaved: false },
        { mode: 'details', label: t('worklet.edit_mode.details'), hasErrors: false, unsaved: false },
        { mode: 'outputs', label: t('worklet.edit_mode.outputs'), hasErrors: false, unsaved: false },
        { mode: 'inputs', label: t('worklet.edit_mode.inputs'), hasErrors: false, unsaved: false }
    ],

    additionalContext: function() {
        return {
            workletStepsItems: _.map(this.editorModes,
                function (edit_mode, mode_index) {
                    return {
                        class: (mode_index === this.current_mode_index)? 'current' : (mode_index < this.current_mode_index)? 'past' : 'future',
                        label: edit_mode.label,
                        edit_mode: edit_mode.mode,
                        unsaved: edit_mode.unsaved,
                        hasErrors: edit_mode.hasErrors
                    };
                },
                {
                    current_mode_index: _.map(this.editorModes, function(m) { return m.mode; }).indexOf(this.options.mode)
                }
            )
        };
    }
});