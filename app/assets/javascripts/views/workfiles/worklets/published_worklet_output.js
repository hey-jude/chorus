chorus.views.PublishedWorkletOutput = chorus.views.Base.extend({
    constructorName: "PublishedWorkletOutputView",
    templateName: "worklets/published_worklet_output",

    events: {
        'click #share_all_results button': 'openShareResultsDialog'
    },

    setup: function() {
        this.resultsId = this.options.resultsId;
        this.worklet = this.options.worklet;
        this.resultsUrl = this.options.resultsUrl;
    },

    postRender:function() {
        this.$("#results").on("load", function () {
            if(this.getAttribute('src')) {
                $('#share_all_results').show();
                $('#workletResults_loading').hide();
                this.style.height='1000px';
            }
        });
    },

    openShareResultsDialog: function(e) {
        e && e.preventDefault();
        var dialog = new chorus.dialogs.ShareWorkletResultsDialog({
            resultsId: this.resultsId,
            worklet: this.worklet,
            activeOnly: true
        });
        dialog.launchModal();
    },

    additionalContext: function() {
        return {
            hasNoResults: _.isUndefined(this.resultsUrl),
            resultsUrl: this.resultsUrl,
            isPublished: this.worklet && this.worklet.get('fileType') === 'published_worklet'
        };
    }
});