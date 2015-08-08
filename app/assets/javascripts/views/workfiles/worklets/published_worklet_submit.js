chorus.views.PublishedWorkletSubmit = chorus.views.Base.extend({
    constructorName: "PublishedWorkletSubmitView",
    templateName: "worklets/published_worklet_submit",

    subviews: {
        ".list": "list",
        ".worklet_parameters": "workletParametersView"
    },

    events: {
        "click button.submit": 'runWorklet'
    },

    setup: function() {
        this.model = this.options.model;
        // Render parameter list into a view,
        // update when collection has updated.
        this.workletParametersView = new chorus.views.WorkletParameterList({
            model: this.model
        });
        this.listenTo(this.model.parameters(), 'update', this.renderSubviews);

        this.historyView = this.options.historyView;
        this.pollForRunStatus = _.bind(function() {
            this.model.fetch({
                success: _.bind(function(model) {
                    if(!model.get('running')) {
                        clearInterval(this.pollerID);
                        this.$(".form_controls").show();
                        this.$(".spinner_div").hide();
                        var activities = model.activities();
                        activities.loaded = false;
                        activities.fetchAll();
                        this.onceLoaded(activities, this.reloadHistory);
                    }
                }, this)
            });
        }, this);

        this.render();
    },

    runWorklet: function() {
        // If all parameters validate, gather up the inputs and invoke alpine run with them.
        if (this.workletParametersView.validateParameterInputs()) {
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

            this.model.run(worklet_parameters);


            this.$(".form_controls").hide();
            this.$(".spinner_div").show();
            this.pollerID = setInterval(this.pollForRunStatus, 1000);
        }
    },

    reloadHistory: function() {
        this.historyView.render();
        this.historyView.$('.history_item')[0].click();
    },

    additionalContext: function () {
        return {
            // variables: this.variablesProcessed()
        };
    },

    postRender: function() {
        _.defer(_.bind(function() {
            _.each($("select.worklet_select"), function(select) {
                chorus.styleSelect(select, {style: 'width: 250px'});
            });
        }, this));
        this.$(".loading_spinner").startLoading(null, {color: '#959595'});

        if (this.model.get('running')) {
            this.$(".form_controls").hide();
            this.$(".spinner_div").show();
            if (!this.pollerID) {
                this.pollerID = setInterval(this.pollForRunStatus, 5000);
            }
        }
        else {
            this.$(".form_controls").show();
            this.$(".spinner_div").hide();
        }
    }

});