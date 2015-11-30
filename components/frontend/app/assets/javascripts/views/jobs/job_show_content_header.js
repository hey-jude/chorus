chorus.views.JobShowContentHeader = chorus.views.Base.extend({
    constructorName: "JobShowContentHeader",
    templateName: "job_show_content_header",

    jobsIconPath: "/images/jobs/",
    //jobIconActive: "job.svg",
    jobIconActiveOndemand: "job-ondemand.svg",
    jobIconActiveScheduled: "job-scheduled.svg",
    jobIconDisabled: "job-scheduled-disabled.svg",

    additionalContext: function () {
        return {
            iconUrl: this.iconUrl(),
            frequency: this.model.frequency(),
            lastRunStatusKey: this.model.lastRunStatusKey(),
            lastRunLinkKey: this.model.lastRunLinkKey(),
            ownerName: this.model.owner().displayName(),
            ownerUrl: this.model.owner().showUrl()
        };
    },

    iconUrl: function () {
        // job entity icon
        var icon = (this.model.get('enabled') || this.model.runsOnDemand()) ? this.jobTypeIcon() : this.jobIconDisabled;
        return this.jobsIconPath + icon;
    },

    jobTypeIcon: function() {
        return ( this.jobTypeKey() === "on_demand") ? this.jobIconActiveOndemand : this.jobIconActiveScheduled;
    },

    jobTypeKey: function() {
        // which type of job is this
        if (this.model.runsOnDemand()) {
            return 'on_demand';
        } else {
            return 'scheduled';
        };
    },

});