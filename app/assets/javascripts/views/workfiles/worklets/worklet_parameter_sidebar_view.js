chorus.views.WorkletParameterSidebar = chorus.views.Base.extend({
    constructorName: "WorkletParameterSidebar",
    templateName: "worklets/worklet_parameter_sidebar",

    subviews: {
        ".worklet_parameters": "workletParametersView"
    },

    events: {
        "click button.test_worklet_button": 'testRunClicked',
        "click button.run_worklet_button": 'runClicked',
        "click button.stop_worklet_button": 'stopClicked'
    },

    setup: function() {
        this.model = this.options.model;
        this.state = this.options.state || 'running';

        // Render parameter list into a view,
        // update when collection has updated.
        this.workletParametersView = new chorus.views.WorkletParameterList({
            model: this.model,
            state: this.state
        });

        this.listenTo(this.model.parameters(), 'update', this.render);
        //this.historyView = this.options.historyView;
        this.subscribePageEvent("worklet:run", this.runEventHandler);

        this.render();
    },

    runEventHandler: function(event) {
        if (event === 'runStopped') {
            this.$(".form_controls.run_worklet").show();
            this.$(".spinner_div").hide();
            this.$(".form_controls.stop_worklet").hide();
        } else if (event === 'runStarted') {
            this.$(".form_controls.run_worklet").hide();
            this.$(".spinner_div").show();
            this.$(".form_controls.stop_worklet").show();
        }
    },

    createAlpinePayload: function() {
        var worklet_parameters = {
            string: null,
            fields: []
        };

        _.each(this.workletParametersView.parameters, function(parameter) {
            var var_name = parameter.model.get('variableName');
            worklet_parameters.fields.push({
                id: parameter.model.get('id'),
                name: var_name,
                value: parameter.userInput[var_name]
            });

            worklet_parameters.string = parameter.userInput;
        });

        return worklet_parameters;
    },

    runClicked: function(e) {
        e && e.preventDefault();

        // If all parameters validate, gather up the inputs and invoke alpine run with them.
        if (this.workletParametersView.validateParameterInputs()) {
            var worklet_parameters = this.createAlpinePayload();
            this.model.run(worklet_parameters);
            chorus.PageEvents.trigger("worklet:run", "runStarted");
        }
    },

    testRunClicked: function(e) {
        e && e.preventDefault();
        if (this.workletParametersView.validateParameterInputs()) {
            var dialog = new chorus.dialogs.WorkletTest({
                model: this.model,
                workletParameters: this.createAlpinePayload()
            });
            dialog.launchModal();
        }
    },

    stopClicked: function(e) {
        e && e.preventDefault();
        this.model.stop();
        chorus.PageEvents.trigger("worklet:run", "clickedStop");
    },

    additionalContext: function () {
        return {
            editState: this.state === 'editing',
            runState: this.state === 'running',
            noParameters: this.model.parameters().length === 0
        };
    },

    postRender: function() {
        _.defer(_.bind(function() {
            _.each($("select.worklet_select"), function(select) {
                chorus.styleSelect(select, {style: 'width: 250px'});
            });
        }, this));

        this.$(".loading_spinner").startLoading(null, {color: '#959595'});
        if(this.model.get('running')) {
            this.runEventHandler('runStarted');
        }

        //if (this.model.get('running')) {
        //    this.$(".form_controls").hide();
        //    this.$(".spinner_div").show();
        //} else {
        //    this.$(".form_controls").show();
        //    this.$(".spinner_div").hide();
        //}
    }
});