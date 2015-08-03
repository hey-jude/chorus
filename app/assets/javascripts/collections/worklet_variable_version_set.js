chorus.collections.WorkletVariableVersionSet = chorus.collections.Base.extend({
    constructorName: "WorkletVariableVersionSet",
    model: chorus.models.WorkletVariableVersion,
    urlTemplate: "worklet_variable_versions/",

    urlParams: function() {
        return {
            eventId: this.attributes.eventId
        };
    }
});
