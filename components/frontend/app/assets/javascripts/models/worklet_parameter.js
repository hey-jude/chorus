chorus.models.WorkletParameter = chorus.models.Base.extend({
    constructorName: "WorkletParameter",
    parameterWrapper: "worklet_parameter",
    urlTemplate: "workspaces/{{workspaceId}}/touchpoints/{{workfileId}}/parameters/{{id}}",
    viewClass: chorus.views.WorkletParameter,

    initialize: function(options) {
        if (this.collection) {
            this.set('workspaceId', this.collection.attributes.workspaceId);
            this._workletId = this.collection.attributes.workletId;
        } else {
            this.set('workspaceId', options.workspaceId || options.get('workspaceId'));
            this._workletId = options.workfileId || options.get('workfileId');
        }

        this.set('workfileId', this._workletId);
    },

    castByDataType: function() {
        var type = this.get('dataType');
        var modelClass = null;

        if (type === t('worklet.parameter.datatype.number') || type === 'integer') {
            modelClass = chorus.models.WorkletNumericParameter;
        } else if (type === t('worklet.parameter.datatype.text') || type === 'string') {
            modelClass = chorus.models.WorkletTextParameter;
        } else if (type === t('worklet.parameter.datatype.single_option_select') || type === 'singleOption') {
            modelClass = chorus.models.WorkletSingleOptionParameter;
        } else if (type === t('worklet.parameter.datatype.multiple_option_select') || type === 'multipleOptions') {
            modelClass = chorus.models.WorkletMultipleOptionParameter;
        } else if (type === t('worklet.parameter.datatype.datetime_calendar') || type === 'multipleOptions') {
            modelClass = chorus.models.WorkletCalendarParameter;
        }
        else {
            return this;
            // You could instead (unnecessarily) do:
            // modelClass = chorus.models.WorkletParameter;
        }

        var newModel = new modelClass(this);
        newModel.cid = this.cid;

        return newModel;
    },

    // There are two "validations" using similar machinery that happen using these "parameter" models;
    // 1) During editing, the details of the form defining the parameter must be valid
    //      - Uses the declareValidations method and the "require" etc methodss
    // 2) When using the parameters to run a worklet, the user inputs must be valid against
    //    the validations as set up during editing mode.
    //      - Uses the declareRunValidations method.
    //      - Uses the "require" methods prefixed with "runMode"
    performRunValidation: function(newAttrs) {
        this.errors = {};
        this.declareRunValidations(newAttrs);
        return _(this.errors).isEmpty();
    },

    runModeRequire: function(attr, newAttrs, variableLabel) {
        var value = newAttrs && newAttrs.hasOwnProperty(attr) ? newAttrs[attr] : this.get(attr);
        var present = value;

        if (value && _.isString(value) && _.stripTags(value).match(chorus.ValidationRegexes.AllWhitespace())) {
            present = false;
        }

        if (!present) {
            this.errors[attr] = t("validation.required", { 'fieldName': variableLabel });
        }
    },

    runModeRequireNumeric: function(attr, newAttrs, variableLabel, allowBlank) {
        var value = newAttrs && newAttrs.hasOwnProperty(attr) ? newAttrs[attr] : this.get(attr);
        value = value && value.toString();

        if (allowBlank && !value) {
            return;
        }

        // Matches positive or negative numeric value, optionally with scientific notation exponent
        // Integer: \-?\d+
        // Float: \-?\d*\.\d+
        // Optional sci. notation: [eE][-+]?\d+
        if (!value || !value.match(/^(\-?\d+|\-?\d*\.\d+)([eE][-+]?\d+)?$/)) {
            this.errors[attr] = t("validation.required_numeric", { 'fieldName': variableLabel });
        }
    },

    declareRunValidations: function(newAttrs) {
        var varName = this.get('variableName');
        var varLabel = this.get('label');

        if (this.get('required') === true) {
            this.runModeRequire(varName, newAttrs, varLabel);
        }
    },

    // Validations for editing mode:
    declareValidations: function(newAttrs) {
        this.require('label');
        this.require('dataType');
        this.require('variableName');
    },

    attrToLabel: {
      "label":"worklet.configure.inputs.field_label",
      "dataType":"worklet.edit.input.data_type.label",
      "variableName":"worklet.configure.inputs.workflow_variable"
    }

});

chorus.models.WorkletNumericParameter = chorus.models.WorkletParameter.extend({
    constructorName: "WorkletNumericParameter",
    viewClass: chorus.views.WorkletNumericParameter,

    // Validations specific to numeric parameters
    declareRunValidations: function(newAttrs) {
        this._super('declareRunValidations', [newAttrs]);

        var varName = this.get('variableName');
        var varLabel = this.get('label');

        // Numeric variable value validations
        this.runModeRequireNumeric(varName, newAttrs, varLabel, this.get('required') === false);
    }
});

chorus.models.WorkletTextParameter = chorus.models.WorkletParameter.extend({
    constructorName: "WorkletTextParameter",
    viewClass: chorus.views.WorkletTextParameter,

    // Validations specific to numeric parameters
    declareRunValidations: function(newAttrs) {
        this._super('declareRunValidations', [newAttrs]);

        // Text variable value validations
        // TODO: Decide what this should check
        //var varName = this.get('variableName');
        //var varLabel = this.get('label');
        // this.runRequireTextReasonable(varName, newAttrs, varLabel, this.get('required') === false);
    }
});

chorus.models.WorkletSingleOptionParameter = chorus.models.WorkletParameter.extend({
    constructorName: "WorkletSingleOptionParameter",
    viewClass: chorus.views.WorkletSingleOptionParameter,

    // Validations specific to single input parameters
    declareRunValidations: function(newAttrs) {
        this._super('declareRunValidations', [newAttrs]);
    },

    // Validations for editing mode:
    declareValidations: function(newAttrs) {
        // For any options, all "option" values must be provided.
        this._super('declareValidations', [newAttrs]);

        _.each(newAttrs.options, function(o, i) {
            var opt_value = o.option;

            if (!opt_value || _.stripTags(opt_value).match(chorus.ValidationRegexes.AllWhitespace())) {
                this.errors["option_" + i] = t("validation.required", { 'fieldName': "Option" });
            }
        }, this);
    }
});

chorus.models.WorkletMultipleOptionParameter = chorus.models.WorkletSingleOptionParameter.extend({
    constructorName: "WorkletMultipleOptionParameter",
    viewClass: chorus.views.WorkletMultipleOptionParameter,

    // Validations specific to multiple input parameters
    declareRunValidations: function(newAttrs) {
        this._super('declareRunValidations', [newAttrs]);
    },

    runModeRequire: function(attr, newAttrs, variableLabel) {
        var value = newAttrs && newAttrs.hasOwnProperty(attr) ? newAttrs[attr] : this.get(attr);
        var present = value;

        if (!_.isString(value) || _.stripTags(value).match(chorus.ValidationRegexes.AllWhitespace())) {
            present = false;
        }

        if (!present) {
            this.errors[attr] = t("validation.required", { 'fieldName': variableLabel });
        }
    }
});

chorus.models.WorkletCalendarParameter = chorus.models.WorkletParameter.extend({
    constructorName: "WorkletCalendarParameter",
    viewClass: chorus.views.WorkletCalendarParameter,

    // Validations specific to calendar parameters
    declareRunValidations: function(newAttrs) {
        this._super('declareRunValidations', [newAttrs]);

        if (_.include(newAttrs[this.get('variableName')], "NaN")) {
            this.errors[this.get('variableName')] = t("validation.valid_date", { 'fieldName': this.get('label') });
        }
    }
});