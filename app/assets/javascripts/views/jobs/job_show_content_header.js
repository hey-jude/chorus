chorus.views.JobShowContentHeader = chorus.views.Base.extend({
    constructorName: "JobShowContentHeader",
    templateName: "job_show_content_header",

    jobsIconPath: "/images/jobs/",
    jobIconActive: "job.svg",
    jobIconDisabled: "job-disabled.svg",

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
        var icon = (this.model.get('enabled') || this.model.runsOnDemand()) ? this.jobIconActive : this.jobIconDisabled;
        return this.jobsIconPath + icon;
    },
    
});