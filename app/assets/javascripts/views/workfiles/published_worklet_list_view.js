chorus.views.PublishedWorkletList = chorus.views.Base.extend({
    constructorName: "PublishedWorkletListView",
    templateName: "published_worklet_list",

    additionalContext: function() {
        return {
            emptyListTranslationKey: "entity.name.PublishedWorklet.none"
        };
    },

    collectionModelContext: function (model) {
        return {
            url: model.showUrl()
        };
    },

});
