chorus.views.PublishedWorkletHistory = chorus.views.Base.extend({
    constructorName: "PublishedWorkletHistoryView",
    templateName: "worklets/published_worklet_history",

    setup: function() {
        this.worklet = this.options.worklet;
        this.history = this.options.history;
        this.mainPage = this.options.mainPage;

        this.subscribePageEvent("worklet:history_entry_clicked", this.historyEntryClicked);
        this.listenTo(this.history, "loaded", this.render);
    },

    preRender: function() {
        this.historyItems = _.map(this.history.models, function(model, index) {
            var view = new chorus.views.PublishedWorkletHistoryEntry({
                model: model,
                index: this.history.length - index,
                mainPage: this.mainPage
            });

            this.registerSubView(view);
            return view;
        }, this);
    },

    postRender: function() {
        var attachPoint = this.$('.worklet_history_list');
        if (this.historyItems.length) {
            // Renders each subview into a document fragment container first
            // so as to not incrementally re-render inefficiently
            var container = document.createDocumentFragment();
            _.each(this.historyItems, function(historyItem) {
                container.appendChild(historyItem.render().el);
            });
            attachPoint.append(container);
        }

        if (this._showLatestEntry === true) {
            this.historyItems[0].showResults();
            this._showLatestEntry = false;
        }
    },

    historyEntryClicked: function(entry) {
        this._showLatestEntry = false;
    },

    additionalContext: function() {
        return {
            isEmpty: !this.history || this.history.length === 0
        };
    }
});