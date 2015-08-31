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
        this.worklet = this.options.worklet;

        // Mapped variables (parameters)
        this.parameters = this.worklet.parameters();

        // The state of the parameter models; either current or not.
        this._hasUnsavedChanges = false;

        // Add save/fail listeners for each submodel
        _.each(this.parameters.models, function (v) {
            this.listenTo(v, "changed", this.paramChanged);
            this.listenTo(v, "saved", this.paramSaved);
            this.listenTo(v, "validationFailed", this.paramSaveFailed);
        }, this);
        this.subscribePageEvent('parameter:scrollTo', this.scrollToParameter);
        this.subscribePageEvent('parameter:deleted', this.paramDeleted);

        // Necessary because handlebars can't do if (v1 == v2) print("selected")
        // for v1,v2 dynamic without some helper like this.
        Handlebars.registerHelper("selectedIfMatch", function(value1, value2) {
            return (value1 === value2)? "selected" : "";
        });

        // Alpine-passed workflow variables
        this.worklet.fetchWorkflowVariables();
        this.subscribePageEvent('worklet:workflow_variables_loaded', this.workflowVariablesLoaded);

        this.broadcastEditorState();
    },

    workflowVariablesLoaded: function(workflowVariables) {
        if (_.isEmpty(this.workflowVariables) && !_.isEmpty(workflowVariables)) {
            this.workflowVariables = workflowVariables;
            this.render();
        }
    },

    scrollToParameter: function(param_model) {
        var param_ind = _.map(this.parameters.models, function(m) {
            return _.where(m, this.attributes).length > 0;
        }, param_model).indexOf(true);

        var target = 'div.worklet_parameter_module[data-index="' + param_ind + '"]';
        var offset_div = $('#sub_nav');

        $('body').scrollTo(target, { offsetTop: offset_div.offset().top + offset_div.height() });
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
        var other_errors = [];
        _.each(param.errors, function(val, key) {
            var vName = _.underscored(key) + '_' + param_index;
            var $input = this.view.$("select[name=\"" + vName + "\"], input[name=\"" + vName + "\"], form textarea[name=\"" + vName + "\"]");

            // If the error isn't on a text input, we show as an error div rather than a tool tip.
            if ($input.length === 0) {
                this.other_errors.push(val);
            } else {
                this.view.markInputAsInvalid($input, val, false);
            }
        }, { view: this, other_errors: other_errors });

        if (other_errors.length !== 0) {
            var err_el = this.$el.find("div.worklet_parameter_module[data-index=" + param_index + "] .errors");
            err_el.removeClass("hidden");

            var output = ["<ul>"];
            _.each(other_errors, function(msg) {
                this.push("<li>" + msg + "</li>");
            }, output);
            output.push("</ul>");
            err_el.html(output.join(""));
        }
    },

    clearParamErrors: function(param, param_index) {
        _.each(param.errors, function(val, key) {
            var vName = _.underscored(key) + '_' + param_index;
            var $input = this.$("select.has_error[name=\"" + vName + "\"], input.has_error[name=\"" + vName + "\"], form textarea.has_error[name=\"" + vName + "\"]");
            $input.qtip("destroy");
            $input.removeData("qtip");
            $input.removeClass("has_error");
        }, this);

        var err_el = this.$el.find("div.worklet_parameter_module[data-index=" + param_index + "] .errors");
        err_el.empty().addClass("hidden");

        param.errors = {};
    },

    updateParameter: function(e, model_index, perform_save, save_options) {
        e && e.preventDefault();

        // Below uses e.target.dataset.index to index model.
        // But if positional changes made, need to do something like this:
        // var param_info = this.workletParams[e.target.dataset.index];
        // var param_model = _.find(this.variables.models, function (v) {
        //     return v.get('id') == this;
        // }, param_info.id);
        var i = (typeof(model_index) !== 'number')? e.target.dataset.index : model_index;
        var param_model = this.parameters.models[i];
        var updates = {
            variableName: this.$('select[name=variable_name_' + i + '] option:selected').val(),
            description: this.$('textarea[name=description_' + i + ']').val(),
            label: this.$('input[name=label_' + i + ']').val(),
            useDefault: this.$('input[name=use_default_' + i + ']')[0].checked,
            required: this.$('input[name=required_' + i + ']')[0].checked,
            dataType: this.$('select[name=data_type_' + i + '] option:selected').val()
        };

        // Select options:
        var opts_els = this.$('input[name^=option_][data-index=' + i + ']');
        if (opts_els.length > 0) {
            var options = _.map(opts_els, function(o) {
                return {
                    option: this.$(o).val(),
                    value: this.$('input[name=value_' + o.dataset.optionIndex + '_' + o.dataset.index + ']').val()
                };
            }, this);
            updates.options = options;
        }

        var old_dt = param_model.get('dataType');
        var old_vn = param_model.get('variableName');

        // Set the attributes for the changes, and cast to specific parameter class.
        param_model.set(updates);
        param_model = param_model.castByDataType();
        this.parameters.models[i] = param_model;

        // If we're updating data type then we want to rerender before validating.
        if (!_.isUndefined(old_dt) && old_dt !== updates.dataType) {
            this.render();
        }

        // Validate and set the model on client side.
        this.clearParamErrors(param_model, i);
        var has_validation_errors = !param_model.performValidation(updates);

        // Validate workflow variable uniqueness
        var dup_var_params = _.reject(this.parameters.models, function(p, i) {
            return (i === 1*this.index) || (p.get('variableName') !== this.varName);
        }, {
            view: this,
            index: i,
            varName: param_model.get('variableName')
        });
        if (!_.isEmpty(dup_var_params)) {
            var var_name = param_model.get('variableName');
            var err_msg = t('worklet.validation.duplicate_workflow_variable', { name: var_name });

            // Show errors on this model
            param_model.errors["variable_name"] = err_msg;
            has_validation_errors = true;
        } else {
            // Reassignment of variable name can lead to the case where
            // we'd like to automatically clear the variableName error on the formerly
            // assigned parameter.
            _.each(this.parameters.models, function(p, j) {
                if (p.errors && !_.isUndefined(p.errors["variable_name"]) && p.get('variableName') === this.varName) {
                    var tmp_errs = _.omit(p.errors, "variable_name");
                    this.view.clearParamErrors(p, j);
                    p.errors = tmp_errs;
                    this.view.showParamErrors(p, j);
                }
            }, {
                view: this,
                varName: old_vn
            });
        }

        if (has_validation_errors === true) {
            this.showParamErrors(param_model, i);
            this.broadcastEditorState();
            return false;
        }

        if (perform_save === true) {
            var save_state = false !== param_model.save(updates, save_options);
            this.paramChanged(true);
            return save_state;
        } else {
            this.paramChanged(true);
        }
    },

    paramChanged: function(rerender) {
        this._hasUnsavedChanges = true;
        this.broadcastEditorState();

        // Update preview pane
        this.worklet.parameters().trigger('update');

        if (rerender === true) {
            this.render();
        }
    },

    paramSaved: function() {
        // Update preview pane
        this.worklet.parameters().trigger('update');
    },

    paramSaveFailed: function(e,f,g) {
        this.broadcastEditorState();
        this.displayServerErrors();
    },

    deleteParameter: function(e) {
        e && e.preventDefault();
        //var p = this.workletParams()[e.currentTarget.dataset.index]
        var m = this.parameters.at(e.currentTarget.dataset.index);
        new chorus.alerts.WorkletParameterDeleteAlert({
            model: m,
            at: e.currentTarget.dataset.index
        }).launchModal();
    },

    paramDeleted: function(param_options) {
        // Remove from collection
        this.parameters.remove(param_options.model.cid);
        this.paramChanged(true);
    },

    newParameter: function(e) {
        e && e.preventDefault();

        var new_var = new chorus.models.WorkletParameter({
            workfileId: this.worklet.id,
            workspaceId: this.worklet.workspace().id
        });
        this.listenTo(new_var, "saved", this.paramChanged);
        this.listenTo(new_var, "changed", this.paramChanged);
        this.listenTo(new_var, "validationFailed", this.paramSaveFailed);

        //new_var.save();
        this.parameters.add(new_var);
        this.paramChanged(true);
    },

    saveParameters: function(e) {
        e && e.preventDefault();

        this.clearErrors();
        var save_attempts = _.map(this.worklet.parameters().models, function(param_model, index) {
            return this.updateParameter(null, index, true, { wait: true });
        }, this);

        if (!_.contains(save_attempts, false)) {
            this._hasUnsavedChanges = false;
            this.broadcastEditorState();
            return true;
        } else {
            this._hasUnsavedChanges = true;
            this.broadcastEditorState();
            return false;
        }
    },


    addParameterOptionInput: function(e) {
        e && e.preventDefault();

        var m = this.parameters.models[e.currentTarget.dataset.index];
        var options = m.get('options') || [];

        options.push({
            option: '',
            value: ''
        });

        m.set('options', options);

        this.paramChanged(true);
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

        this.paramChanged(true);
    },

    workletParams: function() {
        // Used to render the parameter edit modules:
        return _.map(this.parameters.models, function(v, i) {
            var workflow_var_pair = _.find(this.workflowVariables, function(w) { return w.variableName === this + ""; }, v.get('variableName'));

            return _.extend(_.clone(v.attributes), {
                // Store the variable default (sifted from the array of workflow variables)
                noVariableSelected: _.isUndefined(v.get('variableName')),
                variableDefault: workflow_var_pair && workflow_var_pair.variableDefault,

                // Single/multiple-options related
                hasOptions: v.get('dataType') === t('worklet.parameter.datatype.single_option_select') || v.get('dataType') === t('worklet.parameter.datatype.multiple_option_select'),
                options: _.map(v.get('options') || [], function (o,i) { return _.extend(_.clone(o), { optionIndexPlusOne: i + 1 }); }),

                // For use instead of the handlebars @index:
                displayIndex: i,
                displayIndexPlusOne: i + 1,

                useDefaultDisabled: (v.get('dataType') === t('worklet.parameter.datatype.single_option_select') ||
                                     v.get('dataType') === t('worklet.parameter.datatype.multiple_option_select') ||
                                     v.get('dataType') === t('worklet.parameter.datatype.datetime_calendar'))
            });
        }, this);
    },

    additionalContext: function () {
        return {
            workflowVariables: this.workflowVariables,
            workletParams: this.workletParams(),
            dataTypes: chorus.WorkletConstants.DataTypes
        };
    }
});