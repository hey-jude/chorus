//= require ./worklet
chorus.models.PublishedWorklet = chorus.models.Worklet.include(
).extend({
    constructorName: "PublishedWorklet",
    entityType: "published_worklet",

    urlTemplate: function(options) {
        var action = options && options.workflow_action;

        // KT TODO: This is temporary.  Will fixup when I take care of https://alpine.atlassian.net/browse/DEV-11828
        if (action === 'image') {
            return "workspaces/{{workspace.id}}/touchpoints/{{this.id}}/image";
        }

        var url =  "touchpoints/{{id}}";
        if (action === 'run') {
            url += "/run/";
        }
        else if (action === 'stop') {
            url += "/stop/";
        }

        return url;
    },
    showUrlTemplate: "touchpoints/{{id}}",

    defaults: {
        entitySubtype: "published_worklet"
    },

    // This is necessary to make sure collaborators can run a published worklet
    canEdit: function() {
        return this.isLatestVersion() && this.workspace().isActive();
    },

    run: function(worklet_parameters) {
        this.save({worklet_parameters: worklet_parameters}, {
            workflow_action: 'run',
            unprocessableEntity: _.bind(function(e) {
                if(this.serverErrorMessage()) {
                    chorus.toast(this.serverErrorMessage(), {skipTranslation: true, toastOpts: {type: "error"}});
                }
                else {
                    chorus.toast('work_flows.start_running_unprocessable.toast', {toastOpts: {type: "error"}});
                }
            }, this)
        });
    },

    stop: function() {
        this.save({}, {
            workflow_action: 'stop',
            method: 'create'
        });
    }
});
