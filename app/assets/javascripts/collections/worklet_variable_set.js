chorus.collections.WorkletVariableSet = chorus.collections.Base.extend({
    constructorName: "WorkletVariableSet",
    model: chorus.models.WorkletVariable,
    urlTemplate: "workspaces/{{workspaceId}}/worklets/{{workletId}}/variables"
});
