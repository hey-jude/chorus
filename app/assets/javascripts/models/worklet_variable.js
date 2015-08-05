chorus.models.WorkletVariable = chorus.models.Base.extend({
    constructorName: "WorkletVariable",
    urlTemplate: "workspaces/{{workspaceId}}/worklets/{{workletId}}/variables/{{id}}",

    //showUrlTemplate: "workspaces/{{workspaceId}}/worklets/{{workletId}}/variables/{{id}}",
    //
    //urlTemplate: function(options) {
    //    var method = options && options.method;
    //    var url =  "workspaces/{{workspaceId}}/worklets/{{workletId}}/variables";
    //
    //    if (method !== 'create') {
    //        url += '/' + this.id;
    //    }
    //
    //    return url;
    //},

    initialize: function(options) {
        if (this.collection) {
            this.set('workspaceId', this.collection.attributes.workspaceId);
            this.set('workletId', this.collection.attributes.workletId);
        } else {
            this.set('workspaceId', options.workspaceId);
            this.set('workletId', options.workletId);
        }
    }
});
