chorus.views.PublishedWorkletContent = chorus.views.Base.extend({
    templateName: "worklets/published_worklet_content",

    subviews: {
        ".worklet_output": "workletOutput",
        ".worklet_history": "workletHistory"
    },

    setup: function() {
        this.worklet = this.options.worklet;
        this.history = this.options.history;

        this.workletOutput = new chorus.views.PublishedWorkletOutput({
            worklet: this.worklet
        });

        this.workletHistory = new chorus.views.PublishedWorkletHistory({
            worklet: this.worklet,
            history: this.history,
            mainPage: this.options.mainPage
        });
    },

    additionalContext: function () {
        return {
           imagePath: this.worklet.imageUrl()
        };
    }
});