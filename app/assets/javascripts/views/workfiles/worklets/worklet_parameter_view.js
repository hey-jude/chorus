chorus.views.WorkletParameterList = chorus.views.Base.extend({
    constructorName: "WorkletParameterListView",
    templateName: "worklets/parameters/worklet_parameter_list",

    setup: function() {
        // this.parameters becomes the filtered set of variable views.
        this.parameters = [];
        this.collection = this.model.parameters();

        this.state = this.options.state || 'running';

        if (!this.collection) {
            this.collection = new chorus.collections.WorkletParameterSet([], {
                workspaceId: this.model.workspace().id,
                workletId: this.model.id
            });

            this.collection.fetchAll();
        }

        this.noFilter = true;
    },

    filter: function (parameter_model) {
        return this.noFilter;
    },

    parameterModelByDataType: function(parameter_model) {
        var type = parameter_model.get('dataType');
        var modelClass = null;

        //worklet.parameter.datatype.number=Number
        //worklet.parameter.datatype.text=Text
        //worklet.parameter.datatype.single_option_select=Select Single Option
        //worklet.parameter.datatype.multiple_option_select=Select Multiple Options
        //worklet.parameter.datatype.datetime_calendar=Date/time - Calendar
        //worklet.parameter.datatype.datetime_relative=Date/time - Relative

        if (type === t('worklet.parameter.datatype.number') || type === 'integer') {
            modelClass = chorus.models.WorkletNumericParameter;
        } else if (type === t('worklet.parameter.datatype.text') || type === 'string') {
            modelClass = chorus.models.WorkletTextParameter;
        }
        //else if (type === t('worklet.parameter.datatype.single_option_select') || type === 'singleOption') {
        //    modelClass = chorus.models.WorkletSingleOptionParameter;
        //} else if (type === t('worklet.parameter.datatype.multiple_option_select') || type === 'multipleOptions') {
        //    modelClass = chorus.models.WorkletMultipleOptionParameter;
        //}
        else {
            return parameter_model;
            // You could instead (unnecessarily) do:
            // modelClass = chorus.models.WorkletParameter;
        }

        return new modelClass(parameter_model);
    },

    preRender: function () {
        this.parameters = this.collection.filter(this.filter, this).map(function (parameter_model) {
            // Cast model to subclass that has type-specific validations
            parameter_model = this.parameterModelByDataType(parameter_model);

            // View specific to the subclass is stored in "viewClass" attribute of the model.
            var parameter_view = new parameter_model.viewClass({
                model: parameter_model,
                state: this.state
            });
            this.registerSubView(parameter_view);

            // Storing both view and model instances for validation ease.
            return { view: parameter_view, model: parameter_model };
        }, this);
    },

    postRender: function () {
        if (this.parameters.length) {
            // Renders each subview into a document fragment container first
            // so as to not incrementally re-render inefficiently.
            var container = document.createDocumentFragment();
            _.each(this.parameters, function(parameter) {
                container.appendChild(parameter.view.render().el);
            });
            this.$el.append(container);
        }
    },

    additionalContext: function() {
        return {
            editing: this.state === 'editing'
        };
    },

    collectParameterUserInputs: function() {
        _.each(this.parameters, function(parameter) {
            parameter.userInput = parameter.view.getUserInput();
        });
    },

    validateParameterInputs: function() {
        // Uses the { view: ..., model: ... } structure as created in this.preRender
        // to validate each model, and then to display on the view.
        this.collectParameterUserInputs();

        var hasErrors = _.filter(this.parameters, function(parameter) {
            // var userInput = parameter.view.getUserInput();
            if (parameter.model.performRunValidation(parameter.userInput)) {
                parameter.view.clearErrors();
                return false;
            }
            return true;
        });

        if (hasErrors.length > 0) {
            _.each(hasErrors, function(parameter) {
                // Places error to the left of the input.
                parameter.view.showErrors(parameter.model, {
                    position: {
                        at: "left center",
                        my: "right center"
                    }
                });
            });
            return false;
        }

        return true;
    }
});

chorus.views.WorkletParameter = chorus.views.Base.extend({
    constructorName: "WorkfileParameterView",
    templateName: "worklets/parameters/worklet_parameter",
    additionalClass: "worklet_parameter",

    setup: function() {
        this.state = this.options.state || 'running';
    },

    getUserInput: function() {
        // Assumes there's an <input name="n"> where "n" is this.model.get('variableName')
        // E.g. for <input type="text">
        var v = {};
        v[this.model.get('variableName')] = this.$el.find('input[name="' + this.model.get('variableName') + '"]').val();

        return v;
    },

    additionalContext: function () {
        return {
            editing: this.state === 'editing'
        };
    }
});

chorus.views.WorkletNumericParameter = chorus.views.WorkletParameter.extend({
    templateName: "worklets/parameters/worklet_numeric_parameter"
});

chorus.views.WorkletTextParameter = chorus.views.WorkletParameter.extend({
    templateName: "worklets/parameters/worklet_text_parameter"
});

//chorus.views.WorkletSingleOptionParameter = chorus.views.WorkletParameter.extend({
//    templateName: "worklets/parameters/worklet_single_option_parameter"
//});
//
//chorus.views.WorkletMultipleOptionParameter = chorus.views.WorkletParameter.extend({
//    templateName: "worklets/parameters/worklet_multiple_option_parameter"
//});
