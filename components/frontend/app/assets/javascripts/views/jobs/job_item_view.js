chorus.views.JobItem = chorus.views.Base.extend({
    constructorName: "JobItemView",
    templateName: "job_item",

    jobsIconPath: "/images/jobs/",
    //jobIconActive: "job.svg",
    jobIconActiveOndemand: "job-ondemand.svg",
    jobIconActiveScheduled: "job-scheduled.svg",
    jobIconDisabled: "job-scheduled-disabled.svg",

    events: {
        'click a.last_run_date': 'launchLastRunJobResultDetails'
    },

    setup: function() {
        this._super("setup", arguments);
        this.listenTo(this.model, "invalidated", function() { this.model.fetch(); });
    },

    additionalContext: function () {
        return {
            iconUrl: this.iconUrl(),
            isJobActive:  this.isJobActive(),
            url: this.model.showUrl(),
            frequency: this.model.frequency(),
            stateKey: "job.state." + this.jobStateKey(),
            lastRunStatusKey: this.model.lastRunStatusKey(),
            lastRunLinkKey: this.model.lastRunLinkKey(),
            running: this.model.isRunning()
        };
    },

    postRender: function() {
        this.$(".loading_spinner").startLoading(null, {color: '#959595'});
    },

    jobStateKey: function () {
        if (this.model.isRunning()) {
            return 'running';
        } else if (this.model.isStopping()) {
            return 'stopping';
        } else if (this.model.runsOnDemand()) {
            return 'on_demand';
        }
        return this.model.get('enabled') ? 'scheduled' : 'disabled';
    },

    isJobActive: function() {
        return this.jobStateKey() !== "disabled" ? true : false;
    },

    iconUrl: function () {
        // job entity icon
        // var icon = (this.model.get('enabled') || this.model.runsOnDemand()) ? this.jobIconActive : this.jobIconDisabled;
        var icon = (this.model.get('enabled') || this.model.runsOnDemand()) ? this.jobTypeIcon() : this.jobIconDisabled;
        return this.jobsIconPath + icon;
    },

    jobTypeIcon: function() {
        return ( this.model.jobTypeKey() === "on_demand") ? this.jobIconActiveOndemand : this.jobIconActiveScheduled;
    },

    launchLastRunJobResultDetails: function (e) {
        e && e.preventDefault();
        new chorus.dialogs.JobResultDetail({job: this.model}).launchModal();
    }
});