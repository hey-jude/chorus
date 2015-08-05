chorus.views.PublishedWorkletSubmit = chorus.views.Base.extend({
    constructorName: "PublishedWorkletSubmitView",
    templateName: "published_worklet_submit",

    subviews: {
        ".list": "list"
    },

    events: {
        "click button.submit": 'runWorklet'
    },

    setup: function() {
        this.model = this.options.model;
        this.variables = this.options.variables;
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
        var worklet_parameters = {};
        var worklet_parameters_string = {};
        var worklet_parameters_fields = [];
        var variables = this.variables;

        _.each(variables, function(i) {
            var dataType = i.dataType;
            var name = i.variableName;
            var value;
            if(dataType === 'integer') {
                value = $(this.$('.variables').find("input[name='" + name + "']")).val();
            }
            else if(dataType === 'string') {
                value = $(this.$('.variables').find("input[name='" + name + "']")).val();
            }
            else if(dataType === 'singleOption') {
                value = $(this.$('.variables').find("select[name='" + name + "']")).val();
            }
            else if(dataType === 'multipleOptions') {
                var checkboxes = $(this.$('.variables').find("div[name='" + name + "']").find('input'));
                value = '';
                _.each(checkboxes, function(j) {
                    if(j.checked){
                        value += ((value.length > 0) ? ',' : '') + j.value;
                    }
                });
                value = "(" + value + ")";
            }
            var fields = {};
            fields['name'] = name;
            fields['value'] = value;
            fields['id'] = i.id;
            worklet_parameters_string[name] = value;
            worklet_parameters_fields.push(fields);
        });

        worklet_parameters['string'] = worklet_parameters_string;
        worklet_parameters['fields'] = worklet_parameters_fields;

        this.model.run(worklet_parameters);

        this.$(".form_controls").hide();
        this.$(".spinner_div").show();

        this.pollerID = setInterval(this.pollForRunStatus, 5000);
    },

    reloadHistory: function() {
        this.historyView.render();
        this.historyView.$('.history_item')[0].click();
    },

    variablesProcessed: function() {
        //var data_types = [
        //    "Text",
        //    "Number",
        //    "Select Single Option",
        //    "Select Multiple Options",
        //    "Date/time - Calendar",
        //    "Date/time - Relative"
        //];

        // TODO: Fix this odd strategy for doing this...
        var variables = [];
        this.variables.forEach(function(item) {
            var x = item;
            x[item.dataType] = true;
            variables.push(x);
        });

        return variables;
    },

    additionalContext: function () {
        return {
            variables: this.variablesProcessed()
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
            this.$(".form_controls").hide();
            this.$(".spinner_div").show();
            if(!this.pollerID) {
                this.pollerID = setInterval(this.pollForRunStatus, 5000);
            }
        }
        else {
            this.$(".form_controls").show();
            this.$(".spinner_div").hide();
        }
    }

});