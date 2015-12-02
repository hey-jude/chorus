chorus.views.AlpineWorkfileContentDetails = chorus.views.WorkfileContentDetails.extend({
    templateName: "alpine_workfile_content_details",
    additionalClass: "action_bar_highlighted",

    events: {
        'click a.change_workfile_database': 'changeWorkfileDatabase',
        'click .open_file': 'navigateToWorkFlow'
    },

    setup: function () {
        var members = this.model.workspace().members();
        this.listenTo(members, 'reset loaded', this.render);
        members.fetch();
    },

    additionalContext: function () {

        var ctx = {
            workFlowShowUrl: this.model.workFlowShowUrl(),
            canOpen: this.model.canOpen() && !this.locationSourceDisabled(),
            canUpdate: this.canUpdate()
        };
        ctx.locations  = _.map(this.model.executionLocations(), function (executionLocation) {
            if (!_.isUndefined(executionLocation.dataSource)) {
                stateText = executionLocation.dataSource().stateText();
                stateUrl  = executionLocation.dataSource().stateIconUrl();
            } else if (!_.isUndefined(executionLocation.attributes.state)) {
                stateText = executionLocation.stateText();
                stateUrl  = executionLocation.stateIconUrl();
            }

            if (executionLocation.get("entityType") === "gpdb_database") {
                return [executionLocation.dataSource().get("name") + '.' + executionLocation.get("name"), stateText, stateUrl];
            } else {
                return [executionLocation.get("name"), stateText, stateUrl];
            }
        });

        return ctx;
    },

    locationSourceDisabled: function(){
        var location = this.model.executionLocations()[0];
        var source_disabled = false;

        if (location && !_.isUndefined(location.dataSource)) {
            source_disabled = location.dataSource().isDisabled() || location.dataSource().isIncomplete();
        } else if (location && !_.isUndefined(location.isDisabled)) {
            source_disabled = location.isDisabled() || location.isIncomplete();
        }

        return source_disabled;
    },

    changeWorkfileDatabase: function(e) {
        e.preventDefault();
        new chorus.dialogs.ChangeWorkFlowExecutionLocation({
            model: this.model
        }).launchModal();
    },

    canUpdate: function(){
        return this.model.workspace().isActive() && this.model.workspace().canUpdate();
    },

    navigateToWorkFlow: function(){
        this.model.notifyWorkflowLimitedDataSource();
        chorus.router.navigate(this.model.workFlowShowUrl());
    }
});
