chorus.models.WorkletPublished = chorus.models.Worklet.include(
    ).extend({
        constructorName: "WorkletPublished",
        entityType: "workletPublished",

        defaults: {
            entitySubtype: "workletPublished"
        },

        urlTemplate: function(options) {
            return "worklet";
        }
    });
