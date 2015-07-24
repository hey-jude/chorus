chorus.views.WorkletInputsConfiguration = chorus.views.Base.extend({
    constructorName: "WorkletInputsConfigurationView",
    templateName: "worklet_inputs_configuration",

    events: {
        "click button.save_input_param": 'saveParameter',
        "click button.delete_input_param": 'deleteParameter',
        "click button.add_new_parameter": 'newParameter'
    },

    setup: function() {
        // Containing worklet
        this.model = this.options.model;

        // Preview pane
        this.previewPane = this.options.previewPane;

        // Alpine-passed workflow variables
        this.workflowVariables = this.options.workflowVariables;

        // Mapped variables (parameters)
        this.variables = this.model.variables();

        // Add save/fail listeners for each submodel
        _.each(this.variables.models, function (v) {
            this.model.listenTo(v, "saved", this.model.paramSaved);
            this.model.listenTo(v, "saveFailed", this.model.paramSaveFailed);
        }, { model: this });

        // Necessary because handlebars can't do if (v1 == v2) print("selected")
        // for v1,v2 dynamic without some helper like this.
        Handlebars.registerHelper("selectedIfMatch", function(value1, value2) {
            return (value1 === value2)? "selected" : "";
        });

        this.render();
    },

    workletParams: function() {
        // Becomes the representation given to the view.
        // Can rearrange by position here, and what not.
        return _.map(this.variables.models, function(v) {
            return v.attributes;
        });
    },

    saveParameter: function(e) {
        e && e.preventDefault();

        // Below uses e.target.dataset.index to index model.
        // But if positional changes made, need to do something like this:
        // var param_info = this.workletParams[e.target.dataset.index];
        // var param_model = _.find(this.variables.models, function (v) {
        //     return v.get('id') == this;
        // }, param_info.id);
        var i = e.target.dataset.index;
        var param_model = this.variables.models[i];

        var updates = {
            variable_name: $('select[name=variable_name_' + i + '] option:selected').val(),
            description: $('textarea[name=description_' + i + ']').val(),
            label: $('input[name=label_' + i + ']').val(),
            use_default: $('input[name=use_default_' + i + ']')[0].checked,
            required: $('input[name=required_' + i + ']')[0].checked,
            data_type: $('select[name=data_type_' + i + '] option:selected').val()
        };

        param_model.save(updates);
    },

    paramSaved: function(e) {
        // Update preview pane
        this.previewPane.variables = this.workletParams();
        this.previewPane.render();
    },

    paramSaveFailed: function(e) {
    },

    deleteParameter: function(e) {
        e && e.preventDefault();
        // var param = this.workletParams[e.target.dataset.index];
    },


    newParameter: function(e) {
        e && e.preventDefault();

        var new_var = new chorus.models.WorkletVariable({workletId: this.model.id, workspaceId: this.model.workspace().id});
        new_var.save();
        this.listenTo(new_var, "saved", this.paramSaved);
        this.listenTo(new_var, "saveFailed", this.paramSaveFailed);
        this.variables.add(new_var);

        this.render();
    },

    additionalContext: function () {
        // Alpine includes some variables that shouldn't be allowed as params.
        // TODO: This isn't the ideal place to do this filtering; it should probably happen
        // on alpine-side, or should be at least be performed in the backbone WorkflowVariable model.
        var filteredVars = _.omit(this.workflowVariables,
            ['@flowName', '@userName', '@defaultSchema',
             '@defaultPrefix', '@defaultTempdir',
             '@defaultDelimiter', '@pigNumberOfReducers']);

        return {
            workflowVariables: _.map(filteredVars, function (value, prop) {
                return {
                    variableName: prop,
                    variableDefault: value
                };
            }),

            workletParams: this.workletParams(),

            // Given in the spec:
            //dataTypes: [
            //    "Text",
            //    "Number",
            //    "Select Single Option",
            //    "Select Multiple Options",
            //    "Date/time - Calendar",
            //    "Date/time - Relative"
            //]
            dataTypes: [
                'string',
                'integer',
                'singleOption',
                'multipleOptions',
                'dateTimeCalendar',
                'dateTimeRelative'
            ]
        };
    }
});