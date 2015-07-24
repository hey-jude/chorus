chorus.pages.PublishedWorkletShowPage = chorus.pages.Base.extend({

    setup: function(workletId) {
        this.publishedWorklet = new chorus.models.PublishedWorklet({id:workletId});
        this.publishedWorklet.fetch();

        this.onceLoaded(this.publishedWorklet, this.fetchHistory);
    },

    fetchHistory: function() {
        this.history = this.publishedWorklet.activities({resultsOnly: true, currentUserOnly: true});
        this.history.fetchAll();
        this.onceLoaded(this.history, this.buildPage);
    },

    updateMiddleContent: function(newView) {
        if (this.mainContent.content.workletOutput) {
            this.mainContent.content.workletOutput.teardown(true);
        }

        this.mainContent.content.workletOutput = newView;
        this.mainContent.content.renderSubview('workletOutput');

        this.trigger('resized');
    },

    buildPage: function() {
        var options = {
            model: this.publishedWorklet,
            collection: this.history,
            mainPage: this
        };
        var contentView = new chorus.views.PublishedWorkletContent(options);
        this.mainContent = new chorus.views.MainContentView({
            content: contentView
        });

        this.render();
    }
});

