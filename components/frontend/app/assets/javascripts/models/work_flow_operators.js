chorus.models.WorkFlowOperators = chorus.models.Base.extend({
    constructorName: "WorkFlowOperators",

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

//    normalizeName: function(op) {
//        return op.name.replace(/ /g, " ").replace(/[^a-zA-Z0-9]/g, "");
//    },

    getOperators: function() {
        return _.filter(this.attributes, function(a) { return typeof(a) === 'object'; });
    },

    urlTemplate: "alpinedatalabs/main/chorus.do?method=getFlowOperators&session_id={{sessionId}}&workfile_id={{workfileId}}"
});