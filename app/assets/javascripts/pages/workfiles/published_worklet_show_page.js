chorus.pages.PublishedWorkletShowPage = chorus.pages.Base.extend({
    setup: function(workletId) {
        this.subscribePageEvent("worklet:run", this.runEventHandler);
        this.subscribePageEvent("menu:worklet", this.menuEventHandler);

        this.worklet = new chorus.models.PublishedWorklet({ id:workletId });
        this.worklet.fetch();
        this.handleFetchErrorsFor(this.worklet);

        this.pollForRunStatus = _.bind(function() {
            this.worklet.fetch({
                success: _.bind(function(model) {
                    if(!model.get('running')) {
                        clearInterval(this.pollerID);
                        chorus.PageEvents.trigger("worklet:run", "runStopped");
                        if(this.clickedStop) {
                            this.clickedStop = false;
                        }
                        else {
                            var activities = model.activities();
                            activities.loaded = false;
                            activities.fetchAll();
                            this.onceLoaded(activities, this.reloadHistory);
                        }
                    }
                    else {
                        this.sidebar.runEventHandler('runStarted');
                    }
                }, this)
            });
        }, this);

        this.onceLoaded(this.worklet, this.buildPage);
    },

    menuEventHandler: function(menu_item) {
        if (menu_item === 'close') {
            this.closePage();
        }
    },

    closePage: function() {
        chorus.router.navigate('#/touchpoints');
    },

    runEventHandler: function(event) {
        if (event === 'runStarted') {
            this.pollerID = setInterval(this.pollForRunStatus, 1000);
        }
        else if( event === 'clickedStop') {
            this.clickedStop = true;
        }
    },

    reloadHistory: function() {
        this.mainContent.content.workletHistory.collection = this.worklet.activities();
        this.mainContent.content.workletHistory._showLatestEntry = true;
        this.mainContent.content.workletHistory.render();
    },

    showHistory: function() {
        var newView = new chorus.views.PublishedWorkletHistory({
            worklet: this.worklet,
            collection: this.history,
            mainPage: this
        });

        if (this.mainContent.content.workletHistory) {
            this.mainContent.content.workletHistory.teardown(true);
        }
        this.mainContent.content.workletHistory = newView;
        this.mainContent.content.renderSubview('workletHistory');

        this.trigger('resized');
    },

    buildPage: function() {
        this.history = this.worklet.activities({resultsOnly: true, currentUserOnly: true});
        this.history.fetchAll();
        this.onceLoaded(this.history, this.showHistory);

        this.headerView = new chorus.views.WorkletHeader({
            model: this.worklet,
            menuOptions: [],
            state: 'publishedRun'
        });

        this.subNav = this.headerView;
        this.sidebar = new chorus.views.WorkletParameterSidebar({
            worklet: this.worklet,
            state: 'running'
        });

        this.contentView = new chorus.views.PublishedWorkletContent({
            worklet: this.worklet,
            collection: this.history,
            mainPage: this
        });

        this.mainContent = new chorus.views.MainContentView({
            worklet: this.worklet,
            content: this.contentView
        });

        this.render();

        if(this.worklet.get('running')) {
            chorus.PageEvents.trigger("worklet:run", "runStarted");
        }

    }
});