chorus.views.WorkletParameterList = chorus.views.Base.extend({
    constructorName: "WorkletParameterListView",
    templateName: "worklets/parameters/worklet_parameter_list",

    setup: function() {
        // this.parameters becomes the filtered set of variable views
        this.parameters = [];
        this.worklet = this.options.worklet;
        this.collection = this.worklet.parameters();

        this.state = this.options.state || 'running';

        if (!this.collection) {
            this.collection = new chorus.collections.WorkletParameterSet([], {
                workspaceId: this.worklet.workspace().id,
                workletId: this.worklet.id
            });

            this.collection.fetchAll();
        }

        this.noFilter = true;

        this.worklet.fetchWorkflowVariables();
        this.subscribePageEvent('worklet:workflow_variables_loaded', this.workflowVariablesLoaded);
    },

    workflowVariablesLoaded: function(workflowVariables) {
        if (_.isEmpty(this.workflowVariables) && !_.isEmpty(workflowVariables)) {
            this.workflowVariables = workflowVariables;
            this.render();
        }
    },

    filter: function (parameter_model) {
        return this.noFilter;
    },

    preRender: function () {
        this.parameters = this.collection.filter(this.filter, this).map(function (parameter_model, displayIndex) {
            // Cast model to subclass that has type-specific validations
            parameter_model = parameter_model.castByDataType();

            // Get default value from alpine-provided workflow variables
            var workflow_var_pair = _.find(this.workflowVariables, function(w) { return w.variableName === this + ""; }, parameter_model.get('variableName'));

            // View specific to the subclass is stored in "viewClass" attribute of the model
            var parameter_view = new parameter_model.viewClass({
                model: parameter_model,
                state: this.state,
                displayIndex: displayIndex,
                variableDefault: workflow_var_pair && workflow_var_pair.variableDefault
            });
            this.registerSubView(parameter_view);

            // Storing both view and model instances for validation ease
            return { view: parameter_view, model: parameter_model };
        }, this);
    },

    postRender: function () {
        if (this.parameters.length) {
            // Renders each subview into a document fragment container first
            // so as to not incrementally re-render inefficiently
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
        // to validate each model, and then to display on the view
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
                // Places error to the left of the input
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

    events: {
        // "click a.delete_input_param": 'deleteParameter',
        "click a.scroll_input_param": 'scrollToParameter'
    },

//     deleteParameter: function(e) {
//         e && e.preventDefault();
//         new chorus.alerts.WorkletParameterDeleteAlert({ model: this.model }).launchModal();
//     },

    scrollToParameter: function(e) {
        e && e.preventDefault();

        chorus.PageEvents.trigger("parameter:scrollTo", this.model);
    },

    setup: function() {
        this.state = this.options.state || 'running';
    },

    getUserInput: function() {
        // Assumes there's an <input name="n"> where "n" is this.model.get('variableName')
        var v = {};
        v[this.model.get('variableName')] = this.$el.find('input[name="' + this.model.get('variableName') + '"]').val();
        return v;
    },

    additionalContext: function () {
        return {
            editing: this.state === 'editing',
            displayIndexPlusOne: this.options.displayIndex + 1,
            variableDefault: this.options.variableDefault
        };
    }
});

chorus.views.WorkletNumericParameter = chorus.views.WorkletParameter.extend({
    templateName: "worklets/parameters/worklet_numeric_parameter"
});

chorus.views.WorkletTextParameter = chorus.views.WorkletParameter.extend({
    templateName: "worklets/parameters/worklet_text_parameter"
});

chorus.Mixins.WorkletErrorOverride = {
    showErrors: function(model) {
        var err_el = this.$el.find(".errors");
        err_el.removeClass("hidden");

        var output = ["<ul>"];
        _.each(model.errors, function(msg, field_name) {
            this.push("<li>" + msg + "</li>");
        }, output);
        output.push("</ul>");

        err_el.html(output.join(""));
    }
};

chorus.views.WorkletSingleOptionParameter = chorus.views.WorkletParameter.extend(
    {
    templateName: "worklets/parameters/worklet_single_option_parameter",

    getUserInput: function() {
        // Assumes there's an <select name="n"> where "n" is this.model.get('variableName')
        var v = {};
        var var_el = this.$el.find('select[name="' + this.model.get('variableName') + '"]  option:selected');
        // Uses the name of the option if the option value is blank
        v[this.model.get('variableName')] = var_el.val() || var_el[0].dataset.optionLabel;

        return v;
    }
});

chorus.views.WorkletMultipleOptionParameter = chorus.views.WorkletParameter.include(chorus.Mixins.WorkletErrorOverride).extend({
    templateName: "worklets/parameters/worklet_multiple_option_parameter",

    getUserInput: function() {
        // Assumes there are <input type="checkbox" name"n_i"> where "n" is this.model.get('variableName')
        // and "i" is the ith option in this.model.get('options').

        // Filter for only the options that are checked
        var checked_options = _.filter(this.model.get('options'), function(o, i) {
            return $('input[name="' + this.model.get('variableName') + '_' + i + '"]' )[0].checked;
        }, this);

        // Return the options as an array of strings in the result object.
        var v = {};
        v[this.model.get('variableName')] = _.map(checked_options, function(o) {
            // Uses o.option if (!o.value) (i.e. if o.value is blank)
            return o.value || o.option;
        }).join(',');

        return v;
    }
});

chorus.views.WorkletCalendarParameter = chorus.views.WorkletParameter.include(chorus.Mixins.WorkletErrorOverride).extend({
    templateName: "worklets/parameters/worklet_calendar_parameter",

    subviews: {
        ".start_date": "startDatePicker"
    },

    setup: function() {
        this._super('setup', []);

        this.startDatePicker = new chorus.views.DatePicker({
            selector: 'start_date',
            disableBeforeToday: false
        });
    },

    getUserInput: function() {
        var v = {};
        v[this.model.get('variableName')] = this.startDatePicker.getDate().format('YYYY-MM-DD');

        return v;
    }
});
