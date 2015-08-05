chorus.views.PublishedWorklet = chorus.views.Base.include(chorus.Mixins.TagsContext).extend({
    constructorName: "PublishedWorkletView",
    templateName: "published_worklet",
    tagName: "div",

    additionalContext: function() {
        return _.extend(this.additionalContextForTags(), {
            name: this.model.get('fileName'),
            id: this.model.get('id'),
            url: this.model.showUrl()
        });
    }
});
