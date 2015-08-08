chorus.collections.WorkletParameterVersionSet = chorus.collections.Base.extend({
    constructorName: "WorkletParameterVersionSet",
    model: chorus.models.WorkletParameterVersion,
    urlTemplate: "worklet_parameter_versions/",

    urlParams: function() {
        return {
            eventId: this.attributes.eventId
        };
    }
});
