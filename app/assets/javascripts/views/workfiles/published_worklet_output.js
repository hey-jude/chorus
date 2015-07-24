chorus.views.PublishedWorkletOutput = chorus.views.Base.extend({
    constructorName: "PublishedWorkletOutputView",
    templateName: "published_worklet_output",

    setup: function() {
        this.render();
    },

    postRender:function() {

    },

    additionalContext: function() {
        return {
            resultsUrl: this.options.resultsUrl
        };
    }
});