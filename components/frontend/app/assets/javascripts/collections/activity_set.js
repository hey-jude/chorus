chorus.collections.ActivitySet = chorus.collections.Base.extend({
    constructorName: "ActivitySet",
    model: chorus.models.Activity,
    per_page: 20,

    setup: function() {
        this.bind("reset", this.reindexErrors);
    },

    reindexErrors: function() {
        _.each(this.models, function(activity) {
            activity.reindexError();
        });
    },

    urlTemplate: function() {
        return this.attributes.insights ? 'insights' : 'activities';
    },

    urlParams: function() {
        var params = {};
        if(this.attributes.entity) {
            params.entityType = this.attributes.entity.entityType;
            params.entityId = this.attributes.entity.get('id');
        } else {
            params.entityType = 'dashboard';
        }

        if(this.attributes.resultsOnly) {
            params.resultsOnly = true;
        }
        if(this.attributes.currentUserOnly) {
            params.currentUserOnly = true;
        }
        return params;
    }
});
