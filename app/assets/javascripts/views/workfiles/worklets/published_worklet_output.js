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
        this.outputTable = this.options.outputTable;

        // display a placeholder when we don't have any run history
        this.history = this.worklet.activities({resultsOnly: true, currentUserOnly: true});
        this.listenTo(this.history, 'loaded', this.historyLoaded);
    },

    historyLoaded: function() {
        // Flag history loaded to true and rerender if we haven't yet
        if (_.isUndefined(this._historyLoaded)) {
            this._historyLoaded = true;
            this.render();
        }

    },

    postRender:function() {
        this.$("#results").on("load", function () {
            if(this.getAttribute('src')) {
                $('#share_all_results').show();
                $('#workletResults_loading').hide();
                this.style.height='900px';
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
            resultsUrl: this.resultsUrl,
            isPublished: this.worklet && this.worklet.get('fileType') === 'published_worklet' && this.outputTable,
            hasNoResults: _.isUndefined(this.resultsUrl),
            // Only flag no history when we have no results, history is loaded, and history list is empty
            hasNoHistory: _.isUndefined(this.resultsUrl) && this._historyLoaded === true && this.history.length === 0
        };
    }
});