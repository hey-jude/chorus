chorus.models.WorkletParameter = chorus.models.Base.extend({
    constructorName: "WorkletParameter",
    urlTemplate: "workspaces/{{workspaceId}}/worklets/{{workletId}}/parameters/{{id}}",
    viewClass: chorus.views.WorkletParameter,

    initialize: function(options) {
        if (this.collection) {
            this.set('workspaceId', this.collection.attributes.workspaceId);
            this.set('workletId', this.collection.attributes.workletId);
        } else {
            this.set('workspaceId', options.workspaceId);
            this.set('workletId', options.workletId);
        }
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