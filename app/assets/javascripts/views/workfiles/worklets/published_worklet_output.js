chorus.views.PublishedWorkletOutput = chorus.views.Base.extend({
    constructorName: "PublishedWorkletOutputView",
    templateName: "worklets/published_worklet_output",

    setup: function() {
        this.resultsId = this.options.resultsId;
        this.worklet = this.options.worklet;
        this.resultsUrl = this.options.resultsUrl;
        this.outputTable = this.options.outputTable;
        this.flowResultsId = this.options.flowResultsId;

        // display a placeholder when we don't have any run history
        this.history = this.worklet.activities({resultsOnly: true, currentUserOnly: true});
        this.listenTo(this.history, 'loaded', this.historyLoaded);
        this.subscribePageEvent("worklet:open_share_results_dialog", this.openShareResultsDialog);
        this.subscribePageEvent("worklet:export_html_report", this.exportHTMLReport);
        this.subscribePageEvent("worklet:view_logs", this.viewLogs);
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
    },

    viewLogs: function(e) {
        e && e.preventDefault();
        var flowId = this.worklet.id;
        var flowResultsId = this.flowResultsId;
        var dialog = new chorus.dialogs.WorkletViewLogsDialog({
            resultsId: flowResultsId,
            flowId: flowId
        });
        dialog.launchModal();
    },

    exportHTMLReport: function(e) {
        e && e.preventDefault();
        this.postMessageToIframe({'action': 'export'}, '*');
    },

    postMessageToIframe: function(message, context) {
        this.iframe().contentWindow.postMessage(message, context);
    },

    iframe: function() {
        return this.$("iframe#results")[0];
    }
});