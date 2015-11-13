chorus.views.WorkletParameterSidebar = chorus.views.Sidebar.extend({
    constructorName: "WorkletParameterSidebar",
    templateName: "worklets/worklet_parameter_sidebar",

    additionalClass: "worklet_panel",

    subviews: {
        ".worklet_parameters": "workletParametersView"
    },

    events: {
        "click button.test_worklet_button": 'testRunClicked',
        "click button.run_worklet_button": 'runClicked',
        "click button.stop_worklet_button": 'stopClicked',
        "click div.reset_inputs": "resetInputs"
    },

    setup: function() {
        this.worklet = this.options.worklet;
        this.state = this.options.state || 'running';

        // Render parameter list into a view,
        // update when collection has updated
        this.workletParametersView = new chorus.views.WorkletParameterList({
            worklet: this.worklet,
            state: this.state
        });

        this.listenTo(this.worklet.parameters(), 'update', this.render);
        //this.historyView = this.options.historyView;
        this.subscribePageEvent("worklet:run", this.runEventHandler);

        this.render();
    },

    runEventHandler: function(event) {
        if (event === 'runStopped') {
            this.$(".run_worklet").stopLoading();
            this.$(".stop_worklet").hide();
        } else if (event === 'runStarted') {
            this.$(".run_worklet").startLoading("general.running", {color: '#959595'});
            this.$(".stop_worklet").show();
        }
    },

    createAlpinePayload: function() {
        var worklet_parameters = {
            string: {},
            fields: []
        };

        _.each(this.workletParametersView.parameters, function(parameter) {
            var var_name = parameter.model.get('variableName');
            worklet_parameters.fields.push({
                id: parameter.model.get('id'),
                name: var_name,
                value: parameter.userInput[var_name]
            });

            _.extend(worklet_parameters.string, parameter.userInput);
        });

        return worklet_parameters;
    },

    runClicked: function(e) {
        e && e.preventDefault();

        // If all parameters validate, gather up the inputs and invoke alpine run with them
        if (this.workletParametersView.validateParameterInputs()) {
            this.runEventHandler('runStarted');
            this.worklet.run(this.createAlpinePayload());
            this.listenToOnce(this.worklet, "saved", this.runStarted);
            this.listenToOnce(this.worklet, "saveFailed", this.runStartFailed);
        }
    },

    runStarted: function() {
        chorus.PageEvents.trigger("worklet:run", "runStarted");
    },

    runStartFailed: function() {
        this.runEventHandler('runStopped');
    },

    testRunClicked: function(e) {
        e && e.preventDefault();
        if (this.workletParametersView.validateParameterInputs()) {
            var dialog = new chorus.dialogs.WorkletTest({
                worklet: this.worklet,
                workletParameters: this.createAlpinePayload(),
                outputTable: this.worklet.get('outputTable')
            });
            dialog.launchModal();
        }
    },

    stopClicked: function(e) {
        e && e.preventDefault();
        this.worklet.stop();
        chorus.PageEvents.trigger("worklet:run", "clickedStop");
    },

    resetInputs: function() {
        this.render();
    },

    additionalContext: function () {
        return {
            editState: this.state === 'editing',
            runState: this.state === 'running',
            noParameters: this.worklet.parameters().length === 0
        };
    },

    postRender: function() {
        this._super('postRender');

        _.defer(_.bind(function() {
            _.each($("select.worklet_select"), function(select) {
                chorus.styleSelect(select, {style: 'width: 250px'});
            });
        }, this));

        this.$(".stop_worklet").hide();
        if(this.worklet.get('running')) {
            this.runEventHandler('runStarted');
        }
    }
});