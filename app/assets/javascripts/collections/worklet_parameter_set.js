chorus.collections.WorkletParameterSet = chorus.collections.Base.extend({
    constructorName: "WorkletParameterSet",
    model: chorus.models.WorkletParameter,
    urlTemplate: "workspaces/{{workspaceId}}/touchpoints/{{workletId}}/parameters",

    urlParams: function() {
        return {
            workspaceId: this.attributes.workspaceId,
            workletId: this.attributes.workletId
        };
    }
});
