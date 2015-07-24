chorus.views.PublishedWorkletHistory = chorus.views.Base.extend({
    constructorName: "PublishedWorkletHistoryView",
    templateName: "published_worklet_history",

    setup: function() {
        this.model = this.options.model;
        this.collection = this.options.collection;
        this.mainPage = this.options.mainPage;
        this.render();
    },

    postRender:function() {
        var attachPoint = this.$('.worklet_history_list');
        this.collection && this.collection.each(function(model, index) {
            var view = new chorus.views.PublishedWorkletHistoryItem({
                model: model,
                index: this.collection.length - index,
                mainPage: this.mainPage
            });
            attachPoint.append(view.render().el);
        }, this);
    }

});