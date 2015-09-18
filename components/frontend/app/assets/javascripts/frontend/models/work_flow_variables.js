chorus.models.WorkFlowVariables = chorus.models.Base.extend({
    constructorName: "WorkFlowVariable",

    initialize: function(options) {
        this.set('sessionId', chorus.session.get('sessionId'));
        this.set('workfileId', options.workfile_id);
    },

    hasOwnPage: function() {
        return true;
    },

    showUrl: function() {
        return this.url();
    },

    useExternalLink: function() {
        return true;
    },

    camelizeKeys: function(response) {
        // override the camelizing of keys that normally takes place when fetching data
        // we don't want to
        return response;
    },

    urlTemplate: "alpinedatalabs/main/chorus.do?method=getVariableModel&session_id={{sessionId}}&workfile_id={{workfileId}}"
});