;(function(ns) {
    ns.models.WorkfileVersionSet = ns.models.Collection.extend({
        urlTemplate : "workspace/{{workspaceId}}/workfile/{{workfileId}}/version",
        model : ns.models.WorkfileVersion
    });
})(chorus);