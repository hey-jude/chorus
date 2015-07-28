//= require ./worklet
chorus.models.PublishedWorklet = chorus.models.Worklet.include(
).extend({
    constructorName: "PublishedWorklet",
    entityType: "published_worklet",

    urlTemplate: function(options) {
        var action = options && options.workflow_action;
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
