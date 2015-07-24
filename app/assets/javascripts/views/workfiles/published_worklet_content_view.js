chorus.views.PublishedWorkletContent = chorus.views.Base.extend({
    templateName: "published_worklet_content",

    subviews: {
        ".worklet_output": "workletOutput",
        ".worklet_history": "workletHistory",
        ".worklet_submit": "workletSubmit"
    },

    setup: function() {
        this.workletOutput = new chorus.views.PublishedWorkletOutput();
        var history_options = {
            model: this.model,
            collection: this.collection,
            mainPage: this.options.mainPage
        };
        this.workletHistory = new chorus.views.PublishedWorkletHistory(history_options);
        var submit_options = {
            model: this.model,
            variables: this.model.get('variables'),
            historyView: this.workletHistory
        };
        this.workletSubmit = new chorus.views.PublishedWorkletSubmit(submit_options);
    },

    additionalContext: function () {
        return {
           imagePath: this.model.imageUrl()
        };
    }
});