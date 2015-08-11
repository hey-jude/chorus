chorus.views.PublishedWorkletHistory = chorus.views.Base.extend({
    constructorName: "PublishedWorkletHistoryView",
    templateName: "worklets/published_worklet_history",

    setup: function() {
        this.model = this.options.model;
        this.collection = this.options.collection;
        this.mainPage = this.options.mainPage;
    },

    preRender: function() {
        this.historyItems = _.map(this.collection.models, function(model, index) {
            var view = new chorus.views.PublishedWorkletHistoryItem({
                model: model,
                index: this.collection.length - index,
                mainPage: this.mainPage
            });

            this.registerSubView(view);

            return view;
        }, this);
    },

    postRender:function() {
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
    },

    additionalContext: function() {
        return {
            isEmpty: !this.collection || this.collection.length === 0
        };
    }

});