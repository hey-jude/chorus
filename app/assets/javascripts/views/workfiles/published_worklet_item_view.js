chorus.views.PublishedWorkletItem = chorus.views.Base.include(chorus.Mixins.TagsContext).extend({
    constructorName: "PublishedWorkletItemView",
    templateName: "published_worklet_item",
    tagName: "div",

    subviews: {
        ".summary": "summary"
    },

    additionalContext: function() {
        return _.extend(this.additionalContextForTags(), {
            name: this.model.get('fileName'),
            id: this.model.get('id'),
            url: this.model.showUrl()
        });
    },

    summary: function() {
        return new chorus.views.TruncatedText({model: this.model, attribute: "summary", attributeIsHtmlSafe: true});
    },

    postRender: function() {

    }
});
