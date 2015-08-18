chorus.views.PublishedWorkletContent = chorus.views.Base.extend({
    templateName: "worklets/published_worklet_content",

    subviews: {
        ".worklet_output": "workletOutput",
        ".worklet_history": "workletHistory"
    },

    setup: function() {
        this.workletOutput = new chorus.views.PublishedWorkletOutput({
            worklet: this.model
        });
        var history_options = {
            model: this.model,
            collection: this.collection,
            mainPage: this.options.mainPage
        };
        this.workletHistory = new chorus.views.PublishedWorkletHistory(history_options);
    },

    additionalContext: function () {
        return {
           imagePath: this.model.imageUrl()
        };
    }
});