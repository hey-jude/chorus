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

    urlTemplate: "alpinedatalabs/main/chorus.do?method=getVariableModel&session_id={{sessionId}}&workfile_id={{workfileId}}"
});