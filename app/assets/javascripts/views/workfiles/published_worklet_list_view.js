chorus.views.PublishedWorkletList = chorus.views.Base.extend({
    constructorName: "PublishedWorkletListView",
    templateName: "published_worklet_list",

    collectionModelContext: function (model) {
        return {
            url: model.showUrl(),
            avatarUrl: model.url({workflow_action: 'image'})
        };
    },

    postRender: function() {
        // KT: a hack to adapt list_content_details.hbs to our needs:
        $(".list_content_details").find(".count").detach().prependTo('.list_content_details');
    }
});
