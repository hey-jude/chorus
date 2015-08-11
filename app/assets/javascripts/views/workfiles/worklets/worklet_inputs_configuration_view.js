chorus.views.WorkletInputsConfiguration = chorus.views.Base.extend({
    constructorName: "WorkletInputsConfigurationView",
    templateName: "worklets/worklet_inputs_configuration",

    events: {
        "click button.save_input_param": 'updateParameter',
        "click a.delete_input_param": 'deleteParameter',
        "click button.add_new_parameter": 'newParameter',
        "click button.save_all_parameters": 'saveParameters',
        "change input,textarea,select": 'updateParameter',
        "click a.add_parameter_option": 'addParameterOptionInput',
        "click a.delete_parameter_option": 'deleteParameterOptionInput'
    },

    setup: function() {
        // Containing worklet
        this.model = this.options.model;

        // Mapped variables (parameters)
        this.parameters = this.model.parameters();

        // The state of the parameter models; either current or not.
        this._hasUnsavedChanges = false;

        // Add save/fail listeners for each submodel
        _.each(this.parameters.models, function (v) {
            this.listenTo(v, "changed", this.paramChanged);
            this.listenTo(v, "saved", this.paramSaved);
            this.listenTo(v, "validationFailed", this.paramSaveFailed);
        }, this);
        this.subscribePageEvent('parameter:deleted', this.paramDeleted);

        // Alpine-passed workflow variables
        // this.workflowVariables = this.options.workflowVariables;
        this.workflowVariables = new chorus.models.WorkFlowVariables({
            workfile_id: this.model.get('workflowId')
        });
        this.workflowVariables.fetch();
        this.onceLoaded(this.workflowVariables, this.render);

        // Necessary because handlebars can't do if (v1 == v2) print("selected")
        // for v1,v2 dynamic without some helper like this.
        Handlebars.registerHelper("selectedIfMatch", function(value1, value2) {
            return (value1 === value2)? "selected" : "";
        });
    },

    postRender: function() {
        if (this.hasErrors()) {
            _.each(this.parameters.models, function(p,i) {
                if (_.keys(p.errors).length > 0) {
                    this.showParamErrors(p, i);
                }
            }, this);
        }
    },

    hasUnsavedChanges: function() {
        var saving = _.find(this.parameters.models, function (p) {
            return p._changing;
        });

        return this._hasUnsavedChanges || typeof(saving) !== 'undefined';
    },

    // Whether the form as a whole has a validation error.
    hasErrors: function() {
        var hasErrors = typeof(_.find(this.parameters.models, function(p) { return _.keys(p.errors).length > 0 || _.keys(p.serverErrors).length > 0; })) !== 'undefined';

        return hasErrors;
    },

    broadcastEditorState: function() {
        chorus.PageEvents.trigger("worklet:editor:state", {
            mode: "inputs",
            hasErrors: this.hasErrors(),
            unsaved: this.hasUnsavedChanges()
        });
    },

    showParamErrors: function(param, param_index) {
        _.each(param.errors, function(val, key) {
            var vName = _.underscored(key) + '_' + param_index;
            var $input = this.$("input[name=\"" + vName + "\"], form textarea[name=\"" + vName + "\"]");
            this.markInputAsInvalid($input, val, false);
        }, this);
    },

    clearParamErrors: function(param, param_index) {
        _.each(param.errors, function(val, key) {
            var vName = _.underscored(key) + '_' + param_index;
            var $input = this.$("input.has_error[name=\"" + vName + "\"], form textarea.has_error[name=\"" + vName + "\"]");
            $input.qtip("destroy");
            $input.removeData("qtip");
            $input.removeClass("has_error");
        }, this);
        param.errors = {};
    },

    updateParameter: function(e, model_index, perform_save) {
        e && e.preventDefault();

        // Below uses e.target.dataset.index to index model.
        // But if positional changes made, need to do something like this:
        // var param_info = this.workletParams[e.target.dataset.index];
        // var param_model = _.find(this.variables.models, function (v) {
        //     return v.get('id') == this;
        // }, param_info.id);
        var i = (typeof(model_index) !== 'number')? e.target.dataset.index : model_index;

        // Casts to more specific type if hasn't already been.
        if (this.parameters.models[i].get('dataType') && this.parameters.models[i].constructorName === "WorkletParameter") {
            this.parameters.models[i] = this.parameters.models[i].castByDataType();
        }

        var param_model = this.parameters.models[i];
        var updates = {
            variableName: $('select[name=variable_name_' + i + '] option:selected').val(),
            description: $('textarea[name=description_' + i + ']').val(),
            label: $('input[name=label_' + i + ']').val(),
            useDefault: $('input[name=use_default_' + i + ']')[0].checked,
            required: $('input[name=required_' + i + ']')[0].checked,
            dataType: $('select[name=data_type_' + i + '] option:selected').val()
        };

        // Select options:
        var opts_els = $('input[name^=option_][data-index=' + i + ']');
        if (opts_els.length > 0) {
            var options = _.map(opts_els, function(o) {
                return {
                    option: $(o).val(),
                    value: $('input[name=value_' + o.dataset.optionIndex + '_' + o.dataset.index + ']').val()
                };
            });
            updates.options = options;
        }

        // Validate and set the model on client side.
        this.clearParamErrors(param_model, i);
        param_model.set(updates);
        if (!param_model.performValidation(updates)) {
            this.showParamErrors(param_model, i);
            this.broadcastEditorState();
            return;
        }

        if (perform_save === true) {
            param_model.save(updates);
        }
        this.paramChanged();
    },

    paramChanged: function() {
        this._hasUnsavedChanges = true;
        this.broadcastEditorState();

        // Update preview pane
        this.model.parameters().trigger('update');

        this.render();
    },

    paramSaved: function() {
        this._hasUnsavedChanges = false;
        this.broadcastEditorState();

        // Update preview pane
        this.model.parameters().trigger('update');
    },

    paramSaveFailed: function(e,f,g) {
        this.broadcastEditorState();
        this.displayServerErrors();
    },

    deleteParameter: function(e) {
        e && e.preventDefault();
        //var p = this.workletParams()[e.currentTarget.dataset.index]
        var m = this.parameters.models[e.currentTarget.dataset.index];
        new chorus.alerts.WorkletParameterDeleteAlert({
            model: m,
            collection_index: e.currentTarget.dataset.index
        }).launchModal();
    },

    paramDeleted: function(param_options) {
        // Remove from collection
        this.model.parameters().remove(param_options.model);
        this.paramChanged();
    },

    newParameter: function(e) {
        e && e.preventDefault();

        var new_var = new chorus.models.WorkletParameter({
            workletId: this.model.id,
            workspaceId: this.model.workspace().id
        });
        this.listenTo(new_var, "saved", this.paramChanged);
        this.listenTo(new_var, "changed", this.paramChanged);
        this.listenTo(new_var, "validationFailed", this.paramSaveFailed);

        //new_var.save();
        this.parameters.add(new_var);
        this.paramChanged();
    },

    saveParameters: function(e) {
        e && e.preventDefault();

        this.clearErrors();
        _.each(this.model.parameters().models, function(param_model, index) {
            this.updateParameter(null, index, true);
        }, this);
    },


    addParameterOptionInput: function(e) {
        e && e.preventDefault();

        var m = this.parameters.models[e.currentTarget.dataset.index];
        var options = m.get('options') || [];

        options.push({
            option: '',
            value: ''
        });

        m.options = options;

        this.paramChanged();
    },

    deleteParameterOptionInput: function(e) {
        e && e.preventDefault();

        var m = this.parameters.models[e.currentTarget.dataset.index];
        var options = m.get('options');
        var del_at = e.currentTarget.dataset.optionIndex;

        if (!options || typeof(options[del_at]) === 'undefined') {
            return;
        }

        m.options = options.splice(del_at, 1);

        this.paramChanged();
    },

    workletParams: function() {
        // Becomes the representation given to the view.
        return _.map(this.parameters.models, function(v, i) {
            return _.extend(v.attributes, {
                hasOptions: v.get('dataType') === t('worklet.parameter.datatype.single_option_select') || v.get('dataType') === t('worklet.parameter.datatype.multiple_option_select'),
                useDefaultDisabled: (v.get('dataType') === t('worklet.parameter.datatype.single_option_select') || v.get('dataType') === t('worklet.parameter.datatype.multiple_option_select')),
                isCalendar: v.get('dataType') === t('worklet.parameter.datatype.datetime_calendar'),
                displayIndex: i,
                options: v.get('options') || []
            });
        });
    },

    additionalContext: function () {
        // TODO: Alpine includes some variables that are read-only.
        // This isn't the best place to do this filtering.
        var varMap = this.workflowVariables && this.workflowVariables.get('variableMap');
        var filteredVars = _.omit(varMap, chorus.WorkletConstants.OmittedWorkflowVariables);
        return {
            workflowVariables: _.map(filteredVars, function (value, prop) {
                return {
                    variableName: prop,
                    variableDefault: value
                };
            }),
            workletParams: this.workletParams(),
            dataTypes: chorus.WorkletConstants.DataTypes
        };
    }
});