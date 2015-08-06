//= require ./worklet
chorus.models.PublishedWorklet = chorus.models.Worklet.include(
).extend({
    constructorName: "PublishedWorklet",
    entityType: "published_worklet",

    urlTemplate: function(options) {
        var action = options && options.workflow_action;

        // KT TODO: This is temporary.  Will fixup when I take care of https://alpine.atlassian.net/browse/DEV-11828
        if (action === 'image') {
            return "workspaces/{{workspace.id}}/worklets/{{this.id}}/image";
        }

        var url =  "worklets/{{id}}";
        if (action === 'run') {
            url += "/run/";
        }

        return url;
    },
    showUrlTemplate: "worklets/{{id}}",

    defaults: {
        entitySubtype: "published_worklet"
    },

    run: function(worklet_parameters) {
        this.save({worklet_parameters: worklet_parameters}, {
            workflow_action: 'run'
        });
    }
});
