chorus.views.PublishedWorkletList = chorus.views.Base.extend({
    constructorName: "PublishedWorkletListView",
    templateName: "published_worklet_list",

    collectionModelContext: function (model) {
        return {
            url: model.showUrl()
        };
    },

});
